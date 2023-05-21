import 'package:animated_menu/animated_menu.dart';
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
        primarySwatch: Colors.blue,
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
  double verticalDragVal = 0;
  double _opacity = 0;
  static const double buttonSize = 70;
  static const Color mainColor = Colors.red;
  List<Widget> items = List.generate(
    4,
    (index) => const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        'Reminder',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),
  );

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _closeAnimationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);

    _closeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {
          _opacity = _closeAnimationController.value;
          verticalDragVal = 130 - 130 * (1 - _closeAnimationController.value);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => ClipPath(
              clipper: MenuClipper(
                verticalDragVal,
                _animation.value,
                buttonSize,
              ),
              child: child,
            ),
            child: Opacity(
              opacity: _opacity,
              child: Container(
                width: double.infinity,
                color: mainColor,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _animationController.value == 0 ? 0 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...items,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20 +
                verticalDragVal +
                (_animationController.value * (items.length * 30)),
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  var verticalDrag = details.localPosition.dy;
                  if (verticalDrag < 0 && verticalDrag > -130) {
                    verticalDragVal = -verticalDrag;
                    _opacity =
                        0.01 * verticalDragVal < 1 ? 0.01 * verticalDragVal : 1;
                  } else if (verticalDrag < -130 &&
                      !_animationController.isAnimating) {
                    verticalDragVal = 130;
                    _animationController.forward();
                  }
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  if (verticalDragVal < 120) {
                    verticalDragVal = 0;
                    _opacity = 0;
                  }
                });
              },
              onTap: () {
                if (_animationController.value == 1) {
                  _animationController.reset();
                  _closeAnimationController.reverse(from: 1);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: buttonSize,
                height: buttonSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _animationController.value == 0
                      ? mainColor
                      : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: AnimatedIcon(
                  color: _animationController.value == 0
                      ? Colors.white
                      : mainColor,
                  progress: _animation,
                  icon: _animationController.value == 0
                      ? AnimatedIcons.add_event
                      : AnimatedIcons.menu_close,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
