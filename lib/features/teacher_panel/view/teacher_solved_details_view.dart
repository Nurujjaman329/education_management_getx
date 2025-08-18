import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_solution_get_controller.dart';
import 'package:edex_365_getx/features/student_panel/view/solution_and_claim_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class TeacherSolvedDetailsView extends StatefulWidget {
  final String problemId;

  const TeacherSolvedDetailsView({super.key, required this.problemId});

  @override
  State<TeacherSolvedDetailsView> createState() => _TeacherSolvedDetailsViewState();
}

class _TeacherSolvedDetailsViewState extends State<TeacherSolvedDetailsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(SharedController());
    Get.put(StudentSolutionGetController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProblemDetails(widget.problemId);
    });

    return Scaffold(
      appBar: const CustomCurvedAppBar(title: "Problem Discussion"),
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

        final hasDiscussion = problem.studentChats.isNotEmpty || problem.teacherChats.isNotEmpty;

        return Column(
          children: [
            // Problem Details Section (fixed height)
            Flexible(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // Discussion Section (expandable)
            Flexible(
              flex: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          'Discussion',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!hasDiscussion)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '(No messages yet)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Messages with flexible space
                  Expanded(
                    child: hasDiscussion 
                      ? SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: _buildCombinedMessages(problem, theme),
                          ),
                        )
                      : Center(
                          child: Text(
                            'Start the discussion by sending a message',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            ),

           _buildActionSection(theme, controller)
          ],
        );
      }),
    );
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
                    Get.to(
                () =>  SolutionAndClaimChatView(postId: postId),
                transition: Transition.leftToRight,
                duration: const Duration(milliseconds: 400),
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

  List<Widget> _buildCombinedMessages(
    ProblemDetailsResponseModel problem,
    ThemeData theme,
  ) {
    final allMessages = [
      ...problem.studentChats.map((m) => _MessageData(m, false)),
      ...problem.teacherChats.map((m) => _MessageData(m, true)),
    ]..sort((a, b) => a.message.getDate.compareTo(b.message.getDate));

    return allMessages.map((msg) {
      final isMe = msg.isTeacher;
      final chat = msg.message;
      final isVoice = chat.message.endsWith(".mp3") ||
          chat.message.endsWith(".wav") ||
          chat.message.endsWith(".m4a");

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? theme.colorScheme.primary : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
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
}

class _MessageData {
  final ProblemDetailsChatResponseBody message;
  final bool isTeacher;

  _MessageData(this.message, this.isTeacher);
}