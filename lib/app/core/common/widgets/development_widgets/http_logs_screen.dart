import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constant/app_size_theme.dart';
import '../../../services/http_logger_service.dart';
import '../../../services/theme_service.dart';
import '../custom_text_widget.dart';
import '../ui.dart';

class HttpLogsScreen extends StatelessWidget with AppSizeTheme {
  const HttpLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = HttpLoggerService.to;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: CustomTextWidget(
          text: 'HTTP Logs',
          fontSize: size.textLarge,
          fontWeight: FontWeight.bold,
          fontColor: theme.colorScheme.tertiary,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (logger.logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bug_report,
                  size: size.avatarMedium,
                  color: theme.colorScheme.onTertiary,
                ),
                SizedBox(height: size.spacingMedium),
                CustomTextWidget(
                  text: 'No HTTP calls yet',
                  fontColor: theme.colorScheme.onTertiary,
                  fontSize: size.textSmall,
                ),
                SizedBox(height: size.spacingSmall),
                CustomTextWidget(
                  text: 'Make some API calls to see them here',
                  fontColor: theme.colorScheme.onTertiary.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: size.textXSmall,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(size.paddingMedium),
          itemCount: logger.logs.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: size.spacingSmall),
          itemBuilder: (context, index) {
            final log = logger.logs[index];
            return _HttpLogCard(log: log);
          },
        );
      }),
    );
  }
}

class _HttpLogCard extends StatelessWidget with AppSizeTheme {
  final HttpLog log;

  const _HttpLogCard({required this.log});

  Color _statusColor(BuildContext context) {
    final theme = Theme.of(context);
    if (log.error != null) return theme.colorScheme.error;
    if (log.statusCode == null) return theme.colorScheme.onTertiary;
    if (log.statusCode! >= 200 && log.statusCode! < 300) {
      return ThemeService.to.isDarkMode ? Colors.green.shade300 : Colors.green;
    }
    if (log.statusCode! >= 400) return theme.colorScheme.error;
    return theme.colorScheme.primary;
  }

