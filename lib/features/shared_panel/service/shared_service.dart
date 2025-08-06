import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/shared_panel/model/all_version_class_list_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/get_claim_message_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/subject_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/update_user_info_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_details_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_role_response_model.dart';
import '../model/academy_version_list_response_model.dart';

class SharedService {
  final Dio client = DioClient.getInstance();

  // ------------------------ Version & Class Fetch ------------------------

  Future<List<AcademyVersionListResponseModel>> fetchVersion() async {
    try {
      final response = await client.get("/api/PostType/s/GetAllPostType");
      switch (response.statusCode) {
        case 200:
          final data = response.data as List;
          return data.map((e) => AcademyVersionListResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AllVersionClassListResponseModel>> fetchBanglaVersionClassList() async {
    try {
      final response = await client.get("/api/class/s/AllClass");
      switch (response.statusCode) {
        case 200:
          final data = response.data as List;
          return data.map((e) => AllVersionClassListResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AllVersionClassListResponseModel>> fetchEnglishVersionClassList() async {
    try {
      final response = await client.get("/api/EnglishClass/s/GetAllEnglishClass");
      switch (response.statusCode) {
        case 200:
          final data = response.data as List;
          return data.map((e) => AllVersionClassListResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  // ------------------------ Roles & Subject ------------------------

  Future<List<UserRolesResponseModel>> fetchUserRoleList() async {
    try {
      final response = await client.get("/api/Role/s/AllRoles");
      switch (response.statusCode) {
        case 200:
          final data = response.data as List;
          return data.map((e) => UserRolesResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SubjectResponseModel>> fetchSubjectList() async {
    try {
      final response = await client.get("/api/subject/s/AllSubject");
      switch (response.statusCode) {
        case 200:
          final data = response.data as List;
          return data.map((e) => SubjectResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  // ------------------------ User Management ------------------------

  Future<List<UserDetailsResponseModel>> getUserDetails(String userId) async {
    try {
      final response = await client.get("/api/auth/s/User/$userId");

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((e) => UserDetailsResponseModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updatePassword(String userId, String oldPassword, String newPassword) async {
    try {
      final response = await client.put(
        '/api/Auth/s/UpdatePassword/?userId=$userId&oldPassWord=$oldPassword&newPassWord=$newPassword',
      );

      final responseData = response.data as String;
      if (responseData == "PassWord is Update....") {
        return responseData;
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error) {
      throw InputException("Failed to update password: ${error.toString()}");
    }
  }

  Future<UpdateUserInfoResponseModel> updateUser(UpdateDetailsResponseBody body) async {
    try {
      final formData = await body.toFormData();

      final response = await client.put('/api/Auth/s/Update', data: formData);

      switch (response.statusCode) {
        case 200:
          return UpdateUserInfoResponseModel.fromJson(response.data);
        case 400:
          final errorMsg = response.data['errors'];
          throw InputException("Validation Error: ${errorMsg ?? 'Input Error'}");
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (error) {
      if (error is DioException && error.response?.data['errors'] != null) {
        throw InputException("Validation Error: ${error.response?.data['errors']}");
      }
      throw ServerException();
    }
  }

  // ------------------------ Problem & Claim ------------------------

  Future<ProblemDetailsResponseModel> getProblemDetails(String subId) async {
    try {
      final response = await client.get('/api/ProblemsPost/s/ProblemDetails/$subId');

      if (response.statusCode == 200 && response.data != null) {
        return ProblemDetailsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw InputException("Failed to fetch data.");
      }
    } catch (error) {
      throw InputException("Failed to fetch data.");
    }
  }

  Future<String> claimMessage(
    String text,
    String userId,
    String solutionId,
    File? voiceUrl,
    File? imageUrl,
  ) async {
    try {
      final url =
          '/api/ClaimCommunication/s/ClaimSaveMessage?userId=$userId&solutionId=$solutionId';

      final formData = FormData();

      formData.fields.add(MapEntry('text', text));

      if (voiceUrl != null) {
        final fileName = voiceUrl.path.split('/').last;
        formData.files.add(MapEntry(
          'voiceUrl',
          await MultipartFile.fromFile(voiceUrl.path, filename: fileName),
        ));
      }

      if (imageUrl != null) {
        final fileName = imageUrl.path.split('/').last;
        formData.files.add(MapEntry(
          'imageUrl',
          await MultipartFile.fromFile(imageUrl.path, filename: fileName),
        ));
      }

      final response = await client.post(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] ?? 'No message returned';
      } else {
        throw InputException('Unexpected response format');
      }
    } catch (error) {
      throw InputException("Failed to send message");
    }
  }


     Future<List<GetClaimMessageResponseModel>> getClaimChat(String solutionId) async {
    try {
      final response = await client.get('/api/ClaimCommunication/GetSolutionChat?solutionId=$solutionId');

      log("Request URL -> ${response.realUri}");
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data is List) {
          return data
              .map((e) => GetClaimMessageResponseModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          log("Unexpected format: expected List, got ${data.runtimeType}");
          return [];
        }
      } else {
        log("Failed status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("Exception during fetch: $e");
      throw InputException("Failed to fetch chat messages.");
    }
  }


    Future<String> postMessage({
    required String text,
    required String userId,
    required String problemPostId,
    File? voiceFile,
  }) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url = '/api/Communication/s/SaveMessage?Text=$encodedText&userId=$userId&problempostId=$problemPostId';

      final formData = FormData();

      if (voiceFile != null) {
        final fileName = voiceFile.path.split('/').last;
        formData.files.add(MapEntry(
          'voiceUrl',
          await MultipartFile.fromFile(voiceFile.path, filename: fileName),
        ));
      }

      final response = await client.post(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      log("Final URL -> ${response.realUri}");
      log("Response body -> ${response.data}");

      final data = response.data as Map<String, dynamic>;
      return data['message'] ?? 'No message returned';
    } catch (error) {
      log('SendMessage Error: $error');
      throw InputException("Failed to send message");
    }
  }
}

