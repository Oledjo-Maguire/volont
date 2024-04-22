class Users {
  String? _lastName;
  String? _firstName;
  String? _middleName;
  String? _city;
  String? _username;
  String? _password;
  bool? _admin;

  // Constructor with required parameters
  Users({
    required String lastName,
    required String firstName,
    required String middleName,
    required String city,
    required String username,
    required String password,
    required bool admin,
  })  : _lastName = lastName,
        _firstName = firstName,
        _middleName = middleName,
        _city = city,
        _username = username,
        _password = password,
        _admin = admin;

  String? get lastName => _lastName;
  String? get firstName => _firstName;
  String? get middleName => _middleName;
  String? get city => _city;
  String? get username => _username;
  String? get password => _password;
  bool? get admin => _admin;

  set firstName(String? value) {
    _firstName = value;
  }

  set middleName(String? value) {
    _middleName = value;
  }

  set city(String? value) {
    _city = value;
  }

  set username(String? value) {
    _username = value;
  }

  set password(String? value) {
    _password = value;
  }

  set admin(bool? value) {
    _admin = value;
  }

  set lastName(String? value) {
    _lastName = value;
  }

  @override
  String toString() {
    return 'User: ${firstName ?? ''} ${middleName ?? ''} ${lastName ?? ''}, City: ${city ?? ''}, Username: ${username ?? ''}, Admin: ${admin?.toString() ?? 'null'}';
  }

  // Login check function
  bool checkLogin(List<Users> usersList) {
    for (Users user in usersList) {
      if (user.username == username && user.password == password) {
        return true;
      }
    }
    return false;
  }

  Users? setCurrentUsername(String currUsername, String currPassword) {
    _username = currUsername;
    _password = currPassword;
  }
}
