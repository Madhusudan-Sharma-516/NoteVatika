import 'package:flutter/material.dart';
import '../../core/utils/fade_page_route.dart';
import '../../data/remote/api_service.dart';
import '../../data/models/course_model.dart';
import '../../widgets/templates/list_card_template.dart';
import '../subjects/subject_list_screen.dart';

/// Course list screen — uses the reusable ListCardTemplate.
class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final ApiService _apiService = ApiService();
  List<CourseModel> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _apiService.getCourses();
    if (mounted) {
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListCardTemplate(
      pageTitle: 'Courses',
      subtitle: 'Select a course to view subjects',
      items: _courses,
      getTitle: (item) => (item as CourseModel).name,
      getSubtitle: (item) => (item as CourseModel).fullName,
      getIcon: (item) => (item as CourseModel).icon,
      getAccentColor: (item) => (item as CourseModel).color,
      onTap: (item) => () {
        final course = item as CourseModel;
        Navigator.push(
          context,
          FadePageRoute(
            page: SubjectListScreen(
              courseId: course.id,
              courseName: course.name,
            ),
          ),
        );
      },
      isLoading: _isLoading,
    );
  }
}
