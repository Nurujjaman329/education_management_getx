// lib/features/student_panel/controllers/student_problem_list_controller.dart
import 'dart:developer';

import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/features/student_panel/model/student_problem_list_response_model.dart';
import 'package:edex_365_getx/features/student_panel/service/student_problem_list_service.dart';
import 'package:get/get.dart';

class StudentProblemListController extends GetxController {
  final StudentProblemListService _service;

  StudentProblemListController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var totalProblems = <StudentProblemListResponseModel>[].obs;
  var pendingProblems = <StudentProblemListResponseModel>[].obs;
  var solvedProblems = <StudentProblemListResponseModel>[].obs;
  var problemDetails = Rxn<ProblemDetailsResponseModel>();
  

  /// Fetches all problem lists in sequence (total, pending, solved)
  Future<void> fetchAll(String userId) async {
    log('[DEBUG] fetchAll called with userId: $userId');
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final all = await _service.getStudentProblems(userId);
      final pending = await _service.getPendingProblems(userId);
      final solved = await _service.getSolvedProblems(userId);

      totalProblems.assignAll(all);
      pendingProblems.assignAll(pending);
      solvedProblems.assignAll(solved);
      log('[DEBUG] fetchAll completed. Total: \\${all.length}, Pending: \\${pending.length}, Solved: \\${solved.length}');
    } catch (e) {
      errorMessage.value = 'Failed to fetch problems';
      log('[DEBUG] fetchAll error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// (Optional) Individual fetch methods
  Future<void> fetchTotal(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final problems = await _service.getStudentProblems(userId);
      totalProblems.assignAll(problems);
    } catch (e) {
      errorMessage.value = 'Failed to fetch total problems';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPending(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final problems = await _service.getPendingProblems(userId);
      pendingProblems.assignAll(problems);
    } catch (e) {
      errorMessage.value = 'Failed to fetch pending problems';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSolved(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final problems = await _service.getSolvedProblems(userId);
      solvedProblems.assignAll(problems);
    } catch (e) {
      errorMessage.value = 'Failed to fetch solved problems';
    } finally {
      isLoading.value = false;
    }
  }



}
