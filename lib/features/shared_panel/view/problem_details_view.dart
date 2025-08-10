import 'dart:io';
import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

class ProblemDetailsView extends StatefulWidget {
  final String problemId;
  final bool showDiscussion;

  const ProblemDetailsView({
    super.key, 
    required this.problemId,
    this.showDiscussion = true,
  });

  @override
  State<ProblemDetailsView> createState() => _ProblemDetailsViewState();
}

class _ProblemDetailsViewState extends State<ProblemDetailsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<SharedController>();

    return FutureBuilder(
      future: controller.fetchProblemDetails(widget.problemId),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: const CustomCurvedAppBar(title: "Problem Details"),
          body: _buildBody(controller, theme),
        );
      },
    );
  }

  Widget _buildBody(SharedController controller, ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: theme.colorScheme.primary,
          ),
        );
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
        return Center(
          child: Text(
            'No problem details found',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        );
      }

      return RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () => controller.fetchProblemDetails(widget.problemId),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProblemDetailsSection(problem, theme),
              const SizedBox(height: 24),
              _buildActionSection(theme, controller),
              if (widget.showDiscussion) ...[
                const SizedBox(height: 24),
                Text(
                  "Discussion",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDiscussionSection(problem, theme),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionSection(ThemeData theme, SharedController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore available solutions",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Get help from verified experts and community members",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final postId = controller.problemDetails.value?.id;
                if (postId != null) {
                  Get.toNamed(
                    AppRoutes.solutionAndClaimChat,
                    arguments: {'postId': postId},
                  );
                } else {
                  Get.snackbar("Error", "Problem ID not found");
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline, size: 22),
                  SizedBox(width: 8),
                  Text("View Solutions", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemDetailsSection(
      ProblemDetailsResponseModel problem, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          problem.subject,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Problem image
        GestureDetector(
          onTap: () => Get.to(
            FullScreenImage(
              imageUrl: problem.photo, 
              tag: 'problem_${problem.id}'
            ),
          ),
          child: Hero(
            tag: 'problem_${problem.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 220,
                child: Image.network(
                  problem.photo,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Problem details cards
        _buildDetailCard(
          icon: Icons.description,
          title: 'Description',
          content: problem.description,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          icon: Icons.topic,
          title: 'Topic',
          content: problem.topic,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          icon: Icons.class_,
          title: 'Class',
          content: problem.sClass,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionSection(
      ProblemDetailsResponseModel problem, ThemeData theme) {
    final combinedChats = [
      ...problem.teacherChats.map((e) => _ChatMessage(
            message: e.message,
            date: e.getDate,
            isTeacher: true,
          )),
      ...problem.studentChats.map((e) => _ChatMessage(
            message: e.message,
            date: e.getDate,
            isTeacher: false,
          )),
    ]..sort((a, b) => a.date.compareTo(b.date));

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Discussion History",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            height: 300,
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              reverse: true,
              itemCount: combinedChats.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(combinedChats[index], theme);
              },
            ),
          ),
          _buildMessageInputField(theme),
        ],
      ),
    );
  }

  Widget _buildChatBubble(_ChatMessage chat, ThemeData theme) {
    final isAudio = chat.message.toLowerCase().endsWith('.m4a') &&
        chat.message.startsWith('http');

    return GetBuilder<AudioController>(
      init: AudioController(),
      builder: (audioController) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: chat.isTeacher
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (chat.isTeacher)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: chat.isTeacher
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: chat.isTeacher
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(chat.isTeacher ? 4 : 18),
                          bottomRight: Radius.circular(chat.isTeacher ? 18 : 4),
                        ),
                      ),
                      child: isAudio
                          ? _buildAudioPlayer(chat.message, audioController, theme)
                          : Text(
                              chat.message,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: chat.isTeacher
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                      child: Text(
                        _formatTime(chat.date.toString()),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAudioPlayer(
      String audioUrl, AudioController controller, ThemeData theme) {
    final isPlaying = controller.isPlaying.value &&
        controller.currentAudioUrl.value == audioUrl;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: theme.colorScheme.primary,
          ),
          onPressed: () {
            if (isPlaying) {
              controller.stopAudio();
            } else {
              controller.playAudio(audioUrl);
            }
          },
        ),
        Obx(() {
          return Text(
            controller.totalDuration.value > 0
                ? 'Voice message (${_formatDuration(controller.totalDuration.value)})'
                : 'Loading...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          );
        }),
      ],
    );
  }

Widget _buildMessageInputField(ThemeData theme) {
  final sharedController = Get.find<SharedController>();
  final authController = Get.find<AuthController>();
  final textController = TextEditingController();
  final isRecording = false.obs;
  final audioPath = ''.obs;

  final recorder = AudioRecorder(); // ✅ Correct class

  Future<void> startRecording() async {
    try {
      final hasPermission = await recorder.hasPermission(); // ✅ Fixed
      if (hasPermission) {
        final path = '${Directory.systemTemp.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );
        isRecording.value = true;
      } else {
        Get.snackbar('Permission required', 'Please allow microphone access');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await recorder.stop(); // ✅ Fixed
      isRecording.value = false;
      if (path != null) {
        audioPath.value = path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop recording: ${e.toString()}');
    }
  }

  Future<void> sendMessage() async {
    final problem = sharedController.problemDetails.value;
    if (problem == null) return;

    final userId = authController.userId.value;
    final problemPostId = problem.id;

    if (textController.text.isNotEmpty || audioPath.value.isNotEmpty) {
      try {
        await sharedController.sendPendingMessage(
          text: textController.text,
          userId: userId,
          problemPostId: problemPostId,
          voiceFile: audioPath.value.isNotEmpty ? File(audioPath.value) : null,
        );

        textController.clear();
        audioPath.value = '';
        await sharedController.fetchProblemDetails(problemPostId);
      } catch (e) {
        Get.snackbar('Error', 'Failed to send message: ${e.toString()}');
      }
    }
  }

  final isDarkMode = theme.brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        Obx(() {
          if (isRecording.value) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Recording...',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: stopRecording,
                  ),
                ],
              ),
            );
          } else if (audioPath.value.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.audiotrack),
                  const SizedBox(width: 8),
                  Text(
                    'Voice message ready',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => audioPath.value = '',
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        }),
        Row(
          children: [
            IconButton(
              icon: Obx(() => Icon(
                    isRecording.value ? Icons.mic : Icons.mic_none,
                    color: isRecording.value ? Colors.red : theme.colorScheme.primary,
                  )),
              onPressed: () {
                if (isRecording.value) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: sendMessage,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  String _formatTime(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    // Format time in 12-hour format
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final formattedTime =
        '$hour12:${minute.toString().padLeft(2, '0')} $period';

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays >= 1) {
      if (difference.inDays == 1) {
        return 'Yesterday at $formattedTime';
      } else {
        return '${difference.inDays} days ago at $formattedTime';
      }
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inSeconds >= 1) {
      return '${difference.inSeconds}s ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$secs';
  }
}

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final RxDouble currentPosition = 0.0.obs;
  final RxDouble totalDuration = 0.0.obs;
  final RxString currentAudioUrl = ''.obs;

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playAudio(String audioUrl) async {
    try {
      if (isPlaying.value && currentAudioUrl.value == audioUrl) {
        await _audioPlayer.pause();
        isPlaying(false);
        return;
      }

      if (isPlaying.value) {
        await _audioPlayer.stop();
      }

      currentAudioUrl(audioUrl);
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      isPlaying(true);

      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          totalDuration(duration.inSeconds.toDouble());
        }
      });

      _audioPlayer.positionStream.listen((position) {
        currentPosition(position.inSeconds.toDouble());
        if (position.inSeconds >= totalDuration.value) {
          stopAudio();
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Could not play audio');
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPlaying(false);
    currentPosition(0.0);
    currentAudioUrl('');
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: tag,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String message;
  final DateTime date;
  final bool isTeacher;

  _ChatMessage({
    required this.message,
    required String date,
    required this.isTeacher,
  }) : date = DateTime.parse(date);
}
