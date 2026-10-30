import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/student/models/course_pdf_model.dart';

const Color _pdfIconBackground = Color(0xFFFDECEC);
const Color _pdfIconColor = Color(0xFFD64545);

/// "Course Materials" section: a title, a subtitle and one card per PDF.
class CoursePdfSection extends StatelessWidget {
  const CoursePdfSection({super.key, required this.pdfs, this.onDownload});

  final List<CoursePdfModel> pdfs;

  /// Called when a card or its download button is tapped.
  /// When null, a "coming soon" SnackBar is shown instead.
  final ValueChanged<CoursePdfModel>? onDownload;

  void _handleDownload(BuildContext context, CoursePdfModel pdf) {
    final callback = onDownload;
    if (callback != null) {
      callback(pdf);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('PDF download will be available soon')),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (pdfs.isEmpty) return const SizedBox.shrink();

    final mutedText = AppColors.largeTextColor.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Course Materials',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.largeTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Download additional learning resources',
          style: TextStyle(fontSize: 13, color: mutedText),
        ),
        const SizedBox(height: 12),
        for (final pdf in pdfs)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PdfCard(
              pdf: pdf,
              onTap: () => _handleDownload(context, pdf),
            ),
          ),
      ],
    );
  }
}

class _PdfCard extends StatelessWidget {
  const _PdfCard({required this.pdf, required this.onTap});

  final CoursePdfModel pdf;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mutedText = AppColors.largeTextColor.withValues(alpha: 0.6);
    final description = pdf.description;

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _pdfIconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: _pdfIconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pdf.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.largeTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pdf.size,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: mutedText,
                      ),
                    ),

                    // Collection If + Spread Operator.
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: mutedText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onTap,
                tooltip: 'Download',
                icon: const Icon(Icons.download_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.12,
                  ),
                  foregroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
