import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/fade_page_route.dart';
import '../../data/remote/api_service.dart';
import '../../data/models/topic_model.dart';
import '../../widgets/templates/list_card_template.dart';
import '../notes/notes_detail_screen.dart';

/// Topic list screen — filters topics by subjectId, uses ListCardTemplate.
class TopicListScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const TopicListScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  final ApiService _apiService = ApiService();
  List<TopicModel> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final allTopics = await _apiService.getTopics();
    if (mounted) {
      setState(() {
        _topics = allTopics
            .where((t) => t.subjectId == widget.subjectId)
            .toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListCardTemplate(
      pageTitle: '${widget.subjectName} Topics',
      subtitle: 'Select a topic to view notes',
      items: _topics,
      getTitle: (item) => (item as TopicModel).name,
      getSubtitle: (item) => 'Tap to read notes',
      getIcon: (item) => (item as TopicModel).icon,
      getAccentColor: (item) => AppTheme.primaryColor,
      onTap: (item) => () {
        final topic = item as TopicModel;
        Navigator.push(
          context,
          FadePageRoute(
            page: NotesDetailScreen(topicId: topic.id, topicName: topic.name),
          ),
        );
      },
      isLoading: _isLoading,
    );
  }
}
