class MyValidators {
  //! display name
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return "Name Cannot be empty";
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return "Name must be between 3 and 20 characters";
    }
    return null; //! return null if display name is valid
  }

//! email validator
  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Please enter an email";
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return "Please enter an email";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 character long";
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return "Please don't match";
    }
    return null;
  }
}
