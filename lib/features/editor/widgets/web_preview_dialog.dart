import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../app/theme/app_colors.dart';

class WebPreviewDialog extends StatefulWidget {
  final String htmlContent;

  const WebPreviewDialog({super.key, required this.htmlContent});

  @override
  State<WebPreviewDialog> createState() => _WebPreviewDialogState();
}

class _WebPreviewDialogState extends State<WebPreviewDialog> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariantDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Web Live Preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.textSecondaryDark),
                  onPressed: () {
                    setState(() => _isLoading = true);
                    _controller.loadHtmlString(widget.htmlContent);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Web View Content Area
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryBlue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
