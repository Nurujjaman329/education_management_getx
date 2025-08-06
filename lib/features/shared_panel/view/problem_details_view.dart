import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class ProblemDetailsView extends StatelessWidget {
  final String problemId;
  final bool showDiscussion;

  const ProblemDetailsView({super.key, required this.problemId,this.showDiscussion = true,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SharedController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return FutureBuilder(
      future: controller.fetchProblemDetails(problemId),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomCurvedAppBar(title: "Problem Details"),
          body: _buildBody(controller, isDarkMode),
        );
      },
    );
  }

  Widget _buildBody(SharedController controller, bool isDarkMode) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(
          strokeWidth: 2.5,
        ));
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
            child: Text(controller.errorMessage.value,
                style: TextStyle(
                    color: isDarkMode ? Colors.red.shade300 : Colors.red)));
      }

      final problem = controller.problemDetails.value;
      if (problem == null) {
        return Center(
            child: Text('No problem details found',
                style: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey)));
      }

      return RefreshIndicator(
        color: Colors.blue,
        onRefresh: () => controller.fetchProblemDetails(problemId),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProblemDetailsSection(problem, isDarkMode),
              const SizedBox(height: 24),
              _buildActionSection(isDarkMode, controller),
              const SizedBox(height: 24),
              if (showDiscussion) ...[
                const SizedBox(height: 24),
                Text(
                  "Discussion",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDiscussionSection(problem, isDarkMode),
              //    const SizedBox(height: 16),
              // _buildDiscussionSection(problem, isDarkMode),
              ],
             
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionSection(bool isDarkMode, SharedController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore available solutions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Get help from verified experts and community members",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.blue.shade700 : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
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
      ProblemDetailsResponseModel problem, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          problem.subject,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        // Problem image
        GestureDetector(
          onTap: () => Get.to(
            FullScreenImage(
                imageUrl: problem.photo, tag: 'problem_${problem.id}'),
          ),
          child: Hero(
            tag: 'problem_${problem.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.grey.shade500,
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
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          icon: Icons.topic,
          title: 'Topic',
          content: problem.topic,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          icon: Icons.class_,
          title: 'Class',
          content: problem.sClass,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
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
                color: isDarkMode ? Colors.blue.shade900 : Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: 20,
                  color:
                      isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade800,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionSection(
      ProblemDetailsResponseModel problem, bool isDarkMode) {
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
        color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline,
                    color: isDarkMode ? Colors.blue.shade300 : Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Discussion History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
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
                return _buildChatBubble(combinedChats[index], isDarkMode);
              },
            ),
          ),
          _buildMessageInputField(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildChatBubble(_ChatMessage chat, bool isDarkMode) {
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
                  backgroundColor: Colors.blue.shade200,
                  child: const Icon(Icons.person, size: 16),
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
                              ? (isDarkMode
                                  ? Colors.blue.shade900
                                  : Colors.blue.shade100)
                              : (isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft:
                                Radius.circular(chat.isTeacher ? 4 : 18),
                            bottomRight:
                                Radius.circular(chat.isTeacher ? 18 : 4),
                          ),
                        ),
                        child: isAudio
                            ? _buildAudioPlayer(
                                chat.message, audioController, isDarkMode)
                            : Text(
                                chat.message,
                                style: TextStyle(
                                  color: chat.isTeacher
                                      ? (isDarkMode
                                          ? Colors.white
                                          : Colors.blue.shade900)
                                      : (isDarkMode
                                          ? Colors.white
                                          : Colors.black87),
                                ),
                              ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 8, right: 8),
                        child: Text(
                          _formatTime(chat.date.toString()),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAudioPlayer(
      String audioUrl, AudioController controller, bool isDarkMode) {
    final isPlaying = controller.isPlaying.value &&
        controller.currentAudioUrl.value == audioUrl;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: isDarkMode ? Colors.white : Colors.blue.shade800,
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
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.blue.shade800),
          );
        }),
      ],
    );
  }

  Widget _buildMessageInputField(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {},
            ),
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
    return Scaffold(
      backgroundColor: Colors.black,
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
