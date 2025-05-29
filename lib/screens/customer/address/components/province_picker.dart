import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProvincePicker<Classer> extends StatefulWidget {
  const ProvincePicker({
    super.key,
    required this.model,
    required this.onChanged,
    this.showTitle = false,
    required this.isReady,
  });

  final Classer model;
  final Function({CountryModel? country, ProvinceModel? province, DistrictModel? district, SubdistrictModel? subdistrict, String? zipcode}) onChanged;
  final Function(bool) isReady;
  final bool showTitle;

  @override
  State<ProvincePicker> createState() => _ProvincePickerState();
}

class _ProvincePickerState extends State<ProvincePicker> {
  bool isReady = false;
  final LanguageController lController = Get.find<LanguageController>();
  dynamic model;
  
  final TextEditingController cCountry = TextEditingController();
  final TextEditingController _cProvince = TextEditingController();
  final TextEditingController _cDistrict = TextEditingController();
  final TextEditingController _cSubdistrict = TextEditingController();
  final TextEditingController _cZipcode = TextEditingController();

  List<CountryModel> dataCountries = [];
  List<ProvinceModel> dataProvinces = [];
  List<DistrictModel> dataDistricts = [];
  List<SubdistrictModel> dataSubdistricts = [];
  List<String> dataZipcodes = [];
  
  CountryModel? selectedCountry;
  ProvinceModel? selectedProvince;
  DistrictModel? selectedDistrict;
  SubdistrictModel? selectedSubdistrict;
  String selectedZipcode = '';
  
  updateCountry(CountryModel value) async {
    if(value.isValid()){
      final input = {'dataFilter': {'countryId': value.id}};
      List<ProvinceModel>  province = [];
      final res = await ApiService.processList('data-provinces', input: input);
      final len = res?["result"].length ?? 0;
      for (var i = 0; i < len; i++) {
        ProvinceModel model = ProvinceModel.fromJson(res?['result'][i]);
        province.add(model);
      }
      if(mounted){
        setState(() {
          selectedCountry = value;

          selectedProvince = null;
          selectedDistrict = null;
          selectedSubdistrict = null;
          selectedZipcode = '';

          dataProvinces = province;
          dataDistricts = [];
          dataSubdistricts = [];
          dataZipcodes = [];

          cCountry.text = value.name;
          _cProvince.clear();
          _cDistrict.clear();
          _cSubdistrict.clear();
          _cZipcode.clear();
        });
      }
    }
  }
  updateProvince(ProvinceModel value) async {
    if(value.isValid()){
      final input = {'dataFilter': {'provinceId': value.id}};
      List<DistrictModel>  district = [];
      final res = await ApiService.processList('data-districts', input: input);
      final len = res?["result"].length ?? 0;
      for (var i = 0; i < len; i++) {
        DistrictModel model = DistrictModel.fromJson(res?['result'][i]);
        district.add(model);
      }
      if(mounted){
        setState(() {
          selectedProvince = value;
          selectedDistrict = null;
          selectedSubdistrict = null;
          selectedZipcode = '';

          dataDistricts = district;
          dataSubdistricts = [];
          dataZipcodes = [];

          _cProvince.text = value.name;
          _cDistrict.clear();
          _cSubdistrict.clear();
          _cZipcode.clear();
        });
      }
    }
  }
  updateDistricts(DistrictModel value) async {
    if(value.isValid()){
      final input = {'dataFilter': {'districtId': value.id}};
      List<SubdistrictModel>  subdistrict = [];
      final res = await ApiService.processList('data-subdistricts', input: input);
      final len = res?["result"].length ?? 0;
      for (var i = 0; i < len; i++) {
        SubdistrictModel model = SubdistrictModel.fromJson(res?['result'][i]);
        subdistrict.add(model);
      }
      if(mounted){
        setState(() {
          selectedDistrict = value;
          selectedSubdistrict = null;
          selectedZipcode = '';

          dataSubdistricts = subdistrict;
          dataZipcodes = [];

          _cDistrict.text = value.name;
          _cSubdistrict.clear();
          _cZipcode.clear();
          
        });
      }
    }
  }
  updateSubdistrict(SubdistrictModel value) async {
    if(value.isValid()){
      if(mounted){
        setState(() {
          selectedSubdistrict = value;
          selectedZipcode = '';

          dataZipcodes = value.zipcodes;

          _cSubdistrict.text = value.name;
          _cZipcode.text = '';

        });
      }
    }
  }
  updateZipcode(String value) async {
    if(mounted){
      setState(() {
        selectedZipcode = value;
        _cZipcode.text = value;
      });
    }
  }

