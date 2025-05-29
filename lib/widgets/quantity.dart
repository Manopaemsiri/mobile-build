import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class Quantity extends StatefulWidget {
  const Quantity({
    super.key,
    required this.onChange,
    this.qty = 1,
  });

  final Function(int) onChange;
  final int qty;

  @override
  State<Quantity> createState() => _QuantityState();
}

class _QuantityState extends State<Quantity> {
  int widgetQty = 1;

  void _add() {
    setState(() {
      widgetQty++;
    });
    widget.onChange(widgetQty);
  }
  void _minus() {
    if (widgetQty != 1) {
      setState(() {
        widgetQty--;
      });
      widget.onChange(widgetQty);
    }
  }

  @override
  void initState() {
    setState(() {
      widgetQty = widget.qty;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAppColor, width: 2),
          ),
          child: Center(
            child: IconButton(
              onPressed: _minus,
              icon: const Icon(
                Icons.remove,
                size: 20,
                color: kAppColor,
              ),
              iconSize: 20,
              padding: EdgeInsets.zero,
              splashRadius: 20,
            ),
          ),
        ),
        SizedBox(
          width: kGap * 1.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$widgetQty", style: subtitle1),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: kAppColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              onPressed: _add,
              icon: const Icon(
                Icons.add,
                size: 20,
                color: kWhiteColor,
              ),
              iconSize: 20,
              padding: EdgeInsets.zero,
              splashRadius: 20,
            ),
          ),
        ),
      ],
    );
  }
}
