import 'package:base_station_simulation/gui/rgbo_color.dart';
import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  bool state;
  Function function;
  CustomToggle({required this.state, required this.function});
  //const CustomToggle({ Key? key }) : super(key: key);

  @override
  _CustomToggleState createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    var dimension = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        // setState(() {
        //   widget.state = !widget.state;
        // });
        widget.function();
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Container(
          child: Stack(
            children: [
              Container(
                height: dimension.width * 0.05,
                width: dimension.width * 0.1,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(dimension.width * 0.025),
                    color: widget.state
                        ? RgboColors.lifetaliaPrimary()
                        : RgboColors.offToggleColor()),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: dimension.width * 0.005,
                    left: widget.state
                        ? dimension.width * 0.05
                        : dimension.width * 0.01,
                    bottom: dimension.width * 0.005),
                width: dimension.width * 0.04,
                height: dimension.width * 0.04,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
