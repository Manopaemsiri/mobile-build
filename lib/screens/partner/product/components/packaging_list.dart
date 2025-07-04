import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackagingList extends StatefulWidget {
  PackagingList({
    super.key,
    required this.model,
    required this.units,
    this.stock = 0,
    this.selectedUnitId = '',
    required this.onChanged,
  });

  final PartnerProductModel model;
  final List<PartnerProductUnitModel> units;
  int stock;
  String selectedUnitId;
  Function(String)? onChanged;

  @override
  State<PackagingList> createState() => _PackagingListState();
}

class _PackagingListState extends State<PackagingList> {
  final LanguageController lController = Get.find<LanguageController>();
  String _selectedUnitId = '';

  @override
  void initState() {
    _selectedUnitId = widget.selectedUnitId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PartnerProductModel dataModel = widget.model;
    List<PartnerProductUnitModel> dataUnits = widget.units;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Text(
            dataModel.unitVariantName == ''
              ? lController.getLang("Choose Size")
              : dataModel.unitVariantName,
            style: title.copyWith(
              color: kDarkColor,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        const SizedBox(height: kQuarterGap),
        Container(
          padding: EdgeInsets.zero,
          child: RadioListTile(
            value: '',
            groupValue: _selectedUnitId,
            onChanged: (i) {
              setState(() => _selectedUnitId = '');
              widget.onChanged!('');
            },
            title: Text(
              dataModel.unit +
              (dataModel.unitDescription != ''
                ? ' (${dataModel.unitDescription})': ''),
              style: title.copyWith(
                fontWeight: FontWeight.w400
              )
            ),
            toggleable: true,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
          ),
        ),
        if (dataUnits.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: dataUnits.length,
            itemBuilder: (c, index) {
              PartnerProductUnitModel item = dataUnits[index];
              return widget.stock >= item.convertedQuantity
                ? Container(
                  padding: EdgeInsets.zero,
                  child: RadioListTile(
                    value: item.id!,
                    groupValue: _selectedUnitId,
                    onChanged: (i) {
                      setState(() => _selectedUnitId = item.id!);
                      widget.onChanged!(item.id!);
                    },
                    title: Text(
                      item.unit +
                      (item.unitDescription != ''
                        ? ' (${item.unitDescription})'
                        : ''),
                      style: title.copyWith(
                        fontWeight: FontWeight.w400
                      )
                    ),
                    toggleable: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                ): const SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }
}
