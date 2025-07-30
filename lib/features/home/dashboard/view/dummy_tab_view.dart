import 'package:flutter/material.dart';

class StudentHomeTab extends StatelessWidget {
  const StudentHomeTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Student Home"));
}

class StudentProblemPostTab extends StatelessWidget {
  const StudentProblemPostTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Problem Post"));
}

class StudentSettingsTab extends StatelessWidget {
  const StudentSettingsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Student Settings"));
}

class TeacherHomeTab extends StatelessWidget {
  const TeacherHomeTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Teacher Home"));
}

class TeacherSettingsTab extends StatelessWidget {
  const TeacherSettingsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Teacher Settings"));
}
