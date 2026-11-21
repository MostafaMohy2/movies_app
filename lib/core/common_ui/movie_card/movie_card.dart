import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../entities/movie_entity.dart';
import '../../theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double aspectRatio;
  final double borderRadius;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width,
    this.height,
    this.aspectRatio = 2 / 3,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie Poster
            CachedNetworkImage(
              imageUrl: movie.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: AppColors.surface,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surface,
                child: const Icon(
                  Icons.movie_outlined,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            // Rating Badge (Top Start)
            if (movie.rating > 0)
              PositionedDirectional(
                top: 8,
                start: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ) ??
                            const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.starRating,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (width != null || height != null) {
      cardContent = SizedBox(width: width, height: height, child: cardContent);
    } else {
      cardContent = AspectRatio(aspectRatio: aspectRatio, child: cardContent);
    }

    return cardContent;
  }
}