  Color _methodColor(BuildContext context) {
    final isDark = ThemeService.to.isDarkMode;
    switch (log.method.toUpperCase()) {
      case 'GET':
        return isDark ? Colors.blue.shade300 : Colors.blue;
      case 'POST':
        return isDark ? Colors.green.shade300 : Colors.green;
      case 'PUT':
        return isDark ? Colors.orange.shade300 : Colors.orange;
      case 'DELETE':
        return isDark ? Colors.red.shade300 : Colors.red;
      default:
        return Theme.of(context).colorScheme.onTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.tertiaryContainer,
      elevation: 2,
      shadowColor: theme.colorScheme.onTertiary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.radiusSmall),
        side: BorderSide(color: _statusColor(context), width: 2),
      ),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(size.radiusSmall),
        child: Padding(
          padding: EdgeInsets.all(size.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Method Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.spacingSmall,
                      vertical: size.spacingTiny,
                    ),
                    decoration: BoxDecoration(
                      color: _methodColor(context),
                      borderRadius: BorderRadius.circular(size.radiusTiny),
                    ),
                    child: CustomTextWidget(
                      text: log.methodDisplay,
                      fontColor: Colors.white,
                      fontSize: size.textXXSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: size.spacingSmall),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.spacingSmall,
                      vertical: size.spacingTiny,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(context),
                      borderRadius: BorderRadius.circular(size.radiusTiny),
                    ),
                    child: CustomTextWidget(
                      text: log.statusDisplay,
                      fontColor: Colors.white,
                      fontSize: size.textXXSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  // Time
                  CustomTextWidget(
                    text: log.timeDisplay,
                    fontColor: theme.colorScheme.onTertiary,
                    fontSize: size.textXXSmall,
                  ),
                  SizedBox(width: size.spacingSmall),

                  // Duration
                  CustomTextWidget(
                    text: log.durationDisplay,
                    fontColor: theme.colorScheme.primary,
                    fontSize: size.textXXSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),

              SizedBox(height: size.spacingSmall),

              // URL
              CustomTextWidget(
                text: log.url,
                fontSize: size.textXXXSmall,
                fontWeight: FontWeight.w500,
              ),

              // Error message if present
              if (log.error != null) ...[
                SizedBox(height: size.spacingTiny),
                CustomTextWidget(
                  text: log.error!,
                  fontColor: theme.colorScheme.error,
                  fontSize: size.textXXSmall,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    Get.to(
      () => _HttpLogDetailsScreen(log: log),
      transition: Transition.rightToLeft,
    );
  }
}

class _HttpLogDetailsScreen extends StatelessWidget with AppSizeTheme {
  final HttpLog log;

  const _HttpLogDetailsScreen({required this.log});

  @override
  Widget build(BuildContext context) {
    final logger = HttpLoggerService.to;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: CustomTextWidget(
          text: 'HTTP Log Details',
          fontSize: size.textLarge,
          fontWeight: FontWeight.bold,
          fontColor: theme.colorScheme.tertiary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview
            _buildSection(
              context,
              'Overview',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKeyValue(context, 'URL', log.url),
                  _buildKeyValue(context, 'Method', log.methodDisplay),
                  _buildKeyValue(context, 'Status', log.statusDisplay),
                  _buildKeyValue(context, 'Time', log.timeDisplay),
                  _buildKeyValue(context, 'Duration', log.durationDisplay),
                  if (log.error != null)
                    _buildKeyValue(context, 'Error', log.error!),
                ],
              ),
            ),

            SizedBox(height: size.spacingMedium),

            // Request Headers
            if (log.requestHeaders != null)
              _buildSection(
                context,
                'Request Headers',
                _buildJsonDisplay(context, log.requestHeaders, logger),
              ),

            SizedBox(height: size.spacingMedium),

            // Request Body
            if (log.requestBody != null)
              _buildSection(
                context,
                'Request Body',
                _buildJsonDisplay(context, log.requestBody, logger),
              ),

            SizedBox(height: size.spacingMedium),

            // Response Headers
            if (log.responseHeaders != null)
              _buildSection(
                context,
                'Response Headers',
                _buildJsonDisplay(context, log.responseHeaders, logger),
              ),

            SizedBox(height: size.spacingMedium),

            // Response Body
            if (log.responseBody != null)
              _buildSection(
                context,
                'Response Body',
                _buildJsonDisplay(context, log.responseBody, logger),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: title,
          fontSize: size.textSmall,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: size.spacingSmall),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(size.paddingSmall),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(size.radiusSmall),
            border: Border.all(
              color: theme.colorScheme.onTertiary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: content,
        ),
      ],
    );
  }

  Widget _buildKeyValue(BuildContext context, String key, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: size.spacingTiny),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            text: '$key: ',
            fontColor: theme.colorScheme.primary,
            fontSize: size.textXXXSmall,
            fontWeight: FontWeight.bold,
          ),
          Expanded(
            child: CustomTextWidget(text: value, fontSize: size.textXXXSmall),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonDisplay(
    BuildContext context,
    dynamic json,
    HttpLoggerService logger,
  ) {
    final theme = Theme.of(context);
    final formatted = logger.formatJson(json);

    return Stack(
      children: [
        SelectableText.rich(
          _buildColorizedJson(formatted, theme),
          style: TextStyle(fontSize: size.textXXSmall, fontFamily: 'monospace'),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(
              Icons.copy,
              size: size.radiusLarge,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formatted));
              Ui.successSnackBar(
                title: 'Copied',
                message: 'Copied to clipboard',
              );
            },
          ),
        ),
      ],
    );
  }

  TextSpan _buildColorizedJson(String jsonString, ThemeData theme) {
    final List<TextSpan> spans = [];
    final isDark = ThemeService.to.isDarkMode;

    // Define colors for different JSON elements
    final keyColor = isDark ? Colors.lightBlue.shade300 : Colors.blue.shade700;
    final stringColor = isDark ? Colors.green.shade300 : Colors.green.shade700;
    final numberColor = isDark
        ? Colors.orange.shade300
        : Colors.orange.shade700;
    final boolColor = isDark ? Colors.purple.shade300 : Colors.purple.shade700;
    final nullColor = isDark ? Colors.red.shade300 : Colors.red.shade700;
    final bracketColor = theme.colorScheme.tertiary;
    final defaultColor = theme.colorScheme.tertiary;

    // Regex patterns for JSON syntax highlighting
    final pattern = RegExp(
      r'("(?:[^"\\]|\\.)*")\s*:|' // Keys (strings followed by colon)
      r':\s*("(?:[^"\\]|\\.)*")|' // String values
      r':\s*(-?\d+\.?\d*)|' // Number values
      r':\s*(true|false)|' // Boolean values
      r':\s*(null)|' // Null values
      r'([{}\[\],])', // Structural characters
    );

    int lastIndex = 0;

    for (final match in pattern.allMatches(jsonString)) {
      // Add any text before this match (whitespace, etc.)
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: jsonString.substring(lastIndex, match.start),
            style: TextStyle(color: defaultColor),
          ),
        );
      }

      // Determine what type of match this is and color accordingly
      if (match.group(1) != null) {
        // JSON key
        spans.add(
          TextSpan(
            text: match.group(1),
            style: TextStyle(color: keyColor, fontWeight: FontWeight.bold),
          ),
        );
        spans.add(
          TextSpan(
            text: ':',
            style: TextStyle(color: bracketColor),
          ),
        );
      } else if (match.group(2) != null) {
        // String value
        spans.add(
          TextSpan(
            text: ': ${match.group(2)}',
            style: TextStyle(color: stringColor),
          ),
        );
      } else if (match.group(3) != null) {
        // Number value
        spans.add(
          TextSpan(
            text: ': ${match.group(3)}',
            style: TextStyle(color: numberColor),
          ),
        );
      } else if (match.group(4) != null) {
        // Boolean value
        spans.add(
          TextSpan(
            text: ': ${match.group(4)}',
            style: TextStyle(color: boolColor, fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.group(5) != null) {
        // Null value
        spans.add(
          TextSpan(
            text: ': ${match.group(5)}',
            style: TextStyle(color: nullColor, fontStyle: FontStyle.italic),
          ),
        );
      } else if (match.group(6) != null) {
        // Brackets, braces, commas
        spans.add(
          TextSpan(
            text: match.group(6),
            style: TextStyle(color: bracketColor, fontWeight: FontWeight.bold),
          ),
        );
      }

      lastIndex = match.end;
    }

    // Add any remaining text
    if (lastIndex < jsonString.length) {
      spans.add(
        TextSpan(
          text: jsonString.substring(lastIndex),
          style: TextStyle(color: defaultColor),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
