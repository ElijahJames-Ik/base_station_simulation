import 'package:flutter/material.dart';

class ChannelWidget extends StatefulWidget {
  final bool status;
  final String text;
  const ChannelWidget({super.key, this.status = false, required this.text});

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  late bool state;
  late String size;
  @override
  void initState() {
    state = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: widget.status ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(2)),
      child: Text(
        widget.text,
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
