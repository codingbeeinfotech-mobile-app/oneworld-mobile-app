// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class NumberStepper extends StatelessWidget {
  final double width;
  final totalSteps;
  final int curStep;
  final Color stepCompleteColor;
  final Color currentStepColor;
  final Color inactiveColor;
  final double lineWidth;

  const NumberStepper({
    super.key,
    required this.width,
    required this.curStep,
    required this.stepCompleteColor,
    required this.totalSteps,
    required this.inactiveColor,
    required this.currentStepColor,
    required this.lineWidth,
  }) : assert(curStep >= 0 == true && curStep <= totalSteps + 1);

  @override
  Widget build(BuildContext context) {
    List<Widget> steps() {
      var list = <Widget>[];
      for (int i = 0; i < totalSteps; i++) {
        //colors according to state

        var circleColor = getCircleColor(i);
        var borderColor = getBorderColor(i);
        var lineColor = getLineColor(i);

        // step circles
        list.add(
          Container(
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(
                color: borderColor,
                width: 2.0,
              ),
            ),
            child: getInnerElementOfStepper(i),
          ),
        );
        //line between step circles
        if (i != totalSteps - 1) {
          list.add(
            Expanded(
              child: Container(
                height: lineWidth,
                color: lineColor,
              ),
            ),
          );
        }
      }

      return list;
    }

    return Container(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 14.0,
        right: 14.0,
      ),
      width: width,
      // child: Row(
      //   children: steps(),
      // ),
    );
  }

  Widget getInnerElementOfStepper(index) {
    if (index < curStep) {
      return Icon(
        Icons.circle,
        color: Colors.deepOrange.shade500,
        size: 16.0,
      );
    } else if (index == curStep) {
      return Icon(
        Icons.circle,
        color: Colors.deepOrange.shade500,
        size: 16.0,
      );
    } else {
      return const Icon(
        Icons.circle,
        color: Colors.grey,
        size: 16.0,
      );
    }
  }

  getCircleColor(i) {
    Color color;
    if (i < curStep) {
      color = stepCompleteColor;
    } else if (i == curStep) {
      color = currentStepColor;
    } else {
      color = inactiveColor;
    }
    return color;
  }

  getBorderColor(i) {
    Color color;
    if (i < curStep) {
      color = stepCompleteColor;
    } else if (i == curStep) {
      color = currentStepColor;
    } else {
      color = inactiveColor;
    }

    return color;
  }

  getLineColor(i) {
    var color = curStep > i
        ? Colors.black.withOpacity(0.4)
        : Colors.grey.withOpacity(0.4);
    return color;
  }
}
