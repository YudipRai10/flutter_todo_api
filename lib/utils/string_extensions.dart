extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[#?!@$%^&*-]).{8,}$",
    );
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    // Matches 10-digit phone numbers, optionally with '+' or leading '0'
    final phoneRegExp = RegExp(r"^\+?0?[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

