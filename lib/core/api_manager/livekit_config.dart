class LiveKitConfig {
  LiveKitConfig._();

  /// Domain only — used in `Uri.https(host, path)`
  static const String lkHost = 'coretest-4xi5uo5z.livekit.cloud';

  /// LiveKit server WebSocket URL (used by livekit_client SDK to connect)
  static const String wssUrl = 'wss://coretest-4xi5uo5z.livekit.cloud';

  /// LiveKit server HTTPS URL (used for Twirp HTTP API calls)
  static const String httpsUrl = 'https://';

  /// LiveKit API Key
  static const String apiKey = 'APIQxZPjwpGoccr';

  /// LiveKit API Secret — keep confidential
  static const String apiSecret = 'irLRKBLlE7k1eRbMVOSwaZf5TVgyp30vTJI4OTWD3oD';

  /// Base Twirp path
  static const String twirpBase = '/twirp/livekit.RoomService';
}
