import 'package:flutter/material.dart';
import '../config/theme/app_colors.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const ErrorStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.onRetry,
    this.retryButtonText,
  });

  // Predefined error states
  static Widget networkError({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      title: 'Không thể kết nối',
      message: 'Vui lòng kiểm tra kết nối mạng và thử lại',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      retryButtonText: 'Thử lại',
    );
  }

  static Widget serverError({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      title: 'Lỗi máy chủ',
      message: 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau',
      icon: Icons.error_outline_rounded,
      onRetry: onRetry,
      retryButtonText: 'Thử lại',
    );
  }

  static Widget noData({
    required String title,
    String? message,
    IconData? icon,
  }) {
    return ErrorStateWidget(
      title: title,
      message: message,
      icon: icon ?? Icons.inbox_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.orange_light_2.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: 48,
                color: AppColors.orange,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.drak,
              ),
              textAlign: TextAlign.center,
            ),

            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.light,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (onRetry != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(retryButtonText ?? 'Thử lại'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Empty state widget for when there's no data to show
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (action != null) ...[const SizedBox(height: 32), action!],
          ],
        ),
      ),
    );
  }
}
