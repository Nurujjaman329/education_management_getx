import 'dart:io';
import 'package:edex_365_getx/features/authentication/model/parameter_body/signup_request_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _image;
  File? _cv;
  File? _academicImage;
  DateTime? _dob;

  List<String> selectedSubjects = [];
  List<String> selectedRoles = [];

  Future<void> _pickFile(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _mobileController, decoration: const InputDecoration(labelText: 'Mobile')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => _pickFile((f) => setState(() => _image = f)), child: const Text('Pick Profile Image')),
            ElevatedButton(onPressed: () => _pickFile((f) => setState(() => _cv = f)), child: const Text('Pick CV')),
            ElevatedButton(onPressed: () => _pickFile((f) => setState(() => _academicImage = f)), child: const Text('Pick Academic Image')),
            ElevatedButton(
              onPressed: () async {
                final dob = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1960),
                  lastDate: DateTime.now(),
                );
                setState(() => _dob = dob);
              },
              child: Text(_dob == null ? 'Pick Date of Birth' : _dob.toString()),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Math', 'English', 'Physics'].map((s) {
                final selected = selectedSubjects.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (v) => setState(() => v ? selectedSubjects.add(s) : selectedSubjects.remove(s)),
                );
              }).toList(),
            ),
            Wrap(
              spacing: 8,
              children: ['student', 'teacher'].map((r) {
                final selected = selectedRoles.contains(r);
                return FilterChip(
                  label: Text(r),
                  selected: selected,
                  onSelected: (v) => setState(() => v ? selectedRoles.add(r) : selectedRoles.remove(r)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final body = SignUpRequestBody(
                        name: _nameController.text,
                        mobileNo: _mobileController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        dob: _dob,
                        image: _image,
                        cv: _cv,
                        academicImage: _academicImage,
                        subject: selectedSubjects,
                        role: selectedRoles,
                      );
                      await controller.register(body);
                    },
                    child: const Text('Register'),
                  )),
          ],
        ),
      ),
    );
  }
}
