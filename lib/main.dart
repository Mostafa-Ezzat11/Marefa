import 'package:flutter/material.dart';
import 'package:marefa/student/views/main_shell_view.dart';

void main() {
  runApp(Marefa());
}

class Marefa extends StatelessWidget {
  const Marefa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(fontFamily: 'OpenSans'),
      home: MainShell(), //Scaffold(
      //   body: PaymentSuccessfulView(),
      //   // body: Center(
      //   //   child: Text(
      //   //     'Welcome my team ✌️',
      //   //     style: TextStyle(fontSize: 25),
      //   //   ),
      //   // ),
      // ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// // ---------- Colors ----------
// const kBg = Color(0xFFFDFBF5);
// const kGreen = Color(0xFF2E7D5B);
// const kGreenLight = Color(0xFFD9EADF);
// const kOrange = Color(0xFFF0892F);
// const kTrack = Color(0xFFE3DCCB);
// const kBorder = Color(0xFFE8E2D0);
// const kText = Color(0xFF1B2B22);

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: kBg,
//         useMaterial3: true,
//       ),
//       home: const MyCoursesPage(),
//     );
//   }
// }

// // ---------- Model ----------
// class Course {
//   final String title;
//   final int progress; // 0..100
//   final List<Color> color;
//   final Color barColor;

//   const Course(
//     this.title,
//     this.progress,
//     this.color,
//     this.barColor,
//   );
// }

// const courses = [
//   Course('Flutter Development', 45, [
//     Color(0xFF3F9F78),
//     Color(0xFF1F6B4A),
//   ], kOrange),
//   Course('Python for Beginners', 20, [
//     Color(0xFFF59A3C),
//     Color(0xFFD9680F),
//   ], kOrange),
//   Course('UI/UX Design', 0, [
//     Color(0xFF9CCBB2),
//     Color(0xFF3F9F78),
//   ], kOrange),
// ];

// // ---------- Page ----------
// class MyCoursesPage extends StatefulWidget {
//   const MyCoursesPage({super.key});

//   @override
//   State<MyCoursesPage> createState() => _MyCoursesPageState();
// }

// class _MyCoursesPageState extends State<MyCoursesPage> {
//   int tab = 0; // 0 = Enrolled, 1 = Completed
//   int navIndex = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               const Text(
//                 'My Courses',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                   color: kText,
//                 ),
//               ),
//               const SizedBox(height: 14),
//               Row(
//                 children: [
//                   _TabChip(
//                     label: 'Enrolled (3)',
//                     selected: tab == 0,
//                     onTap: () => setState(() => tab = 0),
//                   ),
//                   const SizedBox(width: 8),
//                   _TabChip(
//                     label: 'Completed (1)',
//                     selected: tab == 1,
//                     onTap: () => setState(() => tab = 1),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.separated(
//                   itemCount: courses.length,
//                   separatorBuilder: (_, __) =>
//                       const SizedBox(height: 16),
//                   itemBuilder: (_, i) =>
//                       CourseItem(course: courses[i]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _BottomNav(
//         index: navIndex,
//         onChanged: (i) => setState(() => navIndex = i),
//       ),
//     );
//   }
// }

// // ---------- Tab chip ----------
// class _TabChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _TabChip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 14,
//           vertical: 7,
//         ),
//         decoration: BoxDecoration(
//           color: selected ? kGreen : kGreenLight,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: selected ? Colors.white : kGreen,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ---------- Course card + progress bar ----------
// class CourseItem extends StatelessWidget {
//   final Course course;
//   const CourseItem({super.key, required this.course});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: kBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: kBorder),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: LinearColor(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: course.color,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       course.title,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: kText,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Progress: ${course.progress}%',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: kText.withOpacity(0.6),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: course.progress / 100,
//             minHeight: 5,
//             backgroundColor: kTrack,
//             valueColor: AlwaysStoppedAnimation(course.barColor),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ---------- Bottom navigation ----------
