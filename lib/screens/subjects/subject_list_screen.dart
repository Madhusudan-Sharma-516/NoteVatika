import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/fade_page_route.dart';
import '../../data/remote/api_service.dart';
import '../../data/models/subject_model.dart';
import '../../widgets/templates/list_card_template.dart';
import '../topics/topic_list_screen.dart';

/// Subject list screen — filters subjects by courseId, uses ListCardTemplate.
class SubjectListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const SubjectListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final ApiService _apiService = ApiService();
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final allSubjects = await _apiService.getSubjects();
    if (mounted) {
      setState(() {
        _subjects = allSubjects
            .where((s) => s.courseId == widget.courseId)
            .toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListCardTemplate(
      pageTitle: '${widget.courseName} Subjects',
      subtitle: 'Select a subject to view topics',
      items: _subjects,
      getTitle: (item) => (item as SubjectModel).name,
      getSubtitle: (item) => (item as SubjectModel).code,
      getIcon: (item) => (item as SubjectModel).icon,
      getAccentColor: (item) => AppTheme.secondaryColor,
      onTap: (item) => () {
        final subject = item as SubjectModel;
        Navigator.push(
          context,
          FadePageRoute(
            page: TopicListScreen(
              subjectId: subject.id,
              subjectName: subject.name,
            ),
          ),
        );
      },
      isLoading: _isLoading,
    );
  }
}
