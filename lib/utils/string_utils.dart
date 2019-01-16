class StringUtils {
  static bool isEmpty(String str) {
    if (str == null || str == '') {
      return true;
    }
    return false;
  }

  static bool isValid(String str) {
    return !isEmpty(str);
  }
}
