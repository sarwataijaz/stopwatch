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

  bool _isPaused = true;
  bool _isVisible1 = true;
  bool _isVisible2 = true;
  bool _isVisible3 = true;

  List<String> _elapsedTimes = [];

  Timer? _timer_sec;
  Timer? _timer_millisec;
  Timer? _timer_minute;

  StreamController<int> _secondStreamController = StreamController<int>();
  StreamController<int> _millisecondsController = StreamController<int>();
  StreamController<int> _minutesStreamController = StreamController<int>();

  int _fontsize = 31;
  double _padding = 16.0;

  @override
  void initState() {
    super.initState();
    _millisecondsController.sink.add(0);
    _secondStreamController.sink.add(0);
    _minutesStreamController.sink.add(0);
  }

  void _startAddingNumbers(int sec, int millisec, int min) {
    int seconds = sec;
    int milliseconds = millisec;
    int mins = min;

    if (!_isPaused) {
      _timer_millisec = Timer.periodic(Duration(milliseconds: 10), (timer) {
        milliseconds++;

        if (!(milliseconds >= 0 && milliseconds <= 9)) {
          setState(() {
            _isVisible2 = false;
          });
        }
        _millisecondsController.sink.add(milliseconds);

        // Check if milliseconds reach 100 (1 second)
        if (milliseconds == 99) {
          milliseconds = 0; // Reset milliseconds
          seconds++;
          _secondStreamController.sink.add(seconds);
        }

          if (!(seconds >= 0 && seconds <= 9)) {
            setState(() {
              _isVisible1 = false;
              print("called1");
            });
          }

          if(seconds == 59) {
            seconds = 0;
            mins++;
            _minutesStreamController.sink.add(mins);
            _secondStreamController.sink.add(seconds);
            setState(() {
              _isVisible1 = true;
            });
          }

        if (!(mins >= 0 && mins <= 9)) {
          setState(() {
            _isVisible3 = false;
            print("called2");
          });
        }

      });
    }
  }


  void _togglePause(int seconds, int milliseconds, int minutes) {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer_sec?.cancel(); // Cancel the second timer
        _timer_millisec?.cancel();
        _timer_minute?.cancel();// Cancel the millisecond timer
      } else {
        _startAddingNumbers(seconds, milliseconds, minutes); // Restart the timers
      }
    });
  }

  void _toggleReset() {
    setState(() {
      _isPaused = true;
      _timer_millisec?.cancel();
      _timer_sec?.cancel(); // Cancel the second timer
      _timer_minute?.cancel();
      // Reset the streams
      _millisecondsController.sink.add(0);
      _secondStreamController.sink.add(0);
      _minutesStreamController.sink.add(0);
    });
  }

  @override
  void dispose() {
    _secondStreamController.close(); // Close the stream when disposing.
    _millisecondsController.close();
    _minutesStreamController.close();

    _timer_sec?.cancel();
    _timer_millisec?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = 0;
    int milliseconds = 0;
    int min = 0;

    double approx_screenSize = MediaQuery.of(context).size.width * 0.7;

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
            padding: EdgeInsets.only(top: 20.0.sp), // Use logical dp units
            child: Center(
                child: Container(
              width: approx_screenSize, // 70% of screen
              height: approx_screenSize,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFFD1D1), width: 4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: _isVisible3,
                      child: Padding(
                        padding: EdgeInsets.only(left: _padding.sp),
                        child: Text(
                          "0",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: _fontsize.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<int>(
                      stream: _minutesStreamController.stream,
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
                                fontSize: _fontsize.sp,
                              ),
                            ),
                          ); // Display a message when no data is available.
                        } else {
                          min = snapshot.data!;
                          return Padding(
                            padding: EdgeInsets.only(left: 0.sp),
                            child: Text(
                              '${snapshot.data}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: _fontsize.sp,
                                ),
                              ),
                            ),
                          ); // Display the latest number when data is available.
                        }
                      },
                    ),
                    Text(
                      ':',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: _fontsize.sp,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isVisible1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.sp),
                        child: Text(
                          "0",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: _fontsize.sp,
                            ),
                          ),
                        ),
                      ),
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
                                fontSize: _fontsize.sp,
                              ),
                            ),
                          ); // Display a message when no data is available.
                        } else {
                          seconds = snapshot.data!;
                          return Padding(
                            padding: EdgeInsets.only(left: 0.sp),
                            child: Text(
                              '${snapshot.data}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: _fontsize.sp,
                                ),
                              ),
                            ),
                          ); // Display the latest number when data is available.
                        }
                      },
                    ),

                    Text(
                      ':',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: _fontsize.sp,
                        ),
                      ),
                    ),

                    Visibility(
                      visible: _isVisible2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.sp),
                        child: Text(
                          "0",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: _fontsize.sp,
                            ),
                          ),
                        ),
                      ),
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
                                  fontSize: _fontsize.sp,
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
                                  fontSize: _fontsize.sp,
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
          SizedBox(height: 3.h),
          Visibility(
            visible: true,
            child: Padding(
              padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: double.infinity,
                  maxHeight: 16.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFFFFD1D1),
                ),
                child: ListView.builder(
                  itemCount: _elapsedTimes.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _elapsedTimes[index],
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
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
                      setState(() {
                        _resetAll();
                      });
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
                        _togglePause(seconds, milliseconds, min);
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
                    onPressed: () {
                      _addElapse(seconds, milliseconds, min);
                      print("elapse");
                    },
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

  int i = 0;

  void _addElapse(int sec, int millisec, [int? min, int? hour]) {
    i++;
    setState(() {
      _elapsedTimes.add('\t\t$i - \t\t$min:$sec:$millisec');
    });
  }

  void _resetAll() {
    _isVisible1 = true;
    _isVisible2 = true;
    _isVisible3 = true;
    i = 0;
    _padding = 16.0;
    _fontsize = 31;

    _elapsedTimes = [];
  }
}
