import 'package:flutter/material.dart';

class ChannelWidget extends StatefulWidget {
  final bool status;
  const ChannelWidget({super.key, this.status = false});

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  late bool state;
  @override
  void initState() {
    state = widget.status;
    super.initState();
  }

  void changeState() {
    setState(() {
      state = !state;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.status ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(2)),
    );
  }
}
