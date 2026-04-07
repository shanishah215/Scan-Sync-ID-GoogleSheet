import 'package:dartz/dartz.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_regex/flutter_regex.dart';

import '../../core/utils/app_regex.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/aadhaar_details.dart';
import '../../domain/repositories/ocr_repository.dart';
import '../datasources/ocr_remote_datasource.dart';

class OcrRepositoryImpl implements OcrRepository {
  final OcrRemoteDataSource _remoteDataSource;

  OcrRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AadhaarDetails>> processAadhaarImage(String imagePath) async {
    try {
      final recognizedText = await _remoteDataSource.processImage(imagePath);
      final details = _parseRecognizedText(recognizedText);
      return Right(details);
    } catch (e) {
      return Left(OcrFailure(e.toString()));
    }
  }

  AadhaarDetails _parseRecognizedText(RecognizedText recognizedText) {
    String name = "";
    String uid = "";
    String gender = "";
    String dob = "";
    String fullText = "";

    bool nameFound = false;
    RegExp aadhaarRegex = AppRegex.aadhaarRegex;

    bool isPossibleName(String text) {
      return text.isNotEmpty &&
          text.length > 1 &&
          text.isDateTimeUTC() == false &&
          AppRegex.nameRegex.hasMatch(text) &&
          text != 'GOVERNMENT OF INDIA' &&
          text != 'Government of India' &&
          text != 'Government of ndia' &&
          !text.toLowerCase().contains('issue date') &&
          !text.toLowerCase().contains('dob') &&
          !text.contains(AppRegex.dobRegex);
    }

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String lineText = line.text;
        fullText += "$lineText\n";

        // UID Search
        Iterable<Match> matches = aadhaarRegex.allMatches(lineText);
        if (matches.isNotEmpty) {
          uid = matches.first.group(0)!;
          // Hide parts for UI? Better to do it in presentation layer if needed.
        }

        // Gender Search
        if (lineText.contains("Gender:")) {
          gender = lineText.substring(lineText.indexOf("Gender:") + 7).trim();
        } else if (lineText.toUpperCase().contains("MALE")) {
          gender = "Male";
        } else if (lineText.toUpperCase().contains("FEMALE")) {
          gender = "Female";
        }

        // DOB search
        if (lineText.contains("DOB")) {
          dob = lineText.substring(lineText.indexOf("DOB") + 3).trim();
          if (dob.startsWith(":")) dob = dob.substring(1).trim();
        } else if (lineText.contains("Year of Birth")) {
          dob = lineText.substring(lineText.indexOf("Year of Birth") + 13).trim();
          if (dob.startsWith(":")) dob = dob.substring(1).trim();
        }

        // Name search
        if (!nameFound) {
          if (lineText.contains("Name")) {
            name = lineText.substring(lineText.indexOf("Name") + 4).trim();
            if (name.startsWith(":")) name = name.substring(1).trim();
            nameFound = true;
          } else if (isPossibleName(lineText)) {
            name = lineText;
            nameFound = true;
          }
        }
      }
    }

    return AadhaarDetails(
      name: name,
      uid: uid,
      dob: dob,
      gender: gender,
      rawText: fullText,
    );
  }
}
