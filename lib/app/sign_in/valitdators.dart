abstract class StringValidator {
  bool isValid(String value);
  bool minInput(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    // TODO: implement isValid
    return value.isNotEmpty;
  }

  bool minInput(String value) {
    return value.length > 4;
  }
  
}
class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
}