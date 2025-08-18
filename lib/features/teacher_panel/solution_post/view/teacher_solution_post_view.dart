import 'dart:io';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/controller/teachers_solution_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TeacherSolutionPostView extends StatelessWidget {
  final String postId;


  TeacherSolutionPostView({
    super.key,
    required this.postId,

  });

  final TeacherSolutionController controller =
      Get.find<TeacherSolutionController>();
  final teacherId = Get.find<AuthController>().userId.value;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      controller.selectedImages.addAll(images.map((img) => File(img.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Solution"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo),
              label: const Text("Pick Images"),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.selectedImages.isEmpty) {
                  return const Center(child: Text("No images selected"));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: controller.selectedImages.length,
                  itemBuilder: (context, index) {
                    final file = controller.selectedImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => controller.selectedImages.removeAt(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 12),

            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        await controller.postSolution(teacherId, postId);
                      },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Solution"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
