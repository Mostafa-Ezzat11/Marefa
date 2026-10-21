
import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/features/instructor_cources/custom_widgets/course_action_button.dart';
import 'package:marefa/features/instructor_cources/screens/add_course_basic_info_screen.dart';
import '../models/course_enums.dart';
import '../models/instructor_course_model.dart';
import '../custom_widgets/instructor_course_card.dart';


class InstructorCoursesScreen extends StatefulWidget {
  const InstructorCoursesScreen({super.key});

  @override
  State<InstructorCoursesScreen> createState() =>
      _InstructorCoursesScreenState();
}

class _InstructorCoursesScreenState
    extends State<InstructorCoursesScreen> {
  int selectedTab = 0;
  bool showSearch = false;
  String searchQuery = '';

  final List<InstructorCourseModel> courses = [
    InstructorCourseModel(
      id: '1',
      title: 'Visual Storytelling Essentials',
      category: 'Design',
      level: CourseLevel.beginner,
      description: 'Learn visual storytelling fundamentals.',
      isFree: false,
      price: 49,
      studentsCount: 186,
      status: CourseStatus.published,
      createdAt: DateTime(2026, 10, 10),
      sections: [],
    ),
    InstructorCourseModel(
      id: '2',
      title: 'Designing with Typography',
      category: 'Design',
      level: CourseLevel.intermediate,
      description: 'Explore typography and visual hierarchy.',
      isFree: false,
      price: 39,
      studentsCount: 0,
      status: CourseStatus.draft,
      sections: [],
    ),
    InstructorCourseModel(
      id: '3',
      title: 'Creative Research Methods',
      category: 'Research',
      level: CourseLevel.beginner,
      description: 'Learn practical research methods.',
      isFree: false,
      price: 45,
      studentsCount: 0,
      status: CourseStatus.inReview,
      sections: [],
    ),
  ];

  List<InstructorCourseModel> getFilteredCourses() {
    List<InstructorCourseModel> result = [];

    for (var course in courses) {
      bool matchesTab = false;

      if (selectedTab == 0) {
        matchesTab = true;
      } else if (selectedTab == 1 &&
          course.status == CourseStatus.published) {
        matchesTab = true;
      } else if (selectedTab == 2 &&
          course.status == CourseStatus.draft) {
        matchesTab = true;
      } else if (selectedTab == 3 &&
          course.status == CourseStatus.inReview) {
        matchesTab = true;
      }

      bool matchesSearch = course.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      if (matchesTab && matchesSearch) {
        result.add(course);
      }
    }

    return result;
  }

  int getCoursesCount(int tabIndex) {
    int count = 0;

    for (var course in courses) {
      if (tabIndex == 0) {
        count++;
      } else if (tabIndex == 1 &&
          course.status == CourseStatus.published) {
        count++;
      } else if (tabIndex == 2 &&
          course.status == CourseStatus.draft) {
        count++;
      } else if (tabIndex == 3 &&
          course.status == CourseStatus.inReview) {
        count++;
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    List<InstructorCourseModel> displayedCourses =
        getFilteredCourses();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Make room for your next great idea.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888A7F),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildAddCourseButton(),

                    const SizedBox(height: 16),

                    _buildTabs(),

                    const SizedBox(height: 15),

                    if (displayedCourses.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: displayedCourses.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 11,
                            ),
                            child: InstructorCourseCard(
                              course: displayedCourses[index],
                            ),
                          );
                        },
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 14, 4),
      child: Row(
        children: [
          Expanded(
            child: showSearch
                ? TextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search courses...',
                      border: InputBorder.none,
                    ),
                  )
                : const Text(
                    'Your courses',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF30473A),
                    ),
                  ),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                showSearch = !showSearch;

                if (!showSearch) {
                  searchQuery = '';
                }
              });
            },
            icon: Icon(
              showSearch ? Icons.close : Icons.search,
              color: AppColors.primaryDarkColor,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

 

Widget _buildAddCourseButton() {
  return CourseActionButton(
    text: 'Add new course',
    icon: Icons.add,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const AddCourseBasicInfoScreen();
          },
        ),
      );
    },
  );
}


  Widget _buildTabs() {
    const tabs = [
      'All',
      'Published',
      'Drafts',
      'In review',
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFE6),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          for (int i = 0; i < tabs.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = i;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selectedTab == i
                        ? const Color(0xFFFFFEFA)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${tabs[i]} (${getCoursesCount(i)})',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selectedTab == i
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: selectedTab == i
                          ? AppColors.primaryDarkColor
                          : const Color(0xFF81847A),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 42,
              color: AppColors.primaryColor.withOpacity(0.7),
            ),

            const SizedBox(height: 12),

            const Text(
              'No courses found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDarkColor,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Try another search or category.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF888A7F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
