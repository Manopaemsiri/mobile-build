import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';


class PaymentItem extends StatelessWidget {
  const PaymentItem({
    super.key,
    required this.model,
    required this.selected,
    required this.onSelect,
    required this.lController,
  });

  final PaymentMethodModel model;
  final PaymentMethodModel? selected;
  final Function(PaymentMethodModel?) onSelect;
  final LanguageController lController;
  
  _onSelect(String? value){
    onSelect(model);
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
      clipBehavior: Clip.hardEdge,
      child: RadioListTile<String?>(
        value: model.id,
        groupValue: selected?.id,
        onChanged: _onSelect,
        secondary: SizedBox(
          height: 38,
          width: 38,
          child: ImageUrl(
            imageUrl: model.icon!.path
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: kHalfGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name, 
                style: subtitle1.copyWith(
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 2),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  text: "ชำระ ",
                  style: subtitle1.copyWith(
                    fontFamily: 'Kanit',
                    color: kDarkGrayColor,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: priceFormat(
                        model.payNow - (false? model.diffInstallment: 0),
                        lController
                      ),
                      style: subtitle1.copyWith(
                        fontFamily: 'Kanit',
                        color: kAppColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if(false && model.diffInstallment > 0) ...[
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    text: "+ ค่าบริการผ่อนชำระ ",
                    style: subtitle1.copyWith(
                      fontFamily: 'Kanit',
                      color: kDarkGrayColor,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(
                        text: priceFormat(model.diffInstallment, lController),
                        style: subtitle1.copyWith(
                          fontFamily: 'Kanit',
                          color: kAppColor,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        toggleable: true,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}
