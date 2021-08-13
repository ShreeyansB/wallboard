import 'package:flutter/material.dart';
import 'package:wallboard/utils/size_config.dart';
import 'package:get/get.dart';

class NoItems extends StatelessWidget {
  const NoItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 21),
      child: Icon(
        Icons.clear_rounded,
        size: SizeConfig.safeBlockHorizontal * 50,
        color: context.textTheme.headline6!.color!.withOpacity(0.05),
      ),
    ));
  }
}
