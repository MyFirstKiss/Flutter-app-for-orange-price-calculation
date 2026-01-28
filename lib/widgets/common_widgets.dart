import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CommonWidgets {
  // Header with back button
  static Widget buildHeader({
    required String title,
    required VoidCallback onBack,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              shape: BoxShape.circle,
              boxShadow: AppTheme.shadowSM,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              padding: EdgeInsets.zero,
              onPressed: onBack,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              title,
              style: AppTheme.heading2,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // Card with gradient
  static Widget buildGradientCard({
    required Widget child,
    LinearGradient? gradient,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusM),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: AppTheme.shadowMD,
      ),
      child: child,
    );
  }

  // Icon circle with gradient
  static Widget buildIconCircle({
    required IconData icon,
    LinearGradient? gradient,
    double size = 48,
    double iconSize = 24,
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.orangeGradient,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }

  // Loading indicator
  static Widget buildLoadingIndicator({String? text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (text != null) ...[
            const SizedBox(height: AppTheme.spacingL),
            Text(text, style: AppTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  // Empty state
  static Widget buildEmptyState({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.textDisabled,
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(title, style: AppTheme.bodyLarge),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingS),
            Text(
              subtitle,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: AppTheme.spacingL),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('ลองอีกครั้ง'),
            ),
          ],
        ],
      ),
    );
  }

  // Status badge
  static Widget buildStatusBadge({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: AppTheme.fontSizeM,
            ),
          ),
        ],
      ),
    );
  }

  // Price card
  static Widget buildPriceCard({
    required String label,
    required String price,
    required String unit,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (backgroundColor ?? AppTheme.accentColor).withValues(alpha: 0.9),
            backgroundColor ?? AppTheme.accentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.shadowColored(backgroundColor ?? AppTheme.accentColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                price,
                style: const TextStyle(
                  fontSize: AppTheme.fontSize4XL,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                unit,
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: const Icon(
              Icons.attach_money,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
