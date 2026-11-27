import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class LanguageToggleSwitch extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleSelected;

  const LanguageToggleSwitch({
    super.key,
    required this.currentLocale,
    required this.onLocaleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnglish = currentLocale.languageCode == 'en';

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguagePillOption(
            label: 'EN',
            semanticLabel: 'English',
            isSelected: isEnglish,
            onTap: () => onLocaleSelected(const Locale('en')),
          ),
          SizedBox(width: 6.w),
          _LanguagePillOption(
            label: 'AR',
            semanticLabel: 'العربية',
            isSelected: !isEnglish,
            onTap: () => onLocaleSelected(const Locale('ar')),
          ),
        ],
      ),
    );
  }
}

class _LanguagePillOption extends StatelessWidget {
  final String label;
  final String semanticLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguagePillOption({
    required this.label,
    required this.semanticLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 48.w, minHeight: 40.h),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? Colors.black : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
