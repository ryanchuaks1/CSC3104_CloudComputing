import 'package:flutter/material.dart';

import '../common/ui_color_helper.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.index,
    required this.deviceId,
    required this.function,
  }) : super(key: key);

  final int index;
  final String deviceId;
  final void Function() function;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: UIColorHelper.DEFAULT_COLOR,
            child: Text(index.toString()),
          ),
          title: Text(
            deviceId,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          // subtitle: Text(description),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 40,
            ),
            onPressed: function,
          ),
        ),
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
