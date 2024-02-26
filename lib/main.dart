import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation _animation;
  late Timer timer;
  late TextEditingController textController;
  bool isVisible = false;
  String text = '';
  bool isAnimating = false;
  List<Widget> childrenWrap = [];
  Widget textWidget = const SizedBox.shrink();
  GlobalKey globalKeyText = GlobalKey();
  GlobalKey globalKeyExpanded = GlobalKey();
  late Offset position;
  late Size size;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    position = Offset.zero;
    size = Size.zero;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    // _animationController.forward();

    _animationController.addStatusListener((status) {
      log('$status');
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }

      if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isAnimating) {
        setState(() {
          isVisible = false;
        });
        return;
      }

      setState(() {
        isVisible = !isVisible;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textController,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  isAnimating = true;
                  text = '';
                  var currentIndex = 0;

                  final words = textController.text.split(' ');
                  for (final word in words) {
                    // if (word != words.first) {
                    //   currentIndex += 1;

                    //   setState(() {
                    //     childrenWrap.add(Wrap(
                    //       children: [Text(words[currentIndex - 1])],
                    //     ));
                    //   });
                    // } else {
                    //   Text(text);
                    // }
                    setState(() {
                      childrenWrap.add(Text(text));
                    });

                    for (var i = 0; i < textController.text.length; i++) {
                      await Future<void>.delayed(
                        const Duration(
                          milliseconds: 100,
                        ),
                      );

                      setState(() {
                        text += textController.text[i];
                      });
                    }
                  }

                  isAnimating = false;
                },
                child: const Text('Animar Texto'),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     RenderBox? box = globalKeyText.currentContext
              //         ?.findRenderObject() as RenderBox?;
              //     RenderBox? boxParent = globalKeyExpanded.currentContext
              //         ?.findRenderObject() as RenderBox?;

              //     if (box != null) {
              //       size = box.size;
              //       Offset position = box.localToGlobal(Offset.zero);
              //       this.position = position;
              //       log('position $position');
              //       log('box.size ${box.size}');
              //       final translation =
              //           box.getTransformTo(boxParent).getTranslation();
              //       log('translation ${translation}');
              //       setState(() {
              //         isVisible = true;
              //       });
              //     }
              //   },
              //   child: const Text('Get Position'),
              // ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: childrenWrap,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Expanded(
              //       child: Row(
              //         children: childrenWrap,
              //       ),
              //     ),
              //     Visibility(
              //       visible: isVisible,
              //       maintainSize: true,
              //       maintainAnimation: true,
              //       maintainState: true,
              //       child: Container(
              //         margin: const EdgeInsets.only(bottom: 5),
              //         height: 3,
              //         width: 9,
              //         decoration: const BoxDecoration(color: Colors.black),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
