class GetUrl {
  static const setting = 'Room/Get';
  static const room = 'Room/Get';
  static const user = 'user/Get';
  static const home = 'home/Get';

  static const loggedUser = 'Auth/GetLoggedUser';

  static const staffDetails = 'Staff/GetStaffDetails';

  static const staffRecord = 'StaffRecord/Get';

  static String activeSessions = 'Lesson/GetTeacherActiveSessions';
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

  static const resume = 'Index/Resume';

  static const suspendAll = 'Index/SuspendAll';

  static const resumeAll = 'Index/ResumeAll';

  static const allowScreenShare = 'Index/AllowScreenShare';

  static const stopScreenShare = 'Index/StopScreenShare';

  static const allowCamera = 'Index/AllowCamera';

  static const stopCamera = 'Index/StopCamera';

  static const allowAudio = 'Index/AllowAudio';

  static const stopAudio = 'Index/StopAudio';

  static const kick = 'Index/Kick';

  static const sendMessage = 'Index/SendData';

  static const loginUrl = 'Auth/login';

  static const logout = 'Auth/Logout';

  static const staffRecords = 'StaffRecord/GetAll';
  static const createStaffRecord = 'StaffRecord/Add';
}

class PutUrl {
  static const updateSetting = 'Room/Update';
  static const updateRoom = 'Room/Update';
  static const updateUser = 'user/Update';
  static const updateHome = 'home/Update';
  static const updateStaffRecord = 'StaffRecord/Update';
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

const wsLocalUrl = 'ws://192.168.1.69:7880';
const wsLiveTest = 'ws://87.106.161.145:7880';
const wsLiveUrl = 'wss://coretik.coretech-mena.com';

const localUrl = '192.168.1.69:5002';
const liveUrl = 'coretik-be.coretech-mena.com';

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
