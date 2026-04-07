import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/ocr_controller.dart';
import '../../sync/pages/sync_page.dart';

class OcrPage extends StatelessWidget {
  const OcrPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller should be initialized via dependency injection (Get.find)
    // but for now let's use Get.put if not already present.
    final controller = Get.find<OcrController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhaar Scanner'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            _buildImageDisplay(controller),
            const SizedBox(height: 24),
            _buildPickButton(context, controller),
            const Divider(height: 48),
            _buildRecognizedSection(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay(OcrController controller) {
    return Obx(() {
      final path = controller.pickedImagePath.value;
      return Container(
        height: 250,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: path.isEmpty
            ? const Center(child: Text("Pick an Aadhaar image to scan"))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                ),
              ),
      );
    });
  }

  Widget _buildPickButton(BuildContext context, OcrController controller) {
    return Obx(() {
      return ElevatedButton.icon(
        onPressed: controller.isRecognizing.value
            ? null
            : () => _showSourceModal(context, controller),
        icon: controller.isRecognizing.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add_a_photo_outlined),
        label: Text(controller.isRecognizing.value ? 'Scanning...' : 'Pick Image'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    });
  }

  void _showSourceModal(BuildContext context, OcrController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecognizedSection(BuildContext context, OcrController controller) {
    return Expanded(
      child: Obx(() {
        final details = controller.aadhaarDetails.value;
        if (controller.isRecognizing.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (details == null) {
          return const Center(child: Text("No scan results yet"));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Extracted Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: details.rawText ?? ""));
                      Get.snackbar("Copied", "Raw text copied to clipboard",
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _detailRow("Name", details.name),
              _detailRow("DOB", details.dob),
              _detailRow("UID", details.uid),
              _detailRow("Gender", details.gender),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => SyncPage(details: details)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("PROCEED TO SYNC"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value.isEmpty ? "Not found" : value),
          ],
        ),
      ),
    );
  }
}
