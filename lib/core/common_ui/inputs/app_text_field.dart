import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final String? obscureTooltip;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.inputFormatters,
    this.obscureTooltip,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: widget.hintText,
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 16.w, end: 12.w),
          child: Icon(widget.prefixIcon, color: AppColors.white, size: 22.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 24.h),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: widget.obscureTooltip,
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.white,
                  size: 22.sp,
                ),
              )
            : null,
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        border: _outlineBorder(AppColors.transparent),
        enabledBorder: _outlineBorder(AppColors.transparent),
        focusedBorder: _outlineBorder(AppColors.primary),
        errorBorder: _outlineBorder(AppColors.actionRed),
        focusedErrorBorder: _outlineBorder(AppColors.actionRed),
      ),
    );
  }

  OutlineInputBorder _outlineBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: borderColor, width: 1.2),
    );
  }
}
