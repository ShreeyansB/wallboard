import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallboard/controllers/database_controller.dart';
import 'package:wallboard/dev_settings.dart';
import 'package:wallboard/utils/size_config.dart';

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

  void initValues() {
    isEnabled = dbController.dbFavorites.indexWhere((wall) => wall.url == widget.url) != -1;
    data.value = dbController.dbFavorites.indexWhere((wall) => wall.url == widget.url) != -1
        ? kFavoriteIcon
        : kNonFavoriteIcon;
  }

  @override
  void initState() {
    super.initState();
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
    return GetBuilder<DatabaseController>(
        id: "like",
        builder: (controller) {
          initValues();
          return Material(
            type: MaterialType.transparency,
            child: InkWell(
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
                    Future.delayed(
                            Duration(milliseconds: widget.duration ~/ 1.5))
                        .then((value) => allowAnimation = true);
                    Future.delayed(Duration(milliseconds: widget.duration ~/ 6))
                        .then((value) => data.value =
                            isEnabled ? kFavoriteIcon : kNonFavoriteIcon);
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1.2),
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
                                  : Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .color),
                          duration: Duration(milliseconds: widget.duration),
                          child: Obx(() => Text(data.value)),
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }
}

class LikeButtonBG extends StatefulWidget {
  const LikeButtonBG(
      {Key? key, required this.size, required this.duration, required this.url})
      : super(key: key);

  final String url;
  final double size;
  final int duration;

  @override
  _LikeButtonBGState createState() => _LikeButtonBGState();
}

class _LikeButtonBGState extends State<LikeButtonBG>
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
    isEnabled = dbController.dbFavorites.indexWhere((wall) => wall.url == widget.url) != -1;
    data.value = dbController.dbFavorites.indexWhere((wall) => wall.url == widget.url) != -1
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashFactory: context.theme.splashFactory,
        borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockHorizontal * kBorderRadius),
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
                  (value) => data.value =
                      isEnabled ? kFavoriteIcon : kNonFavoriteIcon);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: context.textTheme.headline2!.color,
              borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockHorizontal * kBorderRadius)),
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
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
        ),
      ),
    );
  }
}
