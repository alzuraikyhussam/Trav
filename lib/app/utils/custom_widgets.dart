import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../core/constants/app_colors.dart';

/// Animated Primary Button with press effects
class AnimatedPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? color;

  const AnimatedPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.color,
  });

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color ?? AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: _isPressed ? 2 : 6,
            shadowColor: (widget.color ?? AppColors.primary).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 1000.ms),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 20)
                          .animate(target: _isPressed ? 1 : 0)
                          .scaleXY(end: 1.2, duration: 100.ms),
                      const Gap(8),
                    ],
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      )
          .animate(target: _isPressed ? 1 : 0)
          .scaleXY(end: 0.95, duration: 100.ms)
          .then()
          .animate(target: widget.isLoading ? 1 : 0)
          .shimmer(duration: 1500.ms, color: AppColors.white.withOpacity(0.3)),
    );
  }
}

/// Animated Secondary Button (Outlined)
class AnimatedSecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? color;

  const AnimatedSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
    this.color,
  });

  @override
  State<AnimatedSecondaryButton> createState() => _AnimatedSecondaryButtonState();
}

class _AnimatedSecondaryButtonState extends State<AnimatedSecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.color ?? AppColors.primary,
            side: BorderSide(
              color: widget.color ?? AppColors.primary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20)
                    .animate(target: _isHovered ? 1 : 0)
                    .slideX(begin: 0, end: 0.1, duration: 200.ms),
                const Gap(8),
              ],
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      )
          .animate(target: _isHovered ? 1 : 0)
          .scaleXY(end: 1.02, duration: 200.ms)
          .then()
          .shimmer(
            duration: 800.ms,
            color: (widget.color ?? AppColors.primary).withOpacity(0.2),
          ),
    );
  }
}

/// Animated Card with hover effects
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          margin: widget.margin ?? const EdgeInsets.all(8),
          child: Card(
            elevation: _isHovered ? (widget.elevation ?? 4) + 4 : (widget.elevation ?? 4),
            color: widget.color ?? AppColors.cardBackground,
            shadowColor: AppColors.primary.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            ),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ),
      )
          .animate(target: _isHovered ? 1 : 0)
          .scaleXY(end: 1.02, duration: 200.ms)
          .then()
          .animate(target: _isPressed ? 1 : 0)
          .scaleXY(end: 0.98, duration: 100.ms),
    );
  }
}

/// Animated Text Field with focus effects
class AnimatedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;

  const AnimatedTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {
      _hasContent = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
                .animate(target: _isFocused ? 1 : 0)
                .tint(color: AppColors.primary, duration: 200.ms)
                .scaleXY(end: 1.1, duration: 200.ms)
            : null,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        filled: true,
        fillColor: _isFocused 
            ? AppColors.lightGrey.withOpacity(0.8)
            : AppColors.lightGrey,
      ),
    )
        .animate(target: _isFocused ? 1 : 0)
        .scaleXY(end: 1.01, duration: 200.ms)
        .then()
        .animate(target: _hasContent ? 1 : 0)
        .shimmer(
          duration: 500.ms,
          color: AppColors.success.withOpacity(0.3),
        );
  }
}

/// Animated Icon Button with ripple effect
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.tooltip,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: widget.onPressed,
            icon: Icon(
              widget.icon,
              color: widget.color ?? AppColors.textPrimary,
              size: widget.size,
            ),
          ),
        ),
      )
          .animate(target: _isPressed ? 1 : 0)
          .scaleXY(end: 0.9, duration: 100.ms)
          .then()
          .animate(
            onPlay: (controller) => _isPressed 
                ? controller.forward() 
                : null,
          )
          .shimmer(duration: 300.ms, color: AppColors.primary.withOpacity(0.3)),
    );
  }
}

/// Animated Floating Action Button
class AnimatedFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AnimatedFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        tooltip: widget.tooltip,
        backgroundColor: widget.backgroundColor ?? AppColors.secondary,
        foregroundColor: widget.foregroundColor ?? AppColors.white,
        elevation: _isPressed ? 2 : 6,
        child: Icon(widget.icon),
      ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scaleXY(end: 0.9, duration: 100.ms)
        .then()
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scaleXY(end: 1.05, duration: 2000.ms);
  }
}

/// Animated Chip with selection effects
class AnimatedChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;
  final Color? unselectedColor;

  const AnimatedChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  State<AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<AnimatedChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected 
                ? (widget.selectedColor ?? AppColors.primary)
                : (widget.unselectedColor ?? AppColors.lightGrey),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected 
                  ? (widget.selectedColor ?? AppColors.primary)
                  : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.isSelected ? AppColors.white : AppColors.textSecondary,
                )
                    .animate(target: widget.isSelected ? 1 : 0)
                    .rotate(duration: 300.ms),
                const Gap(6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(target: widget.isSelected ? 1 : 0)
        .scaleXY(end: 1.05, duration: 200.ms)
        .then()
        .animate(target: _isHovered ? 1 : 0)
        .scaleXY(end: 1.02, duration: 150.ms);
  }
}

/// Animated Loading Overlay
class AnimatedLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;
  final Color? overlayColor;

  const AnimatedLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: (overlayColor ?? AppColors.black).withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 1000.ms)
                      .then()
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scaleXY(end: 1.2, duration: 800.ms),
                  if (loadingText != null) ...[
                    const Gap(16),
                    Text(
                      loadingText!,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .fadeIn(begin: 0.5, end: 1.0, duration: 800.ms),
                  ],
                ],
              ),
            ),
          )
              .animate(target: isLoading ? 1 : 0)
              .fadeIn(duration: 300.ms),
      ],
    );
  }
}