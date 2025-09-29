class GetUrl {
  static const user = 'user/Get';
  static const home = 'home/Get';
  //
}

class PostUrl {
  static const users = 'user/GetAll';
  static const createUser = 'user/Add';
  static const homes = 'home/GetAll';
  static const createHome = 'home/Add';
  //
}

class PutUrl {
  static const updateUser = 'user/Update';
  static const updateHome = 'home/Update';
  //
}

class DeleteUrl {
  static const deleteUser = 'user/Delete';
  static const deleteHome = 'home/Delete';
  //
}

class PatchUrl {
  //
}

const additionalConst = '/api/v1/';
const localUrl = '192.168.1.107:5001';
const liveUrl = 'portal-be.coretech-mena.com';

String get baseUrl {
  // return localUrl;
  return liveUrl;
}

String imagePath = 'http://$baseUrl/documents/';