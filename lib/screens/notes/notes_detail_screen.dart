import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/ad_helper.dart';
import '../../data/remote/api_service.dart';
import '../../data/models/notes_model.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/templates/notes_template.dart';
import '../../widgets/templates/ad_banner_widget.dart';

/// Notes detail screen — displays rich note content with bookmark and ads.
class NotesDetailScreen extends StatefulWidget {
  final String topicId;
  final String topicName;

  const NotesDetailScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<NotesDetailScreen> createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  final ApiService _apiService = ApiService();
  NoteModel? _note;
  bool _isLoading = true;
  bool _isBookmarked = false;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadNote();
    _loadBookmarkState();
    _loadInterstitialAd();
  }

  Future<void> _loadNote() async {
    final allNotes = await _apiService.getNotes();
    if (mounted) {
      final filtered = allNotes.where((n) => n.topicId == widget.topicId);
      setState(() {
        _note = filtered.isNotEmpty ? filtered.first : null;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBookmarkState() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'bookmark_${widget.topicId}';
    if (mounted) {
      setState(() {
        _isBookmarked = prefs.getBool(key) ?? false;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'bookmark_${widget.topicId}';
    final nameKey = 'bookmark_name_${widget.topicId}';
    final noteIdKey = 'bookmark_noteId_${widget.topicId}';

    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    if (_isBookmarked) {
      await prefs.setBool(key, true);
      await prefs.setString(nameKey, widget.topicName);
      if (_note != null) {
        await prefs.setString(noteIdKey, _note!.id);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🔖 Bookmark saved!'),
            backgroundColor: AppTheme.secondaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      await prefs.remove(key);
      await prefs.remove(nameKey);
      await prefs.remove(noteIdKey);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bookmark removed'),
            backgroundColor: AppTheme.textSecondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          // Show after 2 second delay
          Future.delayed(AppConstants.interstitialAdDelay, () {
            if (mounted && _interstitialAd != null) {
              _interstitialAd!.show();
            }
          });
        },
        onAdFailedToLoad: (error) {
          // Silent fail — skip ad
          _interstitialAd = null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBarWidget(
        title: widget.topicName,
        actionIcon: IconButton(
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: _isBookmarked ? AppTheme.highlightColor : Colors.white,
          ),
          onPressed: _toggleBookmark,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const LoadingWidget(itemCount: 3)
                : _note == null
                ? _buildNoNotes()
                : NotesTemplate(note: _note!, isLoading: _isLoading),
          ),
          // Bottom ad banner
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildNoNotes() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No notes available for this topic yet.',
            style: AppTheme.bodyMedium.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
