import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class TableList extends StatelessWidget {
  const TableList({
    Key? key,
    required this.list
  }) : super(key: key);

  final List<Map<String, dynamic>> list;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: kGrayColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kRadius),
        ),
      ),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        for(var row in list)
          TableRow(
            children: <Widget>[
              Container(
                padding: kHalfPadding,
                child: Text(
                  row["title"].toString(),
                  style: title.copyWith(
                    fontWeight: FontWeight.w600
                  )
                ),
              ),
              Container(
                padding: kHalfPadding,
                child: Text(
                  row["desc"].toString(),
                  style: title.copyWith(
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ],
          ),

      ],
    );
  }
}
