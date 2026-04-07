class AadhaarDetails {
  final String name;
  final String uid;
  final String dob;
  final String gender;
  final String? rawText;

  const AadhaarDetails({
    required this.name,
    required this.uid,
    required this.dob,
    required this.gender,
    this.rawText,
  });

  String get maskedUid {
    if (uid.isEmpty) return "";
    if (uid.length <= 4) return "XXXX";
    return uid.substring(0, uid.length - 4) + "XXXX";
  }

  AadhaarDetails copyWith({
    String? name,
    String? uid,
    String? dob,
    String? gender,
    String? rawText,
  }) {
    return AadhaarDetails(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      rawText: rawText ?? this.rawText,
    );
  }
}
