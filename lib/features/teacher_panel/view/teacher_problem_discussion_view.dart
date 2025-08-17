import 'dart:io';

import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/controller/teachers_solution_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/view/teacher_solution_post_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart'; 

class TeacherProblemDiscussionView extends StatefulWidget {
  final String problemId;

  const TeacherProblemDiscussionView({super.key, required this.problemId});

  @override
  State<TeacherProblemDiscussionView> createState() => _TeacherProblemDiscussionViewState();
}

class _TeacherProblemDiscussionViewState extends State<TeacherProblemDiscussionView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(SharedController());
    Get.put(TeacherSolutionController());
    final messageController = TextEditingController();
    final userId = Get.find<AuthController>().userId.value;

    // Fetch problem details when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProblemDetails(widget.problemId);
    });

    return Scaffold(
      appBar:const CustomCurvedAppBar(title: "Problem Discussion"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: () => controller.fetchProblemDetails(widget.problemId),
        //   ),
        // ],
    
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }

        final problem = controller.problemDetails.value;
        if (problem == null) {
          return const Center(child: Text('No problem details found'));
        }

        return Column(
          children: [
            // Problem Details Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Problem Image
                    if (problem.photo.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          problem.photo,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Problem Info
                    Text(
                      problem.subject,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Class: ${problem.sClass}'),
                    Text('Topic: ${problem.topic}'),
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(problem.description),
                    const SizedBox(height: 16),
                    Text(
                      'Posted on: ${problem.getDateby}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Divider(height: 32),

                    // Discussion Thread
                    Text(
                      'Discussion',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Combined and sorted messages
                    ..._buildCombinedMessages(problem, theme),
                  ],
                ),
              ),
            ),

            // Message Input & Submit Button
            _buildInputSection(
              context,
              controller,
              messageController,
              widget.problemId,
              userId,
            ),
          ],
        );
      }),
    );
  }

List<Widget> _buildCombinedMessages(
  ProblemDetailsResponseModel problem,
  ThemeData theme,
) {
  final allMessages = [
    ...problem.studentChats.map((m) => _MessageData(m, false)),
    ...problem.teacherChats.map((m) => _MessageData(m, true)),
  ]..sort((a, b) => a.message.getDate.compareTo(b.message.getDate));

  return allMessages.map((msg) {
    final isMe = msg.isTeacher; // teacher messages on right
    final chat = msg.message;

    final isVoice = chat.message.endsWith(".mp3") ||
                    chat.message.endsWith(".wav") ||
                    chat.message.endsWith(".m4a");

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? theme.colorScheme.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: isVoice
            ? _buildVoiceMessage(chat.message, isMe, theme)
            : Text(
                chat.message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
      ),
    );
  }).toList();
}

Widget _buildVoiceMessage(String url, bool isMe, ThemeData theme) {
  final player = AudioPlayer();
  final isPlaying = false.obs;

  return Obx(() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isPlaying.value ? Icons.stop : Icons.play_arrow,
              color: isMe ? Colors.white : theme.colorScheme.primary,
            ),
            onPressed: () async {
              if (isPlaying.value) {
                await player.stop();
                isPlaying.value = false;
              } else {
                await player.setUrl(url);
                await player.play();
                isPlaying.value = true;

                player.playerStateStream.listen((state) {
                  if (state.processingState == ProcessingState.completed) {
                    isPlaying.value = false;
                  }
                });
              }
            },
          ),
          Text(
            "Voice Message",
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ));
}

Widget _buildInputSection(
  BuildContext context,
  SharedController controller,
  TextEditingController messageController,
  String problemId,
  String userId,
) {
  final theme = Theme.of(context);

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      border: Border(top: BorderSide(color: theme.dividerColor)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            // Voice Record Button
            IconButton(
              icon: const Icon(Icons.mic),
              color: theme.colorScheme.primary,
              onPressed: () async {
                final voiceFile = await _showVoiceRecordingDialog(context);
                if (voiceFile != null) {
                  await controller.sendPendingMessage(
                     text: '', // <-- must not be null
                    userId: userId,
                    problemPostId: problemId,
                    voiceFile: voiceFile,
                  );
                  controller.fetchProblemDetails(problemId);
                }
              },
            ),
            const SizedBox(width: 8),

            // Text Input
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send Button
            IconButton(
              icon: const Icon(Icons.send),
              color: theme.colorScheme.primary,
              onPressed: () async {
                if (messageController.text.trim().isNotEmpty) {
                  await controller.sendPendingMessage(
                    text: messageController.text,
                    userId: userId,
                    problemPostId: problemId,
                  );
                  messageController.clear();
                  controller.fetchProblemDetails(problemId);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Submit Solution Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Get.to(() => TeacherSolutionPostView(postId: problemId));
            },
            child: const Text('Submit Solution'),
          ),
        ),
      ],
    ),
  );
}

Future<File?> _showVoiceRecordingDialog(BuildContext context) async {
  final recorder = AudioRecorder();
  final player = AudioPlayer();

  final isRecording = false.obs;
  final isPlaying = false.obs;
  final recordedFile = Rx<File?>(null);

  // ✅ Check microphone permission
  final hasPermission = await recorder.hasPermission();
  if (!hasPermission) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission is required")),
      );
    }
    return null;
  }

  // ✅ Ensure context still mounted before showing dialog
  if (!context.mounted) return null;

  return await showDialog<File>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Obx(
        () => AlertDialog(
          title: const Text("Voice Recording"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (recordedFile.value == null) ...[
                  // Recording UI
                  IconButton(
                    icon: Icon(
                      isRecording.value ? Icons.stop : Icons.mic,
                      size: 48,
                      color: isRecording.value ? Colors.red : Colors.blue,
                    ),
                    onPressed: () async {
                      if (isRecording.value) {
                        // Stop recording
                        final path = await recorder.stop();
                        isRecording.value = false;
                        if (path != null) {
                          recordedFile.value = File(path);
                        }
                      } else {
                        // Start recording
                        final tempDir = await getTemporaryDirectory();
                        final filePath =
                            '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

                        isRecording.value = true;
                        await recorder.start(
                          const RecordConfig(),
                          path: filePath,
                        );
                      }
                    },
                  ),
                  Text(isRecording.value ? "Recording..." : "Tap to record"),
                ] else ...[
                  // Preview UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying.value ? Icons.stop : Icons.play_arrow,
                          size: 36,
                        ),
                        onPressed: () async {
                          if (isPlaying.value) {
                            await player.stop();
                            isPlaying.value = false;
                          } else {
                            await player.setFilePath(recordedFile.value!.path);
                            await player.play();
                            isPlaying.value = true;

                            player.playerStateStream.listen((state) {
                              if (state.processingState ==
                                  ProcessingState.completed) {
                                isPlaying.value = false;
                              }
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.replay, size: 36),
                        onPressed: () {
                          recordedFile.value = null; // re-record
                        },
                      ),
                    ],
                  ),
                  const Text("Preview your recording"),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await recorder.stop();
                await player.stop();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text("Cancel"),
            ),
            if (recordedFile.value != null)
              TextButton(
                onPressed: () async {
                  await player.stop();
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(recordedFile.value);
                  }
                },
                child: const Text("Send"),
              ),
          ],
        ),
      );
    },
  );
}






}

class _MessageData {
  final ProblemDetailsChatResponseBody message;
  final bool isTeacher;

  _MessageData(this.message, this.isTeacher);
}