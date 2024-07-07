import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Responsive Sizer Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: "StopWatch"),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white), // Set text color
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.format_line_spacing_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Add your onPressed code here!
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top:20.0.sp,left: 10.0.sp, right: 10.0.sp, ),
              child: Container(
                  width: 75.w,
                  height: 75.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                    shape: BoxShape.circle,
                  )),
            ),
          ),
          SizedBox(height: 10.0.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15.w,
                  height: 15.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF9E3E3),
                      shape: const CircleBorder(), // Make the button circular
                      padding: EdgeInsets.zero, // Ensure no extra padding
                    ),
                    child: const Icon(Icons.repeat, color: Colors.black),
                  ),
                ),
                SizedBox(width: 5.w), // Add some spacing between buttons
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 37.w,
                      maxHeight: 60.h,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        minimumSize: Size(120, 5), // Ensure no extra padding
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 10.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w), // Add some spacing between buttons
                Container(
                  width: 15.w,
                  height: 15.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF9E3E3),
                      shape: const CircleBorder(), // Make the button circular
                      padding: EdgeInsets.zero, // Ensure no extra padding
                    ),
                    child: const Icon(Icons.save_alt, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
