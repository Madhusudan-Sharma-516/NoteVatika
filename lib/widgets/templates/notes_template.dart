import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/notes_model.dart';

/// Reusable notes content renderer.
/// Renders heading, introduction, key points, code block, table, image, and summary.
class NotesTemplate extends StatefulWidget {
  final NoteModel note;
  final bool isLoading;

  const NotesTemplate({super.key, required this.note, required this.isLoading});

  @override
  State<NotesTemplate> createState() => _NotesTemplateState();
}

class _NotesTemplateState extends State<NotesTemplate>
    with TickerProviderStateMixin {
  late AnimationController _headingController;
  late AnimationController _introController;
  late AnimationController _summaryController;
  final List<AnimationController> _keyPointControllers = [];

  late Animation<double> _headingFade;
  late Animation<double> _introFade;
  late Animation<Offset> _introSlide;
  late Animation<double> _summaryFade;
  late Animation<Offset> _summarySlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Heading fade-in
    _headingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _headingFade = CurvedAnimation(
      parent: _headingController,
      curve: Curves.easeOut,
    );

    // Introduction slide-up + fade
    _introController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _introFade = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );
    _introSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    // Summary slide-up + fade
    _summaryController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _summaryFade = CurvedAnimation(
      parent: _summaryController,
      curve: Curves.easeOut,
    );
    _summarySlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _summaryController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Key point stagger controllers
    for (int i = 0; i < widget.note.keyPoints.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      _keyPointControllers.add(controller);
    }

    // Start staggered animations
    _headingController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _introController.forward();
    });
    for (int i = 0; i < _keyPointControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 400 + (100 * i)), () {
        if (mounted && i < _keyPointControllers.length) {
          _keyPointControllers[i].forward();
        }
      });
    }
    Future.delayed(
      Duration(milliseconds: 600 + (100 * widget.note.keyPoints.length)),
      () {
        if (mounted) _summaryController.forward();
      },
    );
  }

  @override
  void dispose() {
    _headingController.dispose();
    _introController.dispose();
    _summaryController.dispose();
    for (final c in _keyPointControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingMD),
          // ── Section 1: Heading ──
          _buildHeadingSection(),
          const SizedBox(height: AppTheme.spacingLG),
          // ── Section 2: Introduction ──
          _buildIntroductionSection(),
          const SizedBox(height: AppTheme.spacingLG),
          // ── Section 3: Key Points ──
          _buildKeyPointsSection(),
          const SizedBox(height: AppTheme.spacingLG),
          // ── Section 4: Code Block ──
          if (widget.note.codeBlock != null) ...[
            _buildCodeBlockSection(),
            const SizedBox(height: AppTheme.spacingLG),
          ],
          // ── Section 5: Table ──
          if (widget.note.table != null) ...[
            _buildTableSection(),
            const SizedBox(height: AppTheme.spacingLG),
          ],
          // ── Section 6: Image ──
          if (widget.note.imagePath != null &&
              widget.note.imagePath!.isNotEmpty) ...[
            _buildImageSection(),
            const SizedBox(height: AppTheme.spacingLG),
          ],
          // ── Section 8: Summary ──
          _buildSummarySection(),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  // ───────────────────────── Heading ──────────────────────────────
  Widget _buildHeadingSection() {
    return FadeTransition(
      opacity: _headingFade,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.note.heading,
            style: AppTheme.headingLarge.copyWith(color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.note.subtitle,
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Introduction ─────────────────────────
  Widget _buildIntroductionSection() {
    return SlideTransition(
      position: _introSlide,
      child: FadeTransition(
        opacity: _introFade,
        child: Text(widget.note.introduction, style: AppTheme.bodyLarge),
      ),
    );
  }

  // ───────────────────────── Key Points ───────────────────────────
  Widget _buildKeyPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Points:',
          style: AppTheme.headingSmall.copyWith(color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 10),
        ...List.generate(widget.note.keyPoints.length, (index) {
          final controller = index < _keyPointControllers.length
              ? _keyPointControllers[index]
              : null;

          final child = Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(color: AppTheme.secondaryColor, width: 3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '→ ',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.note.keyPoints[index],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (controller != null) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: controller,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          }
          return child;
        }),
      ],
    );
  }

  // ───────────────────────── Code Block ───────────────────────────
  Widget _buildCodeBlockSection() {
    final codeBlock = widget.note.codeBlock!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.codeBlockBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with language badge and copy button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.highlightColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    codeBlock.language.toUpperCase(),
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white70, size: 18),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: codeBlock.code));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('✅ Code copied to clipboard'),
                          backgroundColor: AppTheme.secondaryColor,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Text(codeBlock.code, style: AppTheme.codeText),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Table ─────────────────────────────────
  Widget _buildTableSection() {
    final table = widget.note.table!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
          color: Colors.grey.shade300,
          width: 1,
          borderRadius: BorderRadius.circular(8),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            children: table.headers
                .map(
                  (header) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      header,
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          // Data rows
          ...table.rows.asMap().entries.map((entry) {
            final isEven = entry.key % 2 == 0;
            return TableRow(
              decoration: BoxDecoration(
                color: isEven ? Colors.white : AppTheme.accentColor,
              ),
              children: entry.value
                  .map(
                    (cell) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        cell,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  // ───────────────────────── Image ─────────────────────────────────
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.note.imagePath!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ),
        if (widget.note.imageCaption.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            widget.note.imageCaption,
            style: AppTheme.bodySmall.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }

  // ───────────────────────── Summary ──────────────────────────────
  Widget _buildSummarySection() {
    return SlideTransition(
      position: _summarySlide,
      child: FadeTransition(
        opacity: _summaryFade,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📝 Summary',
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.note.summary,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
