import 'dart:convert';

import 'package:http/http.dart' as http;

import '../strings/enum_manager.dart';
import '../util/pair_class.dart';
import 'api_service.dart';
import 'helpers_api/helper_api_service.dart';
import 'helpers_api/log_api.dart';
import 'livekit_config.dart';
import 'livekit_token_service.dart';

/// Direct HTTP client for LiveKit's Twirp API.
///
/// Replaces the legacy .NET proxy `coretik-be.coretech-mena.com/api/v1/Index/...`
/// All endpoints hit: `https://<domain>/twirp/livekit.RoomService/<Method>`
class LiveKitTwirpClient {
  LiveKitTwirpClient._internal();

  static final LiveKitTwirpClient _instance = LiveKitTwirpClient._internal();

  factory LiveKitTwirpClient() => _instance;

  // ---------------------------------------------------------------------------
  // Headers — fresh admin JWT on every call (tokens are short-lived)
  // ---------------------------------------------------------------------------

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${LiveKitTokenService().generateAdminToken()}',
      };

  // ---------------------------------------------------------------------------
  // 1. Room Management
  // ---------------------------------------------------------------------------

  /// Replaces `/Index/CreateRoom`
  Future<Pair<Map<String, dynamic>?, String?>> createRoom({
    required String name,
    int maxParticipants = 100,
    int emptyTimeout = 300,
    String metadata = '',
  }) =>
      _post(
        '/CreateRoom',
        {
          'name': name,
          'max_participants': maxParticipants,
          'empty_timeout': emptyTimeout,
          if (metadata.isNotEmpty) 'metadata': metadata,
        },
      );

  /// Replaces `/Index/DeleteRoom`
  Future<Pair<Map<String, dynamic>?, String?>> deleteRoom(String roomName) =>
      _post('/DeleteRoom', {'room': roomName});

  // ---------------------------------------------------------------------------
  // 2. Participant Control
  // ---------------------------------------------------------------------------

  /// Replaces `/Index/Suspend`, `/Index/Resume`, `/Index/UpdateParticipant`
  ///
  /// Suspend  → canPublish:false, canSubscribe:false
  /// Resume   → canPublish:false, canSubscribe:true
  /// Full on  → canPublish:true,  canSubscribe:true
  Future<Pair<Map<String, dynamic>?, String?>> updateParticipant({
    required String roomName,
    required String identity,
    required bool canPublish,
    required bool canSubscribe,
    bool canPublishData = true,
    String? metadata,
  }) =>
      _post(
        '/UpdateParticipant',
        {
          'room': roomName,
          'identity': identity,
          'permission': {
            'can_publish': canPublish,
            'can_subscribe': canSubscribe,
            'can_publish_data': canPublishData,
          },
          if (metadata != null) 'metadata': metadata,
        },
      );

  /// Replaces `/Index/Kick`
  Future<Pair<Map<String, dynamic>?, String?>> removeParticipant({
    required String roomName,
    required String identity,
  }) =>
      _post('/RemoveParticipant', {'room': roomName, 'identity': identity});

  // ---------------------------------------------------------------------------
  // 3. Get Participant — used to resolve track_sid before muting
  // ---------------------------------------------------------------------------

  /// Returns the raw participant JSON (includes `tracks` array with `sid` and `type`).
  Future<Pair<Map<String, dynamic>?, String?>> getParticipant({
    required String roomName,
    required String identity,
  }) =>
      _post('/GetParticipant', {'room': roomName, 'identity': identity});

  // ---------------------------------------------------------------------------
  // 4. Media Muting
  // ---------------------------------------------------------------------------

  /// Replaces `/Index/StopCamera` and `/Index/StopAudio`.
  ///
  /// Two-step: resolves `track_sid` via [getParticipant], then calls [mutePublishedTrack].
  /// [trackType]: `'VIDEO'` or `'AUDIO'`
  Future<Pair<String?, String?>> muteTrackByType({
    required String roomName,
    required String identity,
    required String trackType,
    required bool muted,
  }) async {
    // Step 1: resolve track_sid
    final participantResult = await getParticipant(
      roomName: roomName,
      identity: identity,
    );

    if (participantResult.first == null) {
      return Pair(null, participantResult.second ?? 'Failed to get participant');
    }

    final tracks = participantResult.first!['tracks'] as List<dynamic>? ?? [];

    String? trackSid;
    for (final t in tracks) {
      final type = (t['type'] ?? '').toString().toUpperCase();
      // LiveKit returns type as string 'AUDIO'/'VIDEO' or int 0/1
      final matchAudio = trackType == 'AUDIO' && (type == 'AUDIO' || type == '0');
      final matchVideo = trackType == 'VIDEO' && (type == 'VIDEO' || type == '1');
      if (matchAudio || matchVideo) {
        trackSid = t['sid']?.toString();
        break;
      }
    }

    if (trackSid == null || trackSid.isEmpty) {
      // No active track of this type — treat as success (already muted/off)
      return Pair('no_track', null);
    }

    // Step 2: mute the track
    final muteResult = await mutePublishedTrack(
      roomName: roomName,
      identity: identity,
      trackSid: trackSid,
      muted: muted,
    );

    return Pair(muteResult.first != null ? trackSid : null, muteResult.second);
  }

  /// Low-level mute call. Prefer [muteTrackByType] for automatic track resolution.
  Future<Pair<Map<String, dynamic>?, String?>> mutePublishedTrack({
    required String roomName,
    required String identity,
    required String trackSid,
    required bool muted,
  }) =>
      _post(
        '/MutePublishedTrack',
        {
          'room': roomName,
          'identity': identity,
          'track_sid': trackSid,
          'muted': muted,
        },
      );

  // ---------------------------------------------------------------------------
  // 5. Data Signalling
  // ---------------------------------------------------------------------------

  /// Replaces `/Index/SendData`.
  ///
  /// [data] — plain UTF-8 string, auto-Base64-encoded before sending.
  /// [destinationIdentities] — empty list = broadcast to all.
  Future<Pair<Map<String, dynamic>?, String?>> sendData({
    required String roomName,
    required String data,
    List<String> destinationIdentities = const [],
  }) =>
      _post(
        '/SendData',
        {
          'room': roomName,
          'data': base64Encode(utf8.encode(data)),
          if (destinationIdentities.isNotEmpty)
            'destination_identities': destinationIdentities,
        },
      );

  // ---------------------------------------------------------------------------
  // 6. Room Metadata
  // ---------------------------------------------------------------------------

  /// Replaces `/Index/UpdateRoomMetaData`
  Future<Pair<Map<String, dynamic>?, String?>> updateRoomMetadata({
    required String roomName,
    required String metadata,
  }) =>
      _post('/UpdateRoomMetadata', {'room': roomName, 'metadata': metadata});

  // ---------------------------------------------------------------------------
  // Internal HTTP helper — mirrors APIService pattern
  // ---------------------------------------------------------------------------

  Future<Pair<Map<String, dynamic>?, String?>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.https(
      LiveKitConfig.lkHost,
      '${LiveKitConfig.twirpBase}$path',
    );

    logRequest(type: ApiType.post, url: uri.toString(), q: body);

    try {
      final response = await http
          .post(uri, body: jsonEncode(body), headers: _headers)
          .timeout(connectionTimeOut, onTimeout: () => timeOut);

      logResponse(url: path, response: response, type: ApiType.post);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> json =
            response.body.isEmpty ? {} : jsonDecode(response.body);
        return Pair(json, null);
      }

      return Pair(null, _extractTwirpError(response));
    } catch (e) {
      loggerObject.e('LiveKitTwirpClient [$path]: $e');
      return Pair(null, e.toString());
    }
  }

  /// Parses Twirp error response — format: `{ "code": "...", "msg": "..." }`
  String _extractTwirpError(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final msg = data['msg'] ?? data['message'] ?? data['error'];
      if (msg != null) return msg.toString();
    } catch (_) {}

    return switch (response.statusCode) {
      400 => 'Bad request — check payload',
      401 => 'Unauthorized — invalid API key or secret',
      403 => 'Forbidden — insufficient permissions',
      404 => 'Not found — room or participant does not exist',
      500 => 'LiveKit server error',
      _ => 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
    };
  }
}
