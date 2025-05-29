import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/address/components/province_picker.dart';
import 'package:coffee2u/screens/customer/billing_address/components/dropdown_type.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/cupertino.dart';
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

class BillingAddressScreen extends StatefulWidget {
  const BillingAddressScreen({
    super.key,
    this.addressModel,
    this.isEditMode = false,
  });

  final bool isEditMode;
  final CustomerBillingAddressModel? addressModel;

  @override
  State<BillingAddressScreen> createState() => _BillingAddressScreenState();
}

class _BillingAddressScreenState extends State<BillingAddressScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  late CustomerShippingAddressModel? shippingAddress;

  bool isLoading = true;
  bool isError = false;
  late CustomerBillingAddressModel model;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Text Controller
  final TextEditingController _cTaxpayer = TextEditingController();
  final TextEditingController _cTin = TextEditingController();
  final TextEditingController _cBranchId = TextEditingController();
  final TextEditingController _cAddress = TextEditingController();
  final TextEditingController _cSubdistrict = TextEditingController();
  final TextEditingController _cDistrict = TextEditingController();
  final TextEditingController _cProvince = TextEditingController();
  final TextEditingController _cCountry = TextEditingController();
  final TextEditingController _cZipcode = TextEditingController();
  final TextEditingController _cPhone = TextEditingController();

  int taxpayerType = 0;
  int branchType = 0;
  int _sameAsShipping = 1;
  
  final TextEditingController _cSameAddress = TextEditingController();

  // Focus Node
  final FocusNode _fTaxpayer = FocusNode();
  final FocusNode _fTin = FocusNode();
  final FocusNode _fTaxpayerType = FocusNode();
  final FocusNode _fBranchType = FocusNode();
  final FocusNode _fBranchId = FocusNode();
  final FocusNode _fAddressCard = FocusNode();
  final FocusNode _fPhone = FocusNode();
  final FocusNode _fAddress = FocusNode();
  final FocusNode _fSubdistrict = FocusNode();
  final FocusNode _fDistrict = FocusNode();
  final FocusNode _fProvince = FocusNode();
  final FocusNode _fCountry = FocusNode();
  final FocusNode _fZipcode = FocusNode();

  ProvinceModel? provinceModel;
  DistrictModel? districtModel;
  SubdistrictModel? subdistrictModel;
  
  _initState() async {
    CustomerModel? customer = controllerCustomer.customerModel;
    CustomerShippingAddressModel? shAddress = controllerCustomer.shippingAddress;

    CustomerBillingAddressModel dataModel = widget.addressModel 
      ?? CustomerBillingAddressModel(
        billingName: customer?.displayName() ?? '',
        telephone: customer?.telephone?.replaceAll('+66', '0') ?? '',
        sameAsShipping: 1
      );
    setState(() {
      model = dataModel;
      shippingAddress = shAddress;
    });

    setState(() {
      _cTaxpayer.text = model.billingName;
      _cTin.text = model.taxId;
      _cBranchId.text = model.branchId;
      _cAddress.text = model.address;
      _cSubdistrict.text = model.subdistrict?.name ?? '';
      _cDistrict.text = model.district?.name ?? '';
      _cProvince.text = model.province?.name ?? '';
      _cCountry.text = model.country?.name ?? '';
      _cZipcode.text = model.zipcode;
      _cPhone.text = model.telephone;

      taxpayerType = model.type;
      branchType = model.branchType;
      _sameAsShipping = model.sameAsShipping;
    });
    if(!widget.isEditMode && model.sameAsShipping == 1){
      if(shAddress != null && shAddress.isValidAddress()){
        setState(() {
          _cAddress.text = shAddress.address;
          _cSubdistrict.text = shAddress.subdistrict?.name ?? '';
          _cDistrict.text = shAddress.district?.name ?? '';
          _cProvince.text = shAddress.province?.name ?? '';
          _cCountry.text = shAddress.country?.name ?? '';
          _cZipcode.text = shAddress.zipcode;

          model.country = shippingAddress?.country;
          model.province = shippingAddress?.province;
          model.district = shippingAddress?.district;
          model.subdistrict = shippingAddress?.subdistrict;
          model.zipcode = shippingAddress?.zipcode ?? '';

          _cSameAddress.text = shAddress.displayAddress(lController, sep: '\n');
        });
      }
    }

    setState(() {
      isLoading = false;
      isError = false;
    });
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  void _setData(bool isSame) {
    if(isSame && !widget.isEditMode && shippingAddress != null && shippingAddress!.isValidAddress()){
      setState(() {
        _cAddress.text = shippingAddress?.address ?? '';
        _cCountry.text = shippingAddress?.country?.name ?? '';
        _cProvince.text = shippingAddress?.province?.name ?? '';
        _cDistrict.text = shippingAddress?.district?.name ?? '';
        _cSubdistrict.text = shippingAddress?.subdistrict?.name ?? '';
        _cZipcode.text = shippingAddress?.zipcode ?? '';

         model.country = shippingAddress?.country;
         model.province = shippingAddress?.province;
         model.district = shippingAddress?.district;
         model.subdistrict = shippingAddress?.subdistrict;
         model.zipcode = shippingAddress?.zipcode ?? '';
      });
    }else{
      setState(() {
        _cAddress.clear();
        _cCountry.clear();
        _cProvince.clear();
        _cDistrict.clear();
        _cSubdistrict.clear();
        _cZipcode.clear();

        model.country = null;
        model.province = null;
        model.district = null;
        model.subdistrict = null;
        model.zipcode = '';
      });
    }
  }

  @override
  void dispose() {
    _fTaxpayer.dispose();
    _fTin.dispose();
    _fTaxpayerType.dispose();
    _fBranchType.dispose();
    _fBranchId.dispose();
    _fAddressCard.dispose();
    _fPhone.dispose();
    _fAddress.dispose();
    _fSubdistrict.dispose();
    _fDistrict.dispose();
    _fProvince.dispose();
    _fCountry.dispose();
    _fZipcode.dispose();
    super.dispose();
  }

  readyToShow(bool value) {
    if(mounted){
      if(!value){
        setState(() {
          isError = true;
        });
      }
    }
  }

  _deleteAddress() {
    ShowDialog.showOptionDialog(
      lController.getLang("delete data"),
      "${lController.getLang("text_delete_address1")} ?",
      () async {
        Get.back();
        bool res = await ApiService.processDelete(
          "billing-address",
          needLoading: true,
          input: { "_id": widget.addressModel?.id }
        );
        if(res){
          refreshData();
          int count = 0;
          Get.until((_) => count++ >= 2);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(lController.getLang('Tax Invoice')),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: isLoading
          ? Center(
            child: Loading(),
          )
          : Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: kPadding,
                  child: Column(
                    children: [
                      LabelText(
                        text: lController.getLang("Taxpayer"),
                        isRequired: true
                      ),
                      const Gap(gap: kHalfGap),
                      TextFormField(
                        controller: _cTaxpayer,
                        focusNode: _fTaxpayer,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lController.getLang("Taxpayer"),
                        ),
                        onChanged: (value) {},
                        textInputAction: TextInputAction.next,
                        validator: (value) => Utils.validateString(value),
                        onFieldSubmitted: (str) => _fTin.requestFocus(),
                      ),
                      
                      const Gap(),
                      LabelText(
                        text: lController.getLang("tin"),
                        isRequired: true
                      ),
                      const Gap(gap: kHalfGap),
                      TextFormField(
                        controller: _cTin,
                        focusNode: _fTin,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lController.getLang("tin"),
                        ),
                        onChanged: (value) {},
                        textInputAction: TextInputAction.next,
                        validator: (value) => Utils.validateString(value),
                        onFieldSubmitted: (str) => _fTaxpayerType.requestFocus(),
                      ),
                      
                      const Gap(),
                      DropdownType(
                        initTaxpayerType: taxpayerType,
                        initBranchType: branchType,
                        initBranchId: _cBranchId.text,
                        onChange: (taxpayerTypeChanged, branchTypeChanged) {
                          setState(() {
                            taxpayerType = taxpayerTypeChanged['value'];
                          });

                          if(branchTypeChanged['name'] != null){
                            setState(() {
                              branchType = branchTypeChanged['value'];
                            });
                          }

                          if(taxpayerType == 0){
                            setState(() {
                              _cBranchId.clear();
                              branchType = 0;
                            });
                          }

                          if(branchType != 2){
                            setState(() => _cBranchId.clear());
                          }
                        },
                      ),
                      if(branchType == 2) ...[
                        LabelText(
                          text: lController.getLang("Branch Sequence"),
                          isRequired: true
                        ),
                        const Gap(gap: kHalfGap),
                        TextFormField(
                          controller: _cBranchId,
                          focusNode: _fBranchId,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: lController.getLang("Branch Sequence"),
                          ),
                          validator: (value) => branchType != 0
                            ? Utils.validateString(value)
                            : null,
                        ),
                        const Gap(),
                      ],
                      
                      LabelText(
                        text: lController.getLang("Telephone Number"),
                        isRequired: true
                      ),
                      const Gap(gap: kHalfGap),
                      TextFormField(
                        controller: _cPhone,
                        focusNode: _fPhone,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lController.getLang("Telephone Number"),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.done,
                        validator: (str) => validatateNumber(str),
                      ),
                      const Gap(gap: kHalfGap),
                    ],
                  ),
                ),

                const DividerThick(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!widget.isEditMode && shippingAddress != null && shippingAddress!.isValidAddress()) ...[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            lController.getLang("text_address_1"),
                            style: subtitle1.copyWith(
                              fontWeight: FontWeight.w600
                            )
                          ),
                          trailing: Transform.scale(
                            scale: 0.7,
                            alignment: Alignment.centerRight,
                            child: CupertinoSwitch(
                              value: _sameAsShipping == 1? true: false,
                              activeColor: kAppColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _sameAsShipping = value? 1: 0;
                                });
                                _setData(value);
                              },
                            ),
                          ),
                        ),
                      ],

                      const Gap(),
                      if ((widget.isEditMode || _sameAsShipping == 0) && !isError) ...[
                        TextFormField(
                          focusNode: _fAddress,
                          controller: _cAddress,
                          minLines: 2,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: '${lController.getLang("Address")} *',
                            alignLabelWithHint: true,
                          ),
                          validator: (str) => validateString(str),
                        ),
                        const Gap(),
                        ProvincePicker<CustomerBillingAddressModel>(
                          model: model,
                          isReady: (value) => readyToShow(value),
                          onChanged: ({country, province, district, subdistrict, zipcode}){
                            setState(() {
                              if(country != null) {
                                model.country = country;
                                _cCountry.text = country.name;
                              }else {
                                model.country = null;
                                _cCountry.clear();
                              }

                              if(province != null) {
                                model.province = province;
                                _cProvince.text = province.name;
                              }else {
                                model.province = null;
                                _cProvince.clear();
                              }

                              if(district != null) {
                                model.district = district;
                                _cDistrict.text = district.name;
                              }else {
                                model.district = null;
                                _cDistrict.clear();
                              }

                              if(subdistrict != null){
                                model.subdistrict = subdistrict;
                                _cSubdistrict.text = subdistrict.name;
                              }else {
                                model.subdistrict = null;
                                _cSubdistrict.clear();
                              }

                              if(zipcode != null) {
                                model.zipcode = zipcode;
                                _cZipcode.text = zipcode;
                              }else {
                                model.zipcode = '';
                                _cZipcode.clear();
                              }
                            });
                          },
                        ),
                      ] else if((widget.isEditMode || _sameAsShipping == 0) && isError)...[
                        NoData(
                          title: "Error",
                          spacer: false,
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _cSameAddress,
                          minLines: 2,
                          maxLines: 3,
                          showCursor: false,
                          enabled: false,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: '${lController.getLang("Address")} *',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
      ),
      bottomNavigationBar: isLoading
        ? const SizedBox.shrink()
        : Padding(
          padding: kPaddingSafeButton,
          child: Row(
            children: [
              if(widget.isEditMode) ...[
                Expanded(
                  child: ButtonCustom(
                    onPressed: _deleteAddress,
                    title: lController.getLang("Delete Address"),
                    isOutline: true,
                    textStyle: headline6,
                  ),
                ),
                const SizedBox(width: kGap),
              ],
              Expanded(
                child: ButtonFull(
                  title: lController.getLang("Save"),
                  onPressed: _onTapSave,
                ),
              ),
            ],
          ),
        ),
    );
  }

  refreshData() async {
    CustomerBillingAddressModel? shippingAddress;
    await ApiService.processRead('billing-address-get-selected').then((value) {
      if (value?['result'] != null) {
        shippingAddress = CustomerBillingAddressModel.fromJson(value?['result']);
      }
    });
    await controllerCustomer.updateBillingAddress(shippingAddress);
  }

  void _onTapSave() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      CustomerBillingAddressModel temp = CustomerBillingAddressModel(
        billingName: _cTaxpayer.text,
        taxId: _cTin.text,
        type: taxpayerType,
        address: _cAddress.text,
        subdistrict: model.subdistrict,
        district: model.district,
        province: model.province,
        country: model.country,
        zipcode: model.zipcode,
        telephone: _cPhone.text,
        isPrimary: 1,
        isSelected: 1,
        sameAsShipping: _sameAsShipping,
      );
      if (taxpayerType != 0) {
        temp.type = taxpayerType;
        temp.branchType = branchType;
        if (branchType == 2) {
          temp.branchId = _cBranchId.text;
        }
      }
      if (widget.isEditMode) {
        // temp.id = controllerCustomer.billingAddress?.id;
        temp.id = model.id;
        var res = await ApiService.processUpdate('billing-address',
            input: {"address": temp}, needLoading: true);
        if (res) {
          await refreshData();
          Get.back();
        }
      } else {
        var res = await ApiService.processCreate('billing-address',
            input: {"address": temp}, needLoading: true);
        if (res) {
          await refreshData();
          Get.back();
        }
      }
    }
  }
}
