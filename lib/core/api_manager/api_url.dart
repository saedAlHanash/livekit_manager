class GetUrl {
  static const setting = 'Room/Get';
  static const room = 'Room/Get';
  static const user = 'user/Get';
  static const home = 'home/Get';
//
}

class PostUrl {
  static const settings = 'Room/GetAll';
  static const createSetting = 'Room/Add';
  static const rooms = 'Room/GetAll';
  static const createRoom = 'Room/Add';
  static const users = 'user/GetAll';
  static const createUser = 'user/Add';
  static const homes = 'home/GetAll';
  static const createHome = 'home/Add';

  static const suspend = 'Index/Suspend';

  static String resume = 'Index/Resume';

  static String suspendAll = 'Index/SuspendAll';

  static String resumeAll = 'Index/ResumeAll';

  static String allowScreenShare = 'Index/AllowScreenShare';

  static String stopScreenShare = 'Index/StopScreenShare';

  static String allowCamera = 'Index/AllowCamera';

  static String stopCamera = 'Index/StopCamera';

  static String allowAudio = 'Index/AllowAudio';

  static String stopAudio = 'Index/StopAudio';

  static String Kick = 'Index/Kick';
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
const localUrl = 'coretik-be.coretech-mena.com';
const liveUrl = 'portal-be.coretech-mena.com';

String get baseUrl {
  return localUrl;
  // return liveUrl;
}

String imagePath = 'http://$baseUrl/documents/';
