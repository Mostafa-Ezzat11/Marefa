import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marefa/student/models/course.dart';
import 'package:marefa/student/models/course_file_model.dart';
import 'package:marefa/student/models/lesson_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Course>> fetchCourses() async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .where('isPublished', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // Fetch lessons and files for a specific course.
  Future<({List<LessonModel> lessons, List<CourseFileModel> files})>
  fetchCourseContent(String courseId) async {
    try {
      // Fetch lessons from the course subcollection.
      final lessonsSnapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('lessons')
          .get();

      final lessons = lessonsSnapshot.docs.map((doc) {
        final data = doc.data();

        return LessonModel(
          id: (data['id'] as num?)?.toInt() ?? int.tryParse(doc.id) ?? 0,
          title: data['title'] ?? '',
          duration: data['duration'] ?? '',
        );
      }).toList();

      // Fetch files from the course_files collection.
      final filesSnapshot = await _firestore
          .collection('course_files')
          .where('courseId', isEqualTo: courseId)
          .get();

      final files = filesSnapshot.docs.map((doc) {
        final data = doc.data();

        return CourseFileModel(
          name: data['name'] ?? '',
          type: _getFileType(data['type']),
          sizeInKb: (data['sizeInKb'] as num?)?.toInt() ?? 0,
          section: data['section'],
        );
      }).toList();

      return (lessons: lessons, files: files);
    } catch (e) {
      throw Exception('Failed to fetch course content: $e');
    }
  }

  CourseFileType _getFileType(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf':
        return CourseFileType.pdf;
      case 'zip':
        return CourseFileType.zip;
      case 'doc':
      case 'docx':
        return CourseFileType.doc;
      default:
        return CourseFileType.pdf;
    }
  }
}
// Future<void> uploadSampleCourses() async {
//   final batch = firestore.batch();
//
//   final courses = [
//     {
//       'id': 'web_development',
//       'title': 'Web Development Complete Guide',
//       'description': 'Learn HTML, CSS and JavaScript.',
//       'price': 49.99,
//       'imageUrl': 'assets/images/course_visual_storytelling.png',
//       'categoryId': 'programming',
//       'instructorId': '',
//       'instructorName': 'Youssif Shawky',
//       'instructorTitle': 'Web Developer',
//       'instructorImage': 'assets/images/payment_successfuly.png',
//       'rating': 4.8,
//       'reviewCount': 120,
//       'level': 'Beginner',
//       'durationHours': 10,
//       'sectionCount': 3,
//       'isPublished': true,
//
//       'lessons': [
//         {'id': 1, 'title': 'HTML Basics', 'duration': '10 min'},
//         {'id': 2, 'title': 'CSS Fundamentals', 'duration': '15 min'},
//         {'id': 3, 'title': 'JavaScript Introduction', 'duration': '20 min'},
//         {'id': 4, 'title': 'Responsive Web Design', 'duration': '18 min'},
//       ],
//
//       'files': [
//         {
//           'id': 'web_file_1',
//           'name': 'HTML and CSS Complete Guide',
//           'type': 'pdf',
//           'sizeInKb': 2458,
//           'section': 'Section 1 · HTML & CSS',
//         },
//         {
//           'id': 'web_file_2',
//           'name': 'Web Development Starter Project',
//           'type': 'zip',
//           'sizeInKb': 8602,
//           'section': 'Section 2 · Practical Projects',
//         },
//         {
//           'id': 'web_file_3',
//           'name': 'JavaScript Exercises',
//           'type': 'doc',
//           'sizeInKb': 1229,
//           'section': 'Section 3 · JavaScript',
//         },
//       ],
//     },
//
//     {
//       'id': 'flutter_development',
//       'title': 'Flutter Development Complete Guide',
//       'description':
//           'Learn Flutter from scratch and build real-world apps with modern techniques.',
//       'price': 49.99,
//       'imageUrl': 'assets/images/course_visual_storytelling.png',
//       'categoryId': 'programming',
//       'instructorId': '',
//       'instructorName': 'Youssif Shawky',
//       'instructorTitle': 'Senior Flutter Developer',
//       'instructorImage': 'assets/images/payment_successfuly.png',
//       'rating': 4.8,
//       'reviewCount': 12000,
//       'level': 'Expert',
//       'durationHours': 1,
//       'sectionCount': 4,
//       'isPublished': true,
//
//       'lessons': [],
//
//       'files': [
//         {
//           'id': 'flutter_file_1',
//           'name': 'Flutter Complete Guide',
//           'type': 'pdf',
//           'sizeInKb': 2458,
//           'section': 'Section 1 · Introduction',
//         },
//         {
//           'id': 'flutter_file_2',
//           'name': 'Flutter Starter Project',
//           'type': 'zip',
//           'sizeInKb': 8602,
//           'section': 'Section 2 · Setup',
//         },
//         {
//           'id': 'flutter_file_3',
//           'name': 'Flutter Practice Exercises',
//           'type': 'doc',
//           'sizeInKb': 1229,
//           'section': 'Section 3 · Widgets',
//         },
//       ],
//     },
//
//     {
//       'id': 'flutter_ui_ux',
//       'title': 'Flutter UI/UX Design',
//       'description': 'Learn UI design and Flutter layouts.',
//       'price': 39.99,
//       'imageUrl': 'assets/images/course_visual_storytelling.png',
//       'categoryId': 'design',
//       'instructorId': '',
//       'instructorName': 'Youssif Shawky',
//       'instructorTitle': 'Flutter Developer',
//       'instructorImage': 'assets/images/payment_successfuly.png',
//       'rating': 4.7,
//       'reviewCount': 250,
//       'level': 'Intermediate',
//       'durationHours': 8,
//       'sectionCount': 3,
//       'isPublished': true,
//
//       'lessons': [
//         {'id': 1, 'title': 'UI Design Basics', 'duration': '8 min'},
//         {'id': 2, 'title': 'Flutter Layouts', 'duration': '12 min'},
//         {'id': 3, 'title': 'Styling Widgets', 'duration': '15 min'},
//       ],
//
//       'files': [
//         {
//           'id': 'ui_file_1',
//           'name': 'UI Design Principles',
//           'type': 'pdf',
//           'sizeInKb': 1800,
//           'section': 'Section 1 · Design Basics',
//         },
//         {
//           'id': 'ui_file_2',
//           'name': 'Flutter UI Components',
//           'type': 'zip',
//           'sizeInKb': 5200,
//           'section': 'Section 2 · Components',
//         },
//         {
//           'id': 'ui_file_3',
//           'name': 'Design Practice Tasks',
//           'type': 'doc',
//           'sizeInKb': 950,
//           'section': 'Section 3 · Practice',
//         },
//       ],
//     },
//   ];
//
//   for (final course in courses) {
//     final courseId = course['id'] as String;
//
//     // Upload course document
//     final courseRef = _firestore.collection('courses').doc(courseId);
//
//     final courseData = Map<String, dynamic>.from(course)
//       ..remove('id')
//       ..remove('lessons')
//       ..remove('files');
//
//     batch.set(courseRef, courseData);
//
//     // Upload lessons
//     final lessons = course['lessons'] as List;
//
//     for (final lesson in lessons) {
//       final lessonData = Map<String, dynamic>.from(lesson);
//
//       final lessonId = lessonData['id'].toString();
//
//       final lessonRef = courseRef.collection('lessons').doc(lessonId);
//
//       batch.set(lessonRef, lessonData);
//     }
//
//     // Upload course files
//     final files = course['files'] as List;
//
//     for (final file in files) {
//       final fileData = Map<String, dynamic>.from(file);
//
//       final fileId = fileData.remove('id') as String;
//
//       fileData['courseId'] = courseId;
//
//       final fileRef = _firestore.collection('course_files').doc(fileId);
//
//       batch.set(fileRef, fileData);
//     }
//   }
//
//   await batch.commit();
// }
