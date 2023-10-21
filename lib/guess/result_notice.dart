import 'package:flutter/material.dart';

class ResultNotice extends StatefulWidget {
  final String info;
  final Color color;
  const ResultNotice({super.key, required this.info, required this.color});

  @override
  State<ResultNotice> createState() => _ResultNoticeState();
}

class _ResultNoticeState extends State<ResultNotice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ResultNotice oldWidget) {
    _controller.forward(from: 0);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      color: widget.color,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) => Text(
                widget.info,
                style: TextStyle(
                    fontSize: 54 * (_controller.value),
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
    ));
  }
}
