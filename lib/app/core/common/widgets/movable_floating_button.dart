import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_size_theme.dart';

class MovableFloatingButton extends StatefulWidget with AppSizeTheme {
  final IconData? icon;
  final Color color;
  final VoidCallback? onTap;
  final Offset? initialPosition; // optional, will default to bottom-left

  const MovableFloatingButton({
    super.key,
    this.icon = Icons.home,
    this.onTap,
    this.color = AppColors.primary,
    this.initialPosition,
  });

  @override
  State<MovableFloatingButton> createState() => _MovableFloatingButtonState();
}

class _MovableFloatingButtonState extends State<MovableFloatingButton> {
  late double x;
  late double y;

  @override
  void initState() {
    super.initState();
    // Initialize with 0; will set proper position after layout
    x = 0;
    y = 0;

    // Wait for first frame to get MediaQuery size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      final double buttonSize = 50.r;

      setState(() {
        x = widget.initialPosition?.dx ?? 20; // default left padding
        y = widget.initialPosition?.dy ??
            (screenSize.height - buttonSize - 100); // bottom-left
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double buttonSize = 50.r;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            x += details.delta.dx;
            y += details.delta.dy;
            // keep inside screen
            x = x.clamp(0.0, screenSize.width - buttonSize);
            y = y.clamp(0.0, screenSize.height - buttonSize - 60);
          });
        },
        onPanEnd: (_) {
          setState(() {
            // Snap to left or right edge
            x = x < screenSize.width / 2
                ? 10
                : screenSize.width - buttonSize - 10;
          });
        },
        onTap: widget.onTap ?? () {},
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: AppColors.gray500,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: AppColors.white,
            size: buttonSize * 0.5,
          ),
        ),
      ),
    );
  }
}
