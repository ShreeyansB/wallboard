import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key, required this.size, required this.duration})
      : super(key: key);

  final double size;
  final int duration;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  bool allowAnimation = true;
  bool isEnabled = false;
  String unliked = "\uEE0F";
  String liked = "\uEE0E";

  late RxString data = "".obs;

  late Animation<double> _sizeAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    data.value = unliked;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
      reverseDuration: Duration(milliseconds: widget.duration),
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 1.3), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.3, end: 1), weight: 50)
    ]).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
        reverseCurve: Curves.easeInQuart));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        if (allowAnimation) {
          print("trig");
          allowAnimation = false;
          setState(() {
            isEnabled = !isEnabled;
            isEnabled ? _controller.forward() : _controller.reverse();
            Future.delayed(Duration(milliseconds: widget.duration ~/ 1.5))
                .then((value) => allowAnimation = true);
            Future.delayed(Duration(milliseconds: widget.duration ~/ 6))
                .then((value) => data.value = isEnabled ? liked : unliked);
          });
        }
      },
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Transform.scale(
              alignment: Alignment.center,
              scale: _sizeAnimation.value,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                    fontFamily: "RemixIcons",
                    fontSize: widget.size,
                    color: isEnabled ? Colors.red : Colors.white),
                duration: Duration(milliseconds: widget.duration),
                child: Obx(() => Text(data.value)),
              ),
            );
          }),
    );
  }
}
