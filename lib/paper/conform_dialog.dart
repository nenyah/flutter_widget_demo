import 'package:flutter/material.dart';

class ConformDialog extends StatelessWidget {
  final String title;
  final String conformText;
  final String msg;
  final VoidCallback onConform;

  ConformDialog({
    super.key,
    required this.title,
    required this.conformText,
    required this.msg,
    required this.onConform,
  });

  final ButtonStyle conformStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    foregroundColor: Colors.white,
    elevation: 0,
    minimumSize: const Size(70, 35),
    padding: EdgeInsets.zero,
    shape: const StadiumBorder(),
  );

  final ButtonStyle cancelStyle = OutlinedButton.styleFrom(
    minimumSize: const Size(70, 35),
    elevation: 0,
    padding: EdgeInsets.zero,
    shape: const StadiumBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              _buildMessage(),
              _buildButtons(context),
            ]),
      ),
    );
  }

  Row _buildButtons(BuildContext context) => Row(
        children: [
          const Spacer(),
          OutlinedButton(
              onPressed: Navigator.of(context).pop,
              style: cancelStyle,
              child: const Text("取消")),
          const SizedBox(width: 10),
          ElevatedButton(
              onPressed: onConform,
              style: conformStyle,
              child: const Text("确定")),
        ],
      );

  Padding _buildMessage() => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Text(
          msg,
          style: const TextStyle(fontSize: 14),
        ),
      );

  Row _buildTitle() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 30),
          const SizedBox(width: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      );
}
