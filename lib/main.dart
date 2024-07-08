import 'package:flutter/material.dart';
import 'dart:async';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final whiteMaterialColor = MaterialColor(
    0xFFFFFFFF, // Primary color value
    <int, Color>{
      50: Color(0xFFFFFFFF), // Shades of white
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  // Create a custom MaterialColo

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Responsive Sizer Example',
          theme: ThemeData(
            primarySwatch: whiteMaterialColor,
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
  bool _isPaused = false;
  bool one_nine = true;

  Timer? timer_sec;
  Timer? timer_millisec;

  StreamController<int> _secondStreamController = StreamController<int>();
  StreamController<int> _millisecondsController = StreamController<int>();

  int fontsize = 32;

  @override
  void initState() {
    super.initState();
    _millisecondsController.sink.add(0);
    _secondStreamController.sink.add(0);
  }

  void _startAddingNumbers(int sec, int millisec) {
    int seconds = sec;
    int milliseconds = millisec;

    if (!_isPaused) {
      timer_millisec = Timer.periodic(Duration(milliseconds: 1), (timer) {
        milliseconds++;

          _millisecondsController.sink.add(milliseconds);


        // Check if milliseconds reach 100 (1 second)
        if (milliseconds == 100) {
          milliseconds = 0; // Reset milliseconds
          seconds++;

          _secondStreamController.sink.add(seconds); // Update seconds stream
        }
      });
    }
  }

  void _togglePause(int seconds, int milliseconds) {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        timer_sec?.cancel(); // Cancel the second timer
        timer_millisec?.cancel(); // Cancel the millisecond timer
      } else {
        _startAddingNumbers(seconds, milliseconds); // Restart the timers
      }
    });
  }

  void _toggleReset() {
    setState(() {
      _isPaused = true;
      timer_millisec?.cancel();
      timer_sec?.cancel(); // Cancel the second timer

      // Reset the streams
      _millisecondsController.sink.add(00);
      _secondStreamController.sink.add(0);
    });
  }

  @override
  void dispose() {
    _secondStreamController.close(); // Close the stream when disposing.
    _millisecondsController.close();

    timer_sec?.cancel();
    timer_millisec?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = 0;
    int milliseconds = 0;

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
          Padding(
            padding: EdgeInsets.only(top: 30.0.sp), // Use logical dp units
            child: Center(
                child: Container(
              width: MediaQuery.of(context).size.width *
                  0.7, // 20% of screen width
              height: MediaQuery.of(context).size.width *
                  0.7, // Aspect ratio preserved
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFFD1D1), width: 4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if (one_nine)
                    //   Padding(
                    //     padding: EdgeInsets.only(left:10.sp),
                    //     child: Text(
                    //       "0",
                    //       style: GoogleFonts.poppins(
                    //         textStyle: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 32.sp,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    SizedBox(
                      width: 10.w,
                    ),
                    StreamBuilder<int>(
                      stream: _secondStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Display a loading indicator when waiting for data.
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Display an error message if an error occurs.
                        } else if (!snapshot.hasData) {
                          return Text(
                            '00',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 32.sp,
                              ),
                            ),
                          ); // Display a message when no data is available.
                        } else {
                          seconds = snapshot.data!;
                          return Text(
                            '${snapshot.data}',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 32.sp,
                              ),
                            ),
                          ); // Display the latest number when data is available.
                        }
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      ':',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    StreamBuilder<int>(
                      stream: _millisecondsController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Display a loading indicator when waiting for data.
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Display an error message if an error occurs.
                        } else if (!snapshot.hasData) {
                          return Expanded(
                            child: Text(
                              '00',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                ),
                              ),
                            ),
                          ); // Display a message when no data is available.
                        } else {
                          milliseconds = snapshot.data!;
                          return Expanded(
                            child: Text(
                              '${snapshot.data}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                ),
                              ),
                            ),
                          ); // Display the latest number when data is available.
                        }
                      },
                    ),
                  ],
                ),
              ),
            )),
          ),
          SizedBox(
            height: 50.sp,
          ),
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
                    onPressed: () {
                      _toggleReset();
                      print("repeat");
                    },
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
                      onPressed: () {
                        _togglePause(seconds, milliseconds);
                        print("stop");
                      },
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
