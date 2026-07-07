class GetUrl {
  static const setting = 'Room/Get';
  static const room = 'Room/Get';
  static const user = 'user/Get';
  static const home = 'home/Get';
  //
}

class PostUrl {
  // ── IMS backend (ims-be.coretech-mena.com) ──
  static const settings = 'Room/GetAll';
  static const createSetting = 'Room/Add';
  static const rooms = 'Room/GetAll';
  static const createRoom = 'Room/Add';
  static const users = 'GroupTerm/GetGroupTermStudents';
  static const createUser = 'user/Add';
  static const homes = 'home/GetAll';
  static const createHome = 'home/Add';
  // ── LiveKit Twirp (via LiveKitTwirpClient) — no URL constants needed ──
}

class PutUrl {
  static const updateSetting = 'Room/Update';
  static const updateRoom = 'Room/Update';
  static const updateUser = 'user/Update';
  static const updateHome = 'home/Update';
  //
}

class DeleteUrl {
  static const deleteSetting = 'Room/Delete';
  static const deleteRoom = 'Room/Delete';
  static const deleteUser = 'user/Delete';
  static const deleteHome = 'home/Delete';
  //
}

class PatchUrl {
  //
}

const additionalConst = '/api/v1/';

// ── LiveKit WebSocket URLs (used by livekit_client SDK) ──
// These mirror LiveKitConfig.wssUrl — kept here for legacy SDK usage.
const wsLocalUrl = 'ws://192.168.1.69:7880';
const wsLiveTest = 'ws://87.106.161.145:7880';
const wsLiveUrl = 'wss://coretik.coretech-mena.com';

// ── IMS backend ──
const localUrl = '192.168.1.69:5002';
const liveUrl = 'ims-be.coretech-mena.com';

String get baseUrl {
  // return localUrl;
  return liveUrl;
}

String get wsLink {
  // return wsLocalUrl;
  // return wsLiveTest;
  return wsLiveUrl;
}

String imagePath = 'http://$baseUrl/documents/';
