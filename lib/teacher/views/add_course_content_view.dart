import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/teacher/views/pricing_and_review_view.dart';
import '../widgets/course_action_button.dart';
import '../widgets/save_draft_button.dart';
import '../widgets/course_step_indicator.dart';

enum LessonContentType { video, document }

class AddCourseContentview extends StatefulWidget {
  const AddCourseContentview({super.key});

  @override
  State<AddCourseContentview> createState() =>
      _AddCourseContentviewstate();
}

class _AddCourseContentviewstate extends State<AddCourseContentview> {
  final formKey = GlobalKey<FormState>();

  final List<SectionInput> sections = [];

  @override
  void initState() {
    super.initState();

    // Add the first section
    sections.add(SectionInput());
  }

  @override
  void dispose() {
    for (final section in sections) {
      section.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      // App bar
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.largeTextColor,
        ),
        title: const Text(
          'Course content',
          style: TextStyle(
            color: AppColors.largeTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // view content
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Step indicator
                const CourseStepIndicator(currentStep: 1),
                const SizedBox(height: 24),

                // view title
                const Text(
                  'Build your course',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.largeTextColor,
                  ),
                ),
                const SizedBox(height: 6),

                const Text(
                  'Organize your course into sections and lessons.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF85877D),
                  ),
                ),
                const SizedBox(height: 22),

                // Course sections
                for (int i = 0; i < sections.length; i++)
                  _buildSectionCard(i),

                // Add section button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: addSection,
                    icon: const Icon(Icons.add),
                    label: const Text('Add new section'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDarkColor,
                      side: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Next button
                CourseActionButton(
                  text: 'Next',
                  onPressed: goToNextStep,
                  icon: Icons.arrow_forward,
                ),
                const SizedBox(height: 8),

                // Save draft button
                SaveDraftButton(onPressed: saveDraft),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Section ----------

  Widget _buildSectionCard(int sectionIndex) {
    final section = sections[sectionIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Section ${sectionIndex + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarkColor,
                  ),
                ),
              ),

              // Remove section
              if (sections.length > 1)
                IconButton(
                  onPressed: () => removeSection(sectionIndex),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  tooltip: 'Remove section',
                ),
            ],
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: section.titleController,
            decoration: _inputDecoration(hint: 'Section name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a section name';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          const Text(
            'Lessons',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.largeTextColor,
            ),
          ),
          const SizedBox(height: 10),

          // Section lessons
          for (int i = 0; i < section.lessons.length; i++)
            _buildLessonCard(sectionIndex, i),

          // Add lesson button
          TextButton.icon(
            onPressed: () => addLesson(sectionIndex),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add lesson'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Lesson ----------

  Widget _buildLessonCard(int sectionIndex, int lessonIndex) {
    final lesson = sections[sectionIndex].lessons[lessonIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lesson ${lessonIndex + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkColor,
                  ),
                ),
              ),

              // Remove lesson
              IconButton(
                onPressed: () {
                  removeLesson(sectionIndex, lessonIndex);
                },
                icon: const Icon(Icons.close, size: 18),
                color: Colors.redAccent,
                tooltip: 'Remove lesson',
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          // Lesson title
          TextFormField(
            controller: lesson.titleController,
            decoration: _inputDecoration(hint: 'Lesson title'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a lesson title';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          const Text(
            'Content type',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.largeTextColor,
            ),
          ),
          const SizedBox(height: 6),

          // Video and document options
          Row(
            children: [
              Expanded(
                child: _buildContentTypeButton(
                  lesson: lesson,
                  type: LessonContentType.video,
                  label: 'Video',
                  icon: Icons.play_circle_outline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildContentTypeButton(
                  lesson: lesson,
                  type: LessonContentType.document,
                  label: 'Document',
                  icon: Icons.description_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content URL
          TextFormField(
            controller: lesson.urlController,
            decoration: _inputDecoration(
              hint: lesson.contentType == LessonContentType.video
                  ? 'Video URL (optional)'
                  : 'Document URL (optional)',
              icon: Icons.link,
            ),
          ),
          const SizedBox(height: 8),

          // Choose file button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      lesson.contentType == LessonContentType.video
                          ? 'Video selection will be added later'
                          : 'Document selection will be added later',
                    ),
                  ),
                );
              },
              icon: Icon(
                lesson.contentType == LessonContentType.video
                    ? Icons.video_library_outlined
                    : Icons.upload_file_outlined,
                size: 18,
              ),
              label: Text(
                lesson.fileName ??
                    (lesson.contentType == LessonContentType.video
                        ? 'Choose video'
                        : 'Choose document'),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDarkColor,
                side: const BorderSide(color: AppColors.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Content type button ----------

  Widget _buildContentTypeButton({
    required LessonInput lesson,
    required LessonContentType type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = lesson.contentType == type;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          lesson.contentType = type;
          lesson.fileName = null;
          lesson.urlController.clear();
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color(0xFFE0F0E7)
            : const Color(0xFFFFFEFA),
        foregroundColor: AppColors.primaryDarkColor,
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryColor
              : AppColors.borderColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ---------- Input decoration ----------

  InputDecoration _inputDecoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF9A9B92),
      ),
      prefixIcon: icon == null
          ? null
          : Icon(icon, size: 18, color: AppColors.primaryColor),
      filled: true,
      fillColor: const Color(0xFFFFFEFA),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
    );
  }

  // ---------- Actions ----------

  void addSection() {
    setState(() {
      sections.add(SectionInput());
    });
  }

  void removeSection(int sectionIndex) {
    setState(() {
      final section = sections.removeAt(sectionIndex);
      section.dispose();
    });
  }

  void addLesson(int sectionIndex) {
    setState(() {
      sections[sectionIndex].lessons.add(LessonInput());
    });
  }

  void removeLesson(int sectionIndex, int lessonIndex) {
    setState(() {
      final lesson = sections[sectionIndex].lessons.removeAt(
        lessonIndex,
      );

      lesson.dispose();
    });
  }

  void goToNextStep() {
    if (sections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one section'),
        ),
      );
      return;
    }

    for (final section in sections) {
      if (section.lessons.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please add at least one lesson to each section',
            ),
          ),
        );
        return;
      }
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PricingReviewview(),
      ),
    );
  }

  void saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saving will be added later'),
      ),
    );
  }
}

// ---------- Section input ----------

class SectionInput {
  final TextEditingController titleController =
      TextEditingController();

  final List<LessonInput> lessons = [];

  void dispose() {
    titleController.dispose();

    for (final lesson in lessons) {
      lesson.dispose();
    }
  }
}

// ---------- Lesson input ----------

class LessonInput {
  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController urlController = TextEditingController();

  LessonContentType contentType = LessonContentType.video;

  String? fileName;

  void dispose() {
    titleController.dispose();
    urlController.dispose();
  }
}
