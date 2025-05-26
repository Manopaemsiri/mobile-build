import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
  type
    0 = บุคคลธรรมดา
    1 = ห้างหุ้นส่วนจำกัด
    2 = บริษัทจำกัด

  branchType
    0 = บุคคลธรรมดา
    1 = สาขาใหญ่
    2 = สาขาย่อย
*/

class DropdownType extends StatefulWidget {
  const DropdownType({
    Key? key,
    required this.onChange,
    this.initTaxpayerType = 0,
    this.initBranchType = 1,
    this.initBranchId = '',
  }) : super(key: key);
  
  final Function(Map<String, dynamic>, Map<String, dynamic>) onChange;
  final int initBranchType;
  final int initTaxpayerType;
  final String initBranchId;

  @override
  State<DropdownType> createState() => _DropdownTypeState();
}

class _DropdownTypeState extends State<DropdownType> {
  late final LanguageController lController = Get.find<LanguageController>();
  TextEditingController cTaxpayerType = TextEditingController();
  TextEditingController cBranchType = TextEditingController();
  TextEditingController cBranchId = TextEditingController();

  FocusNode fTaxpayerType = FocusNode();
  FocusNode fBranchType = FocusNode();
  FocusNode fBranchId = FocusNode();
  FocusNode fEmail = FocusNode();

  final List<Map<String, dynamic>> types = [];
  late final List<Map<String, dynamic>> taxpayerTypeList = [
    {'name': lController.getLang("Individual"), 'value': 0},
    {'name': lController.getLang("Limited Partnership"), 'value': 1},
    {'name': lController.getLang("Limited Company"), 'value': 2},
  ];

  late final List<Map<String, dynamic>> branchTypeList = [
    {'name': lController.getLang("Head Office"), 'value': 1},
    {'name': lController.getLang("Sub Office"), 'value': 2}
  ];

  late Map<String, dynamic> taxpayerTypeSelected = {};
  late Map<String, dynamic> branchTypeSelected = {};

  int taxpayerType = 0;
  int branchType = 0;

  @override
  void initState() {
    int index = taxpayerTypeList.indexWhere((e) => e['value'] == widget.initTaxpayerType);
    if (index > -1) {
      taxpayerTypeSelected = taxpayerTypeList[index];
      cTaxpayerType.text = taxpayerTypeList[index]['name'];
      taxpayerType = taxpayerTypeList[index]['value'];
    }

    index = branchTypeList.indexWhere((e) => e['value'] == widget.initBranchType);
    if (index > -1) {
      branchTypeSelected = branchTypeList[index];
      cBranchType.text = branchTypeList[index]['name'];
      branchType = branchTypeList[index]['value'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Taxpayer Type
        LabelText(
          text: lController.getLang("Taxpayer Type"),
          isRequired: true
        ),
        const Gap(gap: kHalfGap),
        TextFormField(
          controller: cTaxpayerType,
          focusNode: fTaxpayerType,
          readOnly: true,
          validator: (value) => Utils.validateString(value),
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonRadius),
              ),
              builder: (context) {
                return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    maxChildSize: 0.5,
                    minChildSize: 0.5,
                    expand: false,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                kHalfGap, kGap, kHalfGap, kGap
                              ),
                              child: Column(
                                children: taxpayerTypeList.map((Map<String, dynamic> item) {
                                  return ListTile(
                                    title: Text(
                                      item["name"],
                                      style: title.copyWith(
                                        color: taxpayerTypeSelected['value'] == item['value']
                                          ? kAppColor: kDarkColor,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    dense: true,
                                    onTap: (){
                                      setModalState(() => taxpayerTypeSelected = item);
                                      cTaxpayerType.text = taxpayerTypeSelected["name"];
                                      taxpayerType = taxpayerTypeSelected["value"];
                                      widget.onChange(taxpayerTypeSelected, branchTypeSelected);
                                      Get.back();
                                    },
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                });
              },
            );
          },
          showCursor: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            hintText: lController.getLang("Taxpayer Type"),
          ),
        ),
        const Gap(),

        // Taxpayer Type Ltd
        if (taxpayerType != 0) ...[
          LabelText(
            text: lController.getLang("Branch Type"),
            isRequired: true
          ),
          const Gap(gap: kHalfGap),
          TextFormField(
            controller: cBranchType,
            focusNode: fBranchType,
            readOnly: true,
            validator: (value) => taxpayerType != 0 ? Utils.validateString(value) : null,
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kButtonRadius),
                ),
                builder: (context) {
                  return StatefulBuilder(builder: (context, setModalState) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      maxChildSize: 0.5,
                      minChildSize: 0.5,
                      expand: false,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(kButtonRadius)
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  kHalfGap, kGap, kHalfGap, kGap
                                ),
                                child: Column(
                                  children: branchTypeList.map((Map<String, dynamic> item) {
                                    return ListTile(
                                      title: Text(
                                        item["name"],
                                        style: title.copyWith(
                                          color: branchTypeSelected["value"] == item["value"]
                                            ? kAppColor: kDarkColor,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      dense: true,
                                      onTap: () {
                                        setModalState(() => branchTypeSelected = item);
                                        cBranchType.text = branchTypeSelected['name'];
                                        branchType = branchTypeSelected['value'];
                                        widget.onChange(taxpayerTypeSelected, branchTypeSelected);
                                        Get.back();
                                      },
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    );
                  });
                },
              );
            },
            showCursor: false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              hintText: lController.getLang("Branch Type"),
            ),
          ),
          const Gap(),
        ],
      
      ],
    );
  }
}
