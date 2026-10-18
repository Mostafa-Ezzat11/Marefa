
import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/features/instructor_cources/custom_widgets/course_step_indicator.dart';
import '../models/course_enums.dart';
import '../custom_widgets/course_action_button.dart';
import '../custom_widgets/save_draft_button.dart';
import 'add_course_content_screen.dart';
 
class AddCourseBasicInfoScreen extends StatefulWidget {
  const AddCourseBasicInfoScreen({super.key});
 
  @override
  State<AddCourseBasicInfoScreen> createState() =>
      _AddCourseBasicInfoScreenState();
}
 
class _AddCourseBasicInfoScreenState extends State<AddCourseBasicInfoScreen> {
  final formKey = GlobalKey<FormState>();
 
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final learningController = TextEditingController();
 
  final List<String> categories = [
    'Programming',
    'Design',
    'Business',
    'Languages',
    'Science',
    'Other',
  ];
 
  String? selectedCategory;
  CourseLevel? selectedLevel;
 
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    learningController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.largeTextColor,
        ),
        title: const Text(
          'Add Course',
          style: TextStyle(
            color: AppColors.largeTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourseStepIndicator(currentStep: 0),
                const SizedBox(height: 20),
                const Text(
                  'Basic information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.largeTextColor,
                  ),
                ),
                const SizedBox(height: 16),
 
                // Course cover
                _buildLabel('Course cover'),
                const SizedBox(height: 8),
                _buildCoverPicker(),
                const SizedBox(height: 16),
 
                // Course title
                _buildLabel('Course title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: titleController,
                  decoration: _inputDecoration(hint: 'e.g. Flutter Development'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the course title';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
 
                // Category + Level side by side
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCategoryField()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildLevelField()),
                  ],
                ),
                const SizedBox(height: 16),
 
                // Description
                _buildLabel('Course description'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  minLines: 4,
                  maxLines: 4,
                  decoration: _inputDecoration(
                    hint: 'Describe what your course is about',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a course description';
                    }
                    if (value.trim().length < 20) {
                      return 'Description must be at least 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
 
               Column(
                  children: [
                    CourseActionButton(
                      text: 'Next',
                      onPressed: goToNextScreen,
                      icon: Icons.arrow_forward,
                    ),
                    const SizedBox(width: 12),
                    SaveDraftButton(onPressed: saveDraft),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  // ---------- Widgets ----------
 
  
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.largeTextColor,
      ),
    );
  }
 
  Widget _buildCoverPicker() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: const Color(0xFFD9E3D6),
              child: const Icon(
                Icons.image_outlined,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image selection will be connected later'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 16,
                          color: AppColors.largeTextColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Change cover',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.largeTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Category'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: _inputDecoration(hint: 'Select'),
          items: categories
              .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
              .toList(),
          onChanged: (value) => setState(() => selectedCategory = value),
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
    );
  }
 
  Widget _buildLevelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Level'),
        const SizedBox(height: 8),
        DropdownButtonFormField<CourseLevel>(
          value: selectedLevel,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: _inputDecoration(hint: 'Select'),
          items: CourseLevel.values
              .map((l) => DropdownMenuItem<CourseLevel>(
                    value: l,
                    child: Text(_getLevelName(l)),
                  ))
              .toList(),
          onChanged: (value) => setState(() => selectedLevel = value),
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
    );
  }
 
  String _getLevelName(CourseLevel level) {
    switch (level) {
      case CourseLevel.beginner:
        return 'Beginner';
      case CourseLevel.intermediate:
        return 'Intermediate';
      case CourseLevel.advanced:
        return 'Advanced';
    }
  }
 
  InputDecoration _inputDecoration({required String hint}) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }
 
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9A9B92)),
      filled: true,
      fillColor: const Color(0xFFFFFEFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: border(AppColors.borderColor),
      enabledBorder: border(AppColors.borderColor),
      focusedBorder: border(AppColors.primaryColor, 1.5),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }
 
  // ---------- Actions ----------
 
  void goToNextScreen() {
    if (!formKey.currentState!.validate()) return;
 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCourseContentScreen(),
      ),
    );
  }
 
  void saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saving will be added later')),
    );
  }
}
 

