import 'package:my_cashbook/Models/UserModel.dart';

class AuthManager {
  UserModel? userModel;
  setUser(UserModel user) => userModel = user;
}
