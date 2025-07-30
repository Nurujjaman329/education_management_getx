// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:edex_365_getx/core/error/exceptions.dart';
// import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/model/teacher_problem_get_model.dart';

// Future<List<TeacherProblemGetModel>> postAcceptProblemTeacher(
//     String userId, String postId) async {
//   try {
//     log("Initiating POST request to /api/Teacher/s/UpdateProblemFlag");

//     final response = await client.post(
//       '/api/Teacher/s/UpdateProblemFlag/$userId/$postId',
//     );

//     log("Request URI: ${response.realUri}");
//     log("Response Status Code: ${response.statusCode}");
//     log("Response Body===>: ${response.data}");

//     if (response.statusCode == 200) {
//       if (response.data is String) {
//         String serverMessage = response.data.toString().trim();

//         if (serverMessage.toLowerCase() == "already have a task.") {
//           throw InputException("You have already accepted another problem. Please solve it first.");
//         } else {
//           throw InputException(serverMessage);
//         }
//       } else if (response.data is List) {
//         return (response.data as List)
//             .map((e) => TeacherProblemGetModel.fromJson(e))
//             .toList();
//       } else {
//         throw ServerException();
//       }
//     } else if (response.statusCode == 404) {
//       throw AuthException();
//     } else {
//       throw ServerException();
//     }
//   } catch (error) {
//     log('Caught Error: ${error.toString()}');
//     if (error is InputException) rethrow;
//     throw InputException("Invalid Input");
//   }
// }
