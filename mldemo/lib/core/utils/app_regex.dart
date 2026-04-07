class AppRegex {
  static final RegExp aadhaarRegex = RegExp(r"\b\d{4}\s\d{4}\s\d{4}\b");
  static final RegExp nameRegex = RegExp(r'^[A-Z][a-zA-Z\s]*$');
  static final RegExp dobRegex = RegExp(r'\b(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}\b');
}
