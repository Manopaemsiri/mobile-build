import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class QuantityBig extends StatefulWidget {
  const QuantityBig({
    Key? key,
    this.size = 42,
    required this.onChange,
    this.qty = 1,
    this.minimum = 1,
    this.available = true
  }) : super(key: key);
  final double size;
  final Function(int, bool) onChange;
  final int qty;
  final int minimum;
  final bool available;

  @override
  State<QuantityBig> createState() => _QuantityBigState();
}

class _QuantityBigState extends State<QuantityBig> {
  int _qty = 1;

  void _add() {
    bool _limit = false;
    if(widget.available){
      setState(() => _qty++);
      _limit = false;
    }else {
      _limit = true;
    }
    widget.onChange(_qty, _limit);
  }

  void _minus() {
    if (_qty > widget.minimum) {
      setState(() => _qty--);
      widget.onChange(_qty, false);
    }
  }

  @override
  void initState() {
    setState(() => _qty = widget.qty);
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
                      color: _qty > widget.minimum
                        ? kDarkColor: kLightColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    "$_qty",
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
