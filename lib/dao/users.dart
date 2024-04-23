import 'package:prak_tpm_http/service/base_network.dart';

class UserDataSource {
  static UserDataSource instance = UserDataSource();

  Future<Map<String, dynamic>> loadUsers() {
    return BaseNetwork.get("users");
  }

  Future<Map<String, dynamic>> loadUserDetail(int id) {
    return BaseNetwork.get("users/$id");
  }
}
