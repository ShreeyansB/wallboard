import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/dev_settings.dart';

class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key, required this.size, required this.duration, required this.url})
      : super(key: key);

  final String url;
  final double size;
  final int duration;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  bool allowAnimation = true;
  late bool isEnabled;

  late RxString data = "".obs;

  late Animation<double> _sizeAnimation;
  late AnimationController _controller;
  var dbController = Get.find<DatabaseController>();

  @override
  void initState() {
    super.initState();
    isEnabled = dbController.favorites.contains(widget.url);
    data.value = dbController.favorites.contains(widget.url)
        ? kFavoriteIcon
        : kNonFavoriteIcon;

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
      splashFactory: context.theme.splashFactory,
      borderRadius: BorderRadius.circular(100),
      onTap: () {
        if (allowAnimation) {
          allowAnimation = false;
          setState(() {
            isEnabled = !isEnabled;
            isEnabled
                ? dbController.addFavorite(widget.url)
                : dbController.removeFavorite(widget.url);
            isEnabled ? _controller.forward() : _controller.reverse();
            Future.delayed(Duration(milliseconds: widget.duration ~/ 1.5))
                .then((value) => allowAnimation = true);
            Future.delayed(Duration(milliseconds: widget.duration ~/ 6)).then(
                (value) =>
                    data.value = isEnabled ? kFavoriteIcon : kNonFavoriteIcon);
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
                    color: isEnabled
                        ? kLikeButtonColor
                        : Theme.of(context).textTheme.headline6!.color),
                duration: Duration(milliseconds: widget.duration),
                child: Obx(() => Text(data.value)),
              ),
            );
          }),
    );
  }
}
