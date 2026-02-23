import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../common/app_bar_widget.dart';
import '../common/loading_widget.dart';
import 'ad_banner_widget.dart';

/// Reusable list screen template used by Course, Subject, and Topic screens.
/// Provides staggered card animations, accent bar, icon, and chevron.
class ListCardTemplate extends StatefulWidget {
  final String pageTitle;
  final String subtitle;
  final List<dynamic> items;
  final String Function(dynamic item) getTitle;
  final String Function(dynamic item) getSubtitle;
  final String Function(dynamic item) getIcon;
  final Color Function(dynamic item) getAccentColor;
  final VoidCallback Function(dynamic item) onTap;
  final bool isLoading;

  const ListCardTemplate({
    super.key,
    required this.pageTitle,
    required this.subtitle,
    required this.items,
    required this.getTitle,
    required this.getSubtitle,
    required this.getIcon,
    required this.getAccentColor,
    required this.onTap,
    required this.isLoading,
  });

  @override
  State<ListCardTemplate> createState() => _ListCardTemplateState();
}

class _ListCardTemplateState extends State<ListCardTemplate>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void didUpdateWidget(ListCardTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length && !widget.isLoading) {
      _disposeControllers();
      _initAnimations();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isLoading) {
      _initAnimations();
    }
  }

  void _initAnimations() {
    for (int i = 0; i < widget.items.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );

      final slideAnimation =
          Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
          );

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _controllers.add(controller);
      _slideAnimations.add(slideAnimation);
      _fadeAnimations.add(fadeAnimation);

      // Staggered delay: 50ms per item
      Future.delayed(Duration(milliseconds: 50 * i), () {
        if (mounted && i < _controllers.length) {
          _controllers[i].forward();
        }
      });
    }
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _slideAnimations.clear();
    _fadeAnimations.clear();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBarWidget(title: widget.pageTitle),
      body: Column(
        children: [
          // Subtitle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingMD,
              AppTheme.spacingMD,
              AppTheme.spacingMD,
              AppTheme.spacingSM,
            ),
            child: Text(
              widget.subtitle,
              style: AppTheme.bodyMedium.copyWith(fontSize: 14),
            ),
          ),
          // List content
          Expanded(
            child: widget.isLoading
                ? const LoadingWidget()
                : widget.items.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMD,
                      vertical: AppTheme.spacingSM,
                    ),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      if (index >= _controllers.length) {
                        return _buildCard(widget.items[index], null, null);
                      }
                      return SlideTransition(
                        position: _slideAnimations[index],
                        child: FadeTransition(
                          opacity: _fadeAnimations[index],
                          child: _buildCard(
                            widget.items[index],
                            _controllers[index],
                            index,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Bottom ad banner
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: AppTheme.bodyMedium.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(dynamic item, AnimationController? controller, int? index) {
    final accentColor = widget.getAccentColor(item);

    return _ScaleOnTapCard(
      onTap: widget.onTap(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.getIcon(item),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title & Subtitle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.getTitle(item),
                        style: AppTheme.headingSmall.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.getSubtitle(item),
                        style: AppTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Chevron
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A wrapper widget that adds a subtle scale-down animation on tap.
class _ScaleOnTapCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ScaleOnTapCard({required this.child, required this.onTap});

  @override
  State<_ScaleOnTapCard> createState() => _ScaleOnTapCardState();
}

class _ScaleOnTapCardState extends State<_ScaleOnTapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
