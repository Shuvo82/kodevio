import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_size_theme.dart';

class HomeLoadingState extends StatelessWidget with AppSizeTheme {
  const HomeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(color: AppColors.primary, size: size.iconExtraLarge),
          SizedBox(height: size.spacingLarge),
          CustomTextWidget(
            text: 'Loading users...',
            fontSize: size.textMedium,
            fontColor: theme.tertiary,
          ),
        ],
      ),
    );
  }
}