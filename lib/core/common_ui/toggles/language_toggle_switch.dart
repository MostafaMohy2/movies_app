import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

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
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FlagOption(
            semanticLabel: 'English',
            isSelected: isEnglish,
            onTap: () => onLocaleSelected(const Locale('en')),
            flag: const _UsFlagIcon(),
          ),
          SizedBox(width: 8.w),
          _FlagOption(
            semanticLabel: 'العربية',
            isSelected: !isEnglish,
            onTap: () => onLocaleSelected(const Locale('ar')),
            flag: const _EgyptFlagIcon(),
          ),
        ],
      ),
    );
  }
}

class _FlagOption extends StatelessWidget {
  final String semanticLabel;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget flag;

  const _FlagOption({
    required this.semanticLabel,
    required this.isSelected,
    required this.onTap,
    required this.flag,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34.r,
          height: 34.r,
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.transparent,
              width: 2.5,
            ),
          ),
          child: ClipOval(child: flag),
        ),
      ),
    );
  }
}

class _UsFlagIcon extends StatelessWidget {
  const _UsFlagIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: List.generate(
            7,
            (index) => Expanded(
              child: Container(
                color: index.isEven ? AppColors.actionRed : AppColors.white,
              ),
            ),
          ),
        ),
        FractionallySizedBox(
          alignment: Alignment.topLeft,
          widthFactor: 0.5,
          heightFactor: 0.55,
          child: Container(
            color: const Color(0xFF0A3161),
            alignment: Alignment.center,
            child: Icon(Icons.star, size: 8.r, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

class _EgyptFlagIcon extends StatelessWidget {
  const _EgyptFlagIcon();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(color: AppColors.actionRed)),
        Expanded(
          child: Container(
            color: AppColors.white,
            alignment: Alignment.center,
            child: Icon(
              Icons.shield_outlined,
              size: 7.r,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        Expanded(child: Container(color: AppColors.background)),
      ],
    );
  }
}
