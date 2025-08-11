import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_delete_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_get_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_update_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_skill/teacher_update_skill_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherSkillManagementView extends StatefulWidget {
  const TeacherSkillManagementView({super.key});

  @override
  State<TeacherSkillManagementView> createState() =>
      _TeacherSkillManagementViewState();
}

class _TeacherSkillManagementViewState
    extends State<TeacherSkillManagementView> {
  late TeacherGetSkillController getSkillController;
  late TeacherDeleteSkillController deleteSkillController;
  late TeacherUpdateSkillController updateSkillController;
  late SharedController sharedController;
  late AuthController authController;

  String get userId => authController.userId.value;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    getSkillController = Get.find<TeacherGetSkillController>();
    deleteSkillController = Get.find<TeacherDeleteSkillController>();
    updateSkillController = Get.find<TeacherUpdateSkillController>();
    sharedController = Get.find<SharedController>();

    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      getSkillController.fetchSkills(userId),
      sharedController.fetchSubjectList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: "Manage Your Skills",
        actions: [
          _buildActionButton(
            icon: Icons.delete_forever,
            tooltip: "Delete All Skills",
            onPressed: () => _confirmDeleteAll(theme),
            theme: theme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Your Teaching Skills",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage the subjects you're qualified to teach",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (getSkillController.isLoading.value ||
                    sharedController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (getSkillController.errorMessage.isNotEmpty) {
                  return _buildErrorView(
                    getSkillController.errorMessage.value,
                    theme,
                  );
                }

                if (getSkillController.skills.isEmpty) {
                  return _buildEmptyState(theme);
                }

                return _buildSkillList(theme, isDark);
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>  _showGlobalUpdateDialog(theme),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
      color: theme.colorScheme.onPrimary,
      splashRadius: 20,
    );
  }

  Widget _buildErrorView(String message, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "No Skills Added Yet",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap the + button to add your teaching skills",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillList(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: getSkillController.skills.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        itemBuilder: (_, index) {
          final skill = getSkillController.skills[index];

          return Dismissible(
            key: Key(skill.id),
            background: Container(
              color: theme.colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                color: theme.colorScheme.onError,
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await _confirmDelete(skill.id, theme);
            },
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDark
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: Text(
                  skill.subject.join(", "),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: () => _confirmDelete(skill.id,theme),
                  splashRadius: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

Future<bool> _confirmDelete(String subId , ThemeData theme) async {
  bool? result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(
        "Delete Skill",
        style: theme.textTheme.titleLarge,
      ),
      content: Text(
        "Are you sure you want to delete this skill?",
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            "Cancel",
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onPrimary,
            backgroundColor: theme.colorScheme.error,
          ),
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  if (result == true) {
    await deleteSkillController.deleteSkill(userId, [subId]);
    await getSkillController.fetchSkills(userId);

    if (deleteSkillController.deleteMessage.isNotEmpty) {
      Get.snackbar(
        "Success",
        deleteSkillController.deleteMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green, // Green is common, or you can define in theme
        colorText: Colors.white,
      );
    } else if (deleteSkillController.deleteError.isNotEmpty) {
      Get.snackbar(
        "Error",
        deleteSkillController.deleteError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: theme.colorScheme.error,
        colorText: theme.colorScheme.onError,
      );
    }
  }

  return result ?? false;
}

void _confirmDeleteAll(ThemeData theme) async {
  bool? result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(
        "Delete All Skills",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        "This will remove all your teaching skills. Are you sure?",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text("Delete All"),
        ),
      ],
    ),
  );

  if (result == true) {
    final allSubIds = getSkillController.skills.map((skill) => skill.id).toList();

    if (allSubIds.isEmpty) {
      Get.snackbar(
        "Info",
        "No skills to delete",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: theme.colorScheme.surface,
        colorText: theme.colorScheme.onSurface,
      );
      return;
    }

    await deleteSkillController.deleteSkill(userId, allSubIds);
    await getSkillController.fetchSkills(userId);

    if (deleteSkillController.deleteMessage.isNotEmpty) {
      Get.snackbar(
        "Success",
        deleteSkillController.deleteMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green, // or theme color if defined
        colorText: Colors.white,
      );
    } else if (deleteSkillController.deleteError.isNotEmpty) {
      Get.snackbar(
        "Error",
        deleteSkillController.deleteError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: theme.colorScheme.error,
        colorText: theme.colorScheme.onError,
      );
    }
  }
}


void _showGlobalUpdateDialog(ThemeData theme) {
  final currentSubjectIds = getSkillController.skills
      .expand((skill) => skill.subject)
      .toSet()
      .toList();

  final selectedSubjectIds = <String>{...currentSubjectIds}.obs;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Update Your Skills",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select the subjects you're qualified to teach",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.5,
                ),
                child: Obx(() {
                  if (sharedController.subjectList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3)),
                          const SizedBox(height: 8),
                          Text(
                            "No subjects available",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: sharedController.subjectList.length,
                    itemBuilder: (context, index) {
                      final subject = sharedController.subjectList[index];

                      return Obx(
                        () => CheckboxListTile(
                          title: Text(
                            subject.subjectName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          value: selectedSubjectIds.contains(subject.id),
                          onChanged: (value) {
                            if (value == true) {
                              selectedSubjectIds.add(subject.id);
                            } else {
                              selectedSubjectIds.remove(subject.id);
                            }
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: selectedSubjectIds.isEmpty
                          ? null
                          : () async {
                              final body = TeacherUpdateSkillBody(
                                userId: userId,
                                subject: selectedSubjectIds.toList(),
                              );

                              await updateSkillController.updateSkill(body);
                              Get.back();
                              await getSkillController.fetchSkills(userId);

                              if (updateSkillController.response.value !=
                                  null) {
                                Get.snackbar(
                                  "Success",
                                  updateSkillController.response.value!.message,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      theme.colorScheme.secondary,
                                  colorText:
                                      theme.colorScheme.onSecondary,
                                );
                              } else if (updateSkillController.error.isNotEmpty) {
                                Get.snackbar(
                                  "Error",
                                  updateSkillController.error.value,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      theme.colorScheme.error,
                                  colorText:
                                      theme.colorScheme.onError,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.colorScheme.primary,
                        disabledBackgroundColor: theme
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                      ),
                      child: Text(
                        "Save Changes",
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

}
