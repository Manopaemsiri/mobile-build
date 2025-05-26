import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  const BulletList({
    Key? key,
    required this.strings,
  }) : super(key: key);

  final List<String> strings;

  @override
  Widget build(BuildContext context) {
    if (strings.isEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "-",
          textAlign: TextAlign.left,
          softWrap: true,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.6),
            height: 1.55,
          ),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  str,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                    height: 1.55,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
