import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class QuantityBigFix extends StatefulWidget {
  const QuantityBigFix({
    super.key,
    this.size = 42,
    required this.onChange,
    this.qty = 1,
    this.minimum = 1,
    this.maximum = 9999999,
  });

  final double size;
  final Function(int) onChange;
  final int qty;
  final int minimum;
  final int maximum;

  @override
  State<QuantityBigFix> createState() => _QuantityBigFixState();
}

class _QuantityBigFixState extends State<QuantityBigFix> {
  void _add() {
    if(widget.qty < widget.maximum){
      widget.onChange(widget.qty + 1);
    }
  }
  void _minus() {
    if (widget.qty > widget.minimum) {
      widget.onChange(widget.qty - 1);
    }
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
                      color: widget.qty > widget.minimum
                        ? kDarkColor: kLightColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    "${widget.qty}",
                    style: headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: _add,
                  child: Text(
                    '+',
                    style: headline6.copyWith(
                      color: widget.qty < widget.maximum
                        ? kDarkColor: kLightColor
                    ),
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
