import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'livekit_config.dart';

/// Generates signed LiveKit JWT tokens locally using HS256.
/// No network call required — fully offline / synchronous.
class LiveKitTokenService {
  LiveKitTokenService._();

  static final LiveKitTokenService _instance = LiveKitTokenService._();

  factory LiveKitTokenService() => _instance;

  final _secret = SecretKey(LiveKitConfig.apiSecret);

  // ---------------------------------------------------------------------------
  // Admin token — used for all server-side Twirp API calls
  // ---------------------------------------------------------------------------

  /// Returns a signed admin JWT valid for **1 hour**.
  /// Grants: roomAdmin, roomCreate, roomList, roomRecord.
  String generateAdminToken() {
    final jwt = JWT(
      {
        'iss': LiveKitConfig.apiKey,
        'sub': 'admin',
        'nbf': _nowSeconds(),
        'exp': _nowSeconds() + 3600, // 1 hour
        'video': {
          'roomAdmin': true,
          'roomCreate': true,
          'roomList': true,
          'roomRecord': true,
        },
      },
    );

    return jwt.sign(_secret, algorithm: JWTAlgorithm.HS256);
  }

  // ---------------------------------------------------------------------------
  // Participant join token — used by livekit_client SDK to connect to a room
  // ---------------------------------------------------------------------------

  /// Returns a signed participant JWT valid for **6 hours**.
  ///
  /// [roomName] — target room.
  /// [identity]  — unique participant ID.
  /// [participantName] — display name.
  /// [videoGrants] — LiveKit VideoGrants map, e.g. `{ 'room': 'myRoom', 'roomJoin': true }`.
  String generateJoinToken({
    required String roomName,
    required String identity,
    required String participantName,
    Map<String, dynamic> videoGrants = const {},
  }) {
    final grants = <String, dynamic>{
      'room': roomName,
      'roomJoin': true,
      ...videoGrants,
    };

    final jwt = JWT(
      {
        'iss': LiveKitConfig.apiKey,
        'sub': identity,
        'name': participantName,
        'nbf': _nowSeconds(),
        'exp': _nowSeconds() + 21600, // 6 hours
        'video': grants,
      },
    );

    return jwt.sign(_secret, algorithm: JWTAlgorithm.HS256);
  }

  // ---------------------------------------------------------------------------

  int _nowSeconds() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
