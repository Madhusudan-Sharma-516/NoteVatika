import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../local/temp_data_service.dart';
import '../models/course_model.dart';
import '../models/subject_model.dart';
import '../models/topic_model.dart';
import '../models/notes_model.dart';

/// Remote data service that fetches from API URLs.
/// Silently falls back to [TempDataService] on any failure.
class ApiService {
  final TempDataService _tempDataService = TempDataService();

  /// Generic fetch helper that falls back to local data on failure.
  Future<List<T>> _fetchList<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    required Future<List<T>> Function() fallback,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(AppConstants.networkTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        // Non-200 status — fall back silently
        return fallback();
      }
    } catch (_) {
      // Network error, timeout, or parse error — fall back silently
      return fallback();
    }
  }

  /// Fetch courses from API, fallback to local.
  Future<List<CourseModel>> getCourses() async {
    return _fetchList<CourseModel>(
      url: AppConstants.coursesUrl,
      fromJson: CourseModel.fromJson,
      fallback: _tempDataService.loadCourses,
    );
  }

  /// Fetch subjects from API, fallback to local.
  Future<List<SubjectModel>> getSubjects() async {
    return _fetchList<SubjectModel>(
      url: AppConstants.subjectsUrl,
      fromJson: SubjectModel.fromJson,
      fallback: _tempDataService.loadSubjects,
    );
  }

  /// Fetch topics from API, fallback to local.
  Future<List<TopicModel>> getTopics() async {
    return _fetchList<TopicModel>(
      url: AppConstants.topicsUrl,
      fromJson: TopicModel.fromJson,
      fallback: _tempDataService.loadTopics,
    );
  }

  /// Fetch notes from API, fallback to local.
  Future<List<NoteModel>> getNotes() async {
    return _fetchList<NoteModel>(
      url: AppConstants.notesUrl,
      fromJson: NoteModel.fromJson,
      fallback: _tempDataService.loadNotes,
    );
  }
}
