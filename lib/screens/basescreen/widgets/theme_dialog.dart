import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wall/controllers/database_controller.dart';
import 'package:wall/dev_settings.dart';
import 'package:wall/utils/size_config.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  _ThemeDialogState createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  ThemeMode? _value;

  @override
  void initState() {
    super.initState();
    _value = Get.find<DatabaseController>().getThemeType();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select theme", style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: context.theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockHorizontal * kBorderRadius)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            title: Text("Light"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    SizeConfig.safeBlockHorizontal * kBorderRadius)),
            value: ThemeMode.light,
            activeColor: context.theme.accentColor,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text("Dark"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    SizeConfig.safeBlockHorizontal * kBorderRadius)),
            activeColor: context.theme.accentColor,
            value: ThemeMode.dark,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text("Auto"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    SizeConfig.safeBlockHorizontal * kBorderRadius)),
            activeColor: context.theme.accentColor,
            value: ThemeMode.system,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back(result: null);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: context.theme.accentColor),
            )),
        TextButton(
          onPressed: () {
            Get.back(result: _value);
          },
          child: Text(
            "Select",
            style: TextStyle(color: context.theme.accentColor),
          ),
        ),
      ],
    );
  }
}
