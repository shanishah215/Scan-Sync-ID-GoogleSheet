import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/aadhaar_details.dart';
import '../controllers/sync_controller.dart';

class SyncPage extends StatefulWidget {
  final AadhaarDetails details;
  const SyncPage({super.key, required this.details});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController uidController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.details.name);
    dobController = TextEditingController(text: widget.details.dob);
    uidController = TextEditingController(text: widget.details.maskedUid);
    genderController = TextEditingController(text: widget.details.gender);
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    uidController.dispose();
    genderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedDetails = AadhaarDetails(
        name: nameController.text,
        uid: uidController.text,
        dob: dobController.text,
        gender: genderController.text,
      );
      Get.find<SyncController>().syncData(updatedDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SyncController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Sync Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Review Extracted Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildField("Full Name", nameController),
              _buildField("Date of Birth", dobController),
              _buildField("UID / Aadhaar Number", uidController),
              _buildField("Gender", genderController),
              const SizedBox(height: 32),
              Obx(() => Column(
                children: [
                  if (controller.isSyncing.value) 
                    const CircularProgressIndicator(),
                  if (!controller.isSyncing.value)
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("SYNC TO GOOGLE SHEET"),
                    ),
                  if (controller.status.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        controller.status.value,
                        style: TextStyle(
                          color: controller.error.value.isEmpty ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }
}
