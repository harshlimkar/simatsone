import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';

class SimatsTextField extends StatelessWidget {
  const SimatsTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.focusNode,
  });
  final TextEditingController? controller;
  final String? label, hint, errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText, enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext c) => TextFormField(
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText,
    keyboardType: keyboardType,
    validator: validator,
    onChanged: onChanged,
    enabled: enabled,
    style: SimatsTextStyles.bodyLg.copyWith(color: SimatsColors.onSurface),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: SimatsColors.onSurfaceVariant, size: 20)
          : null,
      suffixIcon: suffixIcon,
      constraints: const BoxConstraints(minHeight: SimatsSpacing.inputHeight),
    ),
  );
}
