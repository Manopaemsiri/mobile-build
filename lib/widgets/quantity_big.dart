import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class QuantityBig extends StatefulWidget {
  const QuantityBig({
    super.key,
    this.size = 42,
    required this.onChange,
    this.qty = 1,
    this.minimum = 1,
    this.available = true
  });
  final double size;
  final Function(int, bool) onChange;
  final int qty;
  final int minimum;
  final bool available;

  @override
  State<QuantityBig> createState() => _QuantityBigState();
}

class _QuantityBigState extends State<QuantityBig> {
  int widgetQty = 1;

  void _add() {
    bool widgetLimit = false;
    if(widget.available){
      setState(() => widgetQty++);
      widgetLimit = false;
    }else {
      widgetLimit = true;
    }
    widget.onChange(widgetQty, widgetLimit);
  }

  void _minus() {
    if (widgetQty > widget.minimum) {
      setState(() => widgetQty--);
      widget.onChange(widgetQty, false);
    }
  }

  @override
  void initState() {
    setState(() => widgetQty = widget.qty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Center(
        child: Table(
          border: TableBorder.all(
            color: kLightColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                kButtonRadius,
              ),
            ),
          ),
          children: [
            TableRow(
              children: [
                GestureDetector(
                  onTap: _minus,
                  child: Text(
                    '-',
                    style: headline6.copyWith(
                      color: widgetQty > widget.minimum
                        ? kDarkColor: kLightColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    "$widgetQty",
                    style: headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: _add,
                  child: Text(
                    '+',
                    style: headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
