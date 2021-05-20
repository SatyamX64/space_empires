import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:some_game/utility/constants.dart';

class EtherScreen extends StatefulWidget {
  static const route = '/ether-screen.dart';
  final Orientation orientation;
  EtherScreen(this.orientation);
  @override
  _EtherScreenState createState() => _EtherScreenState();
}

class _EtherScreenState extends State<EtherScreen> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  double _proceedButtonOpactity = 0.0;

  @override
  void initState() {
    super.initState();
    lockOrientation(orientation: widget.orientation);
    rootBundle.load('assets/animations/stym.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('idle'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  dispose() {
    lockOrientation();
    super.dispose();
  }

  List<String> _dialogueList = const [
    'Oh Hi there, your highness..',
    'Now I am sure none of this makes sense',
    'Will Probably never will',
    'and I am sure you have some doubts',
    'The obvious one being where are we',
    'and who the hell am I ?',
    'So let\'s get a formal Introduction shall we ?',
    'I am STYM, from the space patrol',
    'and at the moment we are in your Dream',
    'So considering YOU are the ruler of one of the 4 Major Races',
    'I have come to inform you that',
    'The Solar System is going to explode',
    '365 days from now',
    'Now I know this is quite shocking..obviously',
    'and you must be confused',
    'But Save that for later, because',
    'I have a Plan'
  ];

  _stym() {
    return _riveArtboard == null
        ? const SizedBox()
        : Rive(
            artboard: _riveArtboard,
          );
  }

  _skipButton() {
    return Positioned(
      child: AnimatedOpacity(
        child: TextButton(
            onPressed: () {},
            child: Text(
              'Skip',
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
            )),
        duration: Duration(seconds: 2),
        opacity: 1 - _proceedButtonOpactity,
      ),
      right: 16.sp,
      bottom: 16.sp,
    );
  }

  _proceedButton() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: GestureDetector(
        onTap: () {},
        child: Container(
            height: 40.sp,
            width: 160.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xFF4B0626),
                borderRadius: BorderRadius.circular(50.sp)),
            child: Text(
              'Proceed',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
      ),
    );
  }

  _dialogue(Orientation orientation) {
    return Container(
      alignment: orientation == Orientation.landscape
          ? Alignment.center
          : Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 72.sp),
      child: AnimatedTextKit(
        animatedTexts: List.generate(
            _dialogueList.length,
            (index) => FadeAnimatedText(_dialogueList[index],
                textStyle: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center)),
        totalRepeatCount: 0,
        isRepeatingAnimation: false,
        pause: const Duration(milliseconds: 1000),
        displayFullTextOnTap: false,
        stopPauseOnTap: false,
        onFinished: () {
          setState(() {
            _proceedButtonOpactity = 1.0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _portrait() {
      return Stack(
        children: [
          Center(
            child: _stym(),
          ),
          _dialogue(Orientation.portrait),
          Align(
            child: AnimatedOpacity(
              child: _proceedButton(),
              duration: Duration(seconds: 2),
              opacity: _proceedButtonOpactity,
            ),
            alignment: Alignment.bottomCenter,
          ),
          _skipButton(),
        ],
      );
    }

    Widget _landscape() {
      return Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: _stym(),
              ),
              Expanded(child: _dialogue(Orientation.landscape)),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: AnimatedOpacity(
                child: _proceedButton(),
                duration: Duration(seconds: 2),
                opacity: _proceedButtonOpactity,
              ),
            ),
          ),
          _skipButton(),
        ],
      );
    }

    return Scaffold(
        backgroundColor: Color(0xFF190620),
        body: widget.orientation == Orientation.landscape
            ? _landscape()
            : _portrait());
  }
}
