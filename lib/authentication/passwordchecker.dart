bool validateStructure(String value) {
  String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}
