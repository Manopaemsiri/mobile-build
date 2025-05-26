import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/partner/product/components/packaging_list.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddToCartBottomSheet extends StatefulWidget {
  AddToCartBottomSheet({
    Key? key,
    required this.model,
    required this.shopModel,
    this.units = const [],
    this.stock = 0,
    required this.onChangeQuantity,
    required this.onChangeUnit,
    required this.onPressedOrder,
    this.trimDigits = false,
  }) : super(key: key);

  final PartnerProductModel model;
  final PartnerShopModel shopModel;
  final List<PartnerProductUnitModel> units;
  int stock;
  final dynamic Function(int) onChangeQuantity;
  final Function(PartnerProductUnitModel?) onChangeUnit;
  final Function() onPressedOrder;
  final bool trimDigits;

  @override
  State<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();

  String _img = '';
  String _name = '';
  String _price = '';
  String _memberPrice = '';

  int _inStock = 0;
  int _quantity = 1;
  late final List<PartnerProductUnitModel> _units = widget.units;
  PartnerProductUnitModel? _unit;
  final String _selectedUnitId = '';

  late bool trimDigits = widget.trimDigits;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  void _initState() {
    _img = widget.model.image?.path ?? 'https://backend.aromacoffee2u.com/assets/img/default/img.jpg';
    _name = widget.model.name;
    _price = widget.model.displayPrice(lController, trimDigits: trimDigits);
    _memberPrice = widget.model.isDiscounted() 
      ? widget.model.displayDiscountPrice(lController, trimDigits: trimDigits) 
      : widget.model.displayMemberPrice(lController, trimDigits: trimDigits);
    _inStock = widget.stock;
  }

  _onChangeUnit(String id){
    setState(() => _quantity = 1);
    widget.onChangeQuantity(1);

    if(id == ''){
      setState(() {
        _unit = null;
        _price = widget.model.displayPrice(lController, trimDigits: trimDigits);
        _memberPrice = widget.model.isDiscounted() 
          ? widget.model.displayDiscountPrice(lController, trimDigits: trimDigits) 
          : widget.model.displayMemberPrice(lController, trimDigits: trimDigits);
        _inStock = widget.stock;
      });
      widget.onChangeUnit(null);
    }else{
      var i = _units.indexWhere((d) => d.id == id);
      if(i > -1){
        PartnerProductUnitModel unit = _units[i];
        setState(() {
          _unit = unit;
          _price = unit.displayPrice(lController, trimDigits: trimDigits);
          _memberPrice = unit.isDiscounted() 
            ? unit.displayDiscountPrice(lController, trimDigits: trimDigits) 
            : unit.displayMemberPrice(lController, trimDigits: trimDigits);
          _inStock = (widget.stock / unit.convertedQuantity).floor();
        });
        widget.onChangeUnit(unit);
      }
    }
  }
  _onQuantityMinus(){
    if(_quantity > 1){
      setState(() => _quantity--);
      widget.onChangeQuantity(_quantity);
    }
  }
  _onQuantityPlus(){
    if(_quantity < _inStock){
      setState(() => _quantity++);
      widget.onChangeQuantity(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPadding,
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(kButtonRadius),
        ),
      ),
      child: Wrap(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 88,
                          height: 88,
                          child: Stack(
                            children: [
                              ImageProduct(
                                imageUrl: _img,
                                width: 88,
                                height: 88,
                              ),
                              if(_unit == null) ...[
                                if(widget.model.isClearance()) ...[
                                  Positioned(
                                    top: 0, left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kGrayColor,
                                      ),
                                      child: Text(
                                        "Clearance",
                                        style: caption.copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                                else if(widget.model.isDiscounted() || widget.model.isSetSaved()) ...[
                                  Positioned(
                                    top: 0, left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kAppColor,
                                      ),
                                      child: Text(
                                        "-${widget.model.isSetSaved()? widget.model.setSavedPercent(): widget.model.discountPercent()} %",
                                        style: caption.copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ]
                              else ...[
                                if(_unit!.isClearance()) ...[
                                  Positioned(
                                    top: 0, left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kGrayColor,
                                      ),
                                      child: Text(
                                        "Clearance",
                                        style: caption.copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                                else if(_unit!.isDiscounted()) ...[
                                  Positioned(
                                    top: 0, left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kAppColor,
                                      ),
                                      child: Text(
                                        "-${_unit!.discountPercent()} %",
                                        style: caption.copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Get.width - 120,
                          child: Padding(
                            padding: const EdgeInsets.only(left: kGap),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Get.width - 184,
                                        height: 48,
                                        child: Text(
                                          _name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: subtitle1.copyWith(
                                            fontWeight: FontWeight.w500,
                                            height: 1.45
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => Get.back(),
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.topRight,
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: kGrayColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),
                                if(_customerController.isCustomer()) ...[
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: _memberPrice,
                                      style: headline6.copyWith(
                                        fontFamily: 'Kanit',
                                        color: kAppColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        if(_unit == null && (widget.model.isDiscounted() || widget.model.isSetSaved())) ...[
                                          const TextSpan(text: "  "),
                                          TextSpan(
                                            text: widget.model.isSetSaved()
                                            ? widget.model.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits)
                                            : widget.model.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                            style: subtitle1.copyWith(
                                              fontFamily: 'Kanit',
                                              color: kGrayColor,
                                              fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ]
                                        else if(_unit != null && _unit!.isDiscounted()) ...[
                                          const TextSpan(text: "  "),
                                          TextSpan(
                                            text: _unit!.displayMemberPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                            style: subtitle1.copyWith(
                                              fontFamily: 'Kanit',
                                              color: kGrayColor,
                                              fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ]
                                else ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text: _price,
                                          style: headline6.copyWith(
                                            fontFamily: 'Kanit',
                                            color: kAppColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            if(_unit == null && widget.model.isSetSaved()) ...[
                                              const TextSpan(text: "  "),
                                              TextSpan(
                                                text: widget.model.displaySetFullSavedPrice(lController, showSymbol: false, trimDigits: trimDigits),
                                                style: subtitle1.copyWith(
                                                  fontFamily: 'Kanit',
                                                  color: kGrayColor,
                                                  fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      if(_unit == null && widget.model.signinPrice() < widget.model.priceInVAT && !widget.model.isSetSaved()) ...[
                                        InkWell(
                                          onTap: () => Get.to(() => const SignInMenuScreen()),
                                          child: BadgeDefault(
                                            title: _memberPrice,
                                            icon: FontAwesomeIcons.crown,
                                            size: 15,
                                          ),
                                        ),
                                      ]
                                      else if(_unit != null && _unit!.signinPrice() < _unit!.priceInVAT && !widget.model.isSetSaved()) ...[
                                        InkWell(
                                          onTap: () => Get.to(() => const SignInMenuScreen()),
                                          child: BadgeDefault(
                                            title: _memberPrice,
                                            icon: FontAwesomeIcons.crown,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                                
                                if(_unit == null) ...[
                                  if(widget.model.isValidDownPayment()) ...[
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "${lController.getLang("Deposit")} ",
                                        style: subtitle2.copyWith(
                                          fontFamily: 'Kanit',
                                          color: kDarkColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.model.displayDownPayment(lController, trimDigits: trimDigits),
                                            style: title.copyWith(
                                              fontFamily: 'Kanit',
                                              color: kAppColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ]
                                else ...[
                                  if(_unit!.isValidDownPayment()) ...[
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "${lController.getLang("Deposit")} ",
                                        style: subtitle2.copyWith(
                                          fontFamily: 'Kanit',
                                          color: kDarkColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _unit!.displayDownPayment(lController, trimDigits: trimDigits),
                                            style: title.copyWith(
                                              fontFamily: 'Kanit',
                                              color: kAppColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: kHalfGap),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: kGrayLightColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kQuarterGap),
            PackagingList(
              model: widget.model,
              units: _units,
              stock: widget.stock,
              selectedUnitId: _selectedUnitId,
              onChanged: _onChangeUnit
            ),
            const SizedBox(height: kHalfGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${lController.getLang("Quantity")} : ",
                  style: title.copyWith(
                    color: kDarkColor,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
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
                              onTap: _onQuantityMinus,
                              child: Text(
                                '-',
                                style: headline6.copyWith(
                                  color: _quantity > 1 
                                    ? kDarkColor: kLightColor
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Text(
                                "$_quantity",
                                style: headline6,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: _onQuantityPlus,
                              child: Text(
                                '+',
                                style: headline6.copyWith(
                                  color: _quantity < _inStock 
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
                ),
              ],
            ),
            const SizedBox(height: kQuarterGap),
            SizedBox(
              width: double.infinity,
              child: Text(
                '${lController.getLang("In stock")} $_inStock ${_unit == null? widget.model.unit: _unit?.unit}',
                textAlign: TextAlign.right,
                style: bodyText1.copyWith(
                  color: kGreenColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: kHalfGap),
            ButtonFull(
              title: lController.getLang("Add to Cart"),
              onPressed: widget.onPressedOrder,
            ),
            const SizedBox(height: kGap),
          ],
        ),
      ]),
    );
  }
}
