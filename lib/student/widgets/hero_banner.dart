import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, this.imageAsset, this.onExplore});

  final String? imageAsset;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final asset = imageAsset;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 170,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDarkColor, AppColors.primaryColor],
          ),
        ),
        child: Stack(
          children: [
            if (asset != null) ...[
              Positioned.fill(
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ] else
              Positioned(
                right: 16,
                bottom: 8,
                child: Icon(
                  Icons.psychology_alt_rounded,
                  size: 110,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learn New Skills\nBuild Your Future',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onExplore,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Explore Courses',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDarkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
