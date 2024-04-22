class Admin_register_form {
  String _firstName;
  String _lastName;
  String _middleName;
  String _password;

  Admin_register_form(
      this._firstName, this._lastName, this._middleName, this._password
      );
  String toParams() => "?firstName=${_firstName.toString()}&lastName=${_lastName.toString()}&middleName=${_middleName.toString()}&password=${_password.toString()}";
}