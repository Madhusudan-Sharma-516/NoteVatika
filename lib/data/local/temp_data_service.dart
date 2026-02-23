import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../models/course_model.dart';
import '../models/subject_model.dart';
import '../models/topic_model.dart';
import '../models/notes_model.dart';

/// Service that loads data from local temp JSON assets.
/// Used as a fallback when network is unavailable.
class TempDataService {
  /// Load all courses from local temp data.
  Future<List<CourseModel>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      AppConstants.tempCoursesPath,
    );
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Load all subjects from local temp data.
  Future<List<SubjectModel>> loadSubjects() async {
    final jsonString = await rootBundle.loadString(
      AppConstants.tempSubjectsPath,
    );
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => SubjectModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Load all topics from local temp data.
  Future<List<TopicModel>> loadTopics() async {
    final jsonString = await rootBundle.loadString(AppConstants.tempTopicsPath);
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => TopicModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Load all notes from local temp data.
  Future<List<NoteModel>> loadNotes() async {
    final jsonString = await rootBundle.loadString(AppConstants.tempNotesPath);
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => NoteModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
