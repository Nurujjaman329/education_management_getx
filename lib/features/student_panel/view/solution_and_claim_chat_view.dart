import 'dart:io';

import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_solution_get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class SolutionAndClaimChatView extends StatefulWidget {
  final String postId;

  const SolutionAndClaimChatView({
    super.key,
    required this.postId,
  });

  @override
  State<SolutionAndClaimChatView> createState() => _SolutionAndClaimChatViewState();
}

class _SolutionAndClaimChatViewState extends State<SolutionAndClaimChatView> {
  final StudentSolutionGetController solutionController = Get.find();
  final SharedController sharedController = Get.find();
  final AuthController authController = Get.find();

  final TextEditingController messageController = TextEditingController();
  File? selectedImage;
  String? currentSolutionId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    solutionController.fetchSolutions(widget.postId).then((_) {
      if (solutionController.solutions.isNotEmpty) {
        _loadClaimChat(solutionController.solutions.first.id);
      }
    });
  }

  void _loadClaimChat(String solutionId) {
    setState(() {
      currentSolutionId = solutionId;
    });
    sharedController.fetchClaimMessages(solutionId).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _sendMessage() {
    if (currentSolutionId == null) return;
    
    final text = messageController.text.trim();
    final userId = authController.userId.value;

    if (text.isEmpty && selectedImage == null) {
      Get.snackbar("Empty", "Please type a message or select an image.");
      return;
    }

    sharedController
        .sendMessage(
          text: text,
          userId: userId,
          solutionId: currentSolutionId!,
          imageFile: selectedImage,
        )
        .then((_) {
      messageController.clear();
      setState(() => selectedImage = null);
      sharedController.fetchClaimMessages(currentSolutionId!);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomCurvedAppBar(title: "Solutions & Chats"),
      body: Column(
        children: [
          // Solution selector tabs
          SizedBox(
            height: 70,
            child: Obx(() {
              if (solutionController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: solutionController.solutions.length,
                itemBuilder: (context, index) {
                  final solution = solutionController.solutions[index];
                  final isSelected = currentSolutionId == solution.id;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: ChoiceChip(
                      label: Text('Solution ${index + 1}'),
                      selected: isSelected,
                      onSelected: (selected) => _loadClaimChat(solution.id),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const Divider(height: 1),
          // Main content area
          Expanded(
            child: Obx(() {
              if (solutionController.errorMessage.isNotEmpty) {
                return Center(child: Text(solutionController.errorMessage.value));
              }

              if (currentSolutionId == null) {
                return const Center(child: Text('Select a solution to view chat'));
              }

              return Column(
                children: [
                  // Solution preview
                  if (currentSolutionId != null)
                    Obx(() {
                      final solution = solutionController.solutions.firstWhere(
                        (s) => s.id == currentSolutionId,
                        orElse: () => solutionController.solutions.first,
                      );
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solution ${solutionController.solutions.indexOf(solution) + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                solution.photo,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 150,
                                  color: Colors.grey.shade200,
                                  child: const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  // Chat messages
                  Expanded(
                    child: Obx(() {
                      if (sharedController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (sharedController.claimMessages.isEmpty) {
                        return const Center(
                          child: Text('No messages yet. Start the conversation!'),
                        );
                      }
                      return ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          ...sharedController.claimMessages.expand(
                            (group) => group.chats.map(
                              (chat) {
                                final isMe = group.userType.toLowerCase() == 'student';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: isMe 
                                        ? MainAxisAlignment.end 
                                        : MainAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isMe 
                                                ? AppColors.primary.withOpacity(0.1) 
                                                : AppColors.surface,
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(12),
                                              topRight: const Radius.circular(12),
                                              bottomLeft: isMe 
                                                  ? const Radius.circular(12) 
                                                  : const Radius.circular(0),
                                              bottomRight: isMe 
                                                  ? const Radius.circular(0) 
                                                  : const Radius.circular(12),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (chat.imageUrl.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 6),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                      chat.imageUrl,
                                                      width: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (chat.text.isNotEmpty)
                                                Text(
                                                  chat.text,
                                                  style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              const SizedBox(height: 4),
                                              Text(
                                                chat.message,
                                                style: TextStyle(
                                                  color: AppColors.textSecondary.withOpacity(0.7),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
          ),
          // Global message input section
          if (currentSolutionId != null) ...[
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        selectedImage!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => selectedImage = null),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: AppColors.secondary),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