  _initState() async {
   try {
      model = widget.model;

      // Country
      List<CountryModel> country = [];
      final res1 = await ApiService.processList('data-countries');
      final len1 = res1?["result"].length ?? 0;
      for (var i = 0; i < len1; i++) {
        CountryModel model = CountryModel.fromJson(res1?['result'][i]);
        country.add(model);
      }
      await updateCountry(widget.model?.country ?? country.first);
      if(widget.model?.province != null) await updateProvince(widget.model?.province);
      if(widget.model?.district != null) await updateDistricts(widget.model?.district);
      if(widget.model?.subdistrict != null) await updateSubdistrict(widget.model?.subdistrict);
      if(widget.model?.zipcode != '') await updateZipcode(widget.model?.zipcode);

      setState(() {
        isReady = true;
        widget.isReady(isReady);
        dataCountries = country;
      });
    } catch (e) {
      if(kDebugMode) print("$e");
      setState(() {
        isReady = false;
        widget.isReady(isReady);
      });
    }
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isReady
      ? const SizedBox.shrink()
      : Column(
        children: [
          if (widget.showTitle) ...[
            LabelText(
              text: lController.getLang("Country"),
              isRequired: true
            ),
            const Gap(gap: kHalfGap),
          ],
          TextFormField(
            controller: cCountry,
            showCursor: false,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '${lController.getLang("Country")} *',
              alignLabelWithHint: true,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
              ),
            ),
            validator: (value) => Utils.validateString(value),
            onTap: () => onTapSheet(
              items: dataCountries,
              onTap: (model) {
                final temp = model as CountryModel;
                onChooseCountry(temp);
              }
            ),
          ),
          const Gap(),

          if (widget.showTitle) ...[
            LabelText(
              text: lController.getLang("Province"),
              isRequired: true
            ),
            const Gap(gap: kHalfGap),
          ],
          TextFormField(
            controller: _cProvince,
            showCursor: false,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '${lController.getLang("Province")} *',
              alignLabelWithHint: true,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
              ),
            ),
            validator: (value) => Utils.validateString(value),
            onTap: () => onTapSheet(
              items: dataProvinces,
              onTap: (model) {
                final temp = model as ProvinceModel;
                onChooseProvince(temp);
              }
            ),
          ),
          const Gap(),
          
          if (widget.showTitle) ...[
            LabelText(
              text: lController.getLang("District"),
              isRequired: true
            ),
            const Gap(gap: kHalfGap),
          ],
          TextFormField(
            controller: _cDistrict,
            enabled: _cProvince.text != '',
            showCursor: false,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '${selectedProvince?.prefixDistrict(lController) ?? lController.getLang('district')} *',
              alignLabelWithHint: true,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            validator: (value) => Utils.validateString(value),
            onTap: () => onTapSheet(
              items: dataDistricts,
              onTap: (model) {
                final temp = model as DistrictModel;
                onChooseDistrict(temp);
              }
            ),
          ),
          const Gap(),

          if (widget.showTitle) ...[
            LabelText(
              text: lController.getLang("Subdistrict"),
              isRequired: true
            ),
            const Gap(gap: kHalfGap),
          ],
          TextFormField(
            controller: _cSubdistrict,
            enabled: _cDistrict.text != '',
            showCursor: false,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '${selectedProvince?.prefixSubdistrict(lController) ?? lController.getLang('subdistrict')} *',
              alignLabelWithHint: true,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            validator: (value) => Utils.validateString(value),
            onTap: () => onTapSheet(
              items: dataSubdistricts,
              onTap: (model) {
                final temp = model as SubdistrictModel;
                onChooseSubdistrict(temp);
              }
            ),
          ),
          const Gap(),

          if (widget.showTitle) ...[
            LabelText(
              text: lController.getLang("ZIP Code"),
              isRequired: true
            ),
            const Gap(gap: kHalfGap),
          ],
          TextFormField(
            controller: _cZipcode,
            enabled: _cSubdistrict.text != '',
            showCursor: false,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '${lController.getLang("ZIP Code")} *',
              alignLabelWithHint: true,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
              ),
            ),
            validator: (value) => Utils.validateString(value),
            onTap: () => onTapSheet(
              items: dataZipcodes,
              onTap: (model) {
                final temp = model as String;
                onChooseZipCode(temp);
              },
              isListString: true
            ),
          ),
        
        ],
      );
  }

  onChooseCountry(CountryModel value) {
    updateCountry(value);
    widget.onChanged(country: value);
    Get.back();
  }
  onChooseProvince(ProvinceModel value) {
    updateProvince(value);
    widget.onChanged(
      country: selectedCountry,
      province: value
    );
    Get.back();
  }
  onChooseDistrict(DistrictModel value) {
    updateDistricts(value);
    widget.onChanged(
      country: selectedCountry,
      province: selectedProvince,
      district: value
    );
    Get.back();
  }
  onChooseSubdistrict(SubdistrictModel value) {
    updateSubdistrict(value);
    widget.onChanged(
      country: selectedCountry,
      province: selectedProvince,
      district: selectedDistrict,
      subdistrict: value
    );
    Get.back();
  }
  onChooseZipCode(String value) {
    updateZipcode(value);
    widget.onChanged(
      country: selectedCountry,
      province: selectedProvince,
      district: selectedDistrict,
      subdistrict: selectedSubdistrict,
      zipcode: value
    );
    Get.back();
  }

  void onTapSheet({required List<dynamic> items, required Function(dynamic) onTap, bool isListString = false}){
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4.0),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                children: [
                  Padding(
                    padding: kPadding,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80,
                        height: 8,
                        padding: kPadding,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index){
                        final dynamic model = items[index];

                        return ListTile(
                          title: Text(
                            isListString? model: model.name,
                            style: title.copyWith(
                              // fontFamily: lController.fontFamily
                            ),
                          ),
                          onTap: () => onTap(model)
                        );
                      }
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}