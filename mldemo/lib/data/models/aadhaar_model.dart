import '../../domain/entities/aadhaar_details.dart';

class AadhaarModel extends AadhaarDetails {
  const AadhaarModel({
    required super.name,
    required super.uid,
    required super.dob,
    required super.gender,
    super.rawText,
  });

  factory AadhaarModel.fromEntity(AadhaarDetails entity) {
    return AadhaarModel(
      name: entity.name,
      uid: entity.uid,
      dob: entity.dob,
      gender: entity.gender,
      rawText: entity.rawText,
    );
  }

  String toParams() {
    return "?name=$name&dob=$dob&uid=$uid&gender=$gender";
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'dob': dob,
      'gender': gender,
      'rawText': rawText,
    };
  }
}
