import 'package:path/path.dart';

const userNameCharacterPattern = r'[a-zA-Z0-9_\p{L}]+$';
final hashTagRegExp = RegExp(r"\B#[a-zA-Z0-9]+\b");
final userTagRegExp = RegExp(r"\B@[a-zA-Z0-9+]+\b");

extension StringValidator on String {
  bool isValidEmail() {
    final RegExp emailExp = RegExp(r'^[\w-\.+]+@([\w-]+\.)+[\w-]{2,6}$');
    return emailExp.hasMatch(this);
  }

  bool isOnlyAlphabet() {
    final RegExp alphabetOnRegExp = RegExp('[a-zA-Z]');

    return alphabetOnRegExp.hasMatch(this);
  }

  bool isOnlyNumber() {
    final RegExp numbersOnly = RegExp(r'[0-9]');
    return numbersOnly.hasMatch(this);
  }

  bool isValidName() {
    const namePattern = r'^[a-zA-Z-_ ]+$';
    return RegExp(namePattern).hasMatch(this);
  }

  bool isValidUserName() {
    return RegExp(userNameCharacterPattern).hasMatch(this);
  }

// Check if the input string matches the phone number format
  bool isValidPhone() {
    const phoneRegex = r'^(0[3|5|7|8|9])+([0-9]{8})$';

    return RegExp(phoneRegex).hasMatch(this);
  }

  bool isImageLink() {
    const pattern = r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)';
    return RegExp(pattern).hasMatch(this);
  }

  bool isPassword() {
    final RegExp passwordExp = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    return passwordExp.hasMatch(this);
  }

  String removeFirstZero() {
    return this.replaceFirst(RegExp('^0+'), '');
  }

  String getMaxLengthString(int maxLength, {bool hasThreedot = true}) {
    if (maxLength < 1) return '';
    if (this.length > maxLength) {
      return this.substring(0, maxLength) + (hasThreedot ? '...' : '');
    }
    return this;
  }

  String getShortString(int length) {
    String name = basename(this);
    if (name.length > length) {
      name = name.substring(0, (length / 2).round()) +
          '...' +
          name.substring(name.length - (length / 2).round());
    }
    return name;
  }

  String cap() {
    if (this.length <= 1)
      return this;
    else
      return this[0].toUpperCase() + this.substring(1);
  }
}

extension FirstLetterEachWord on String {
  String firstLetterEachWord({int? maxCount}) {
    final list = this.split(' ')..removeWhere((str) => str == '');
    var str = list.map((e) => e[0]).join();
    if (maxCount != null && maxCount < str.length && maxCount > 0) {
      str = str.substring(0, maxCount);
    }
    return str;
  }
}

extension StringGraphql on String? {
  String toGraphqlValue() {
    if (this != null) return '"$this"';
    return '""';
  }
}
