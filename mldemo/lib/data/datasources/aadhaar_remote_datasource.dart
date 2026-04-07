import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../core/constants/app_constants.dart';
import '../models/aadhaar_model.dart';
 
abstract class AadhaarRemoteDataSource {
  Future<String> syncAadhaar(AadhaarModel model);
}
 
class AadhaarRemoteDataSourceImpl implements AadhaarRemoteDataSource {
 
  @override
  Future<String> syncAadhaar(AadhaarModel model) async {
    final response = await http.get(Uri.parse(AppConstants.googleSheetUrl + model.toParams()));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse["status"];
    } else {
      throw Exception('Failed to sync Aadhaar data');
    }
  }
}
