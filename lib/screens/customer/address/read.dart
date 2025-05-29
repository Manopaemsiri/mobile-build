import 'dart:async';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/address/components/pin_on_maps.dart';
import 'package:coffee2u/screens/customer/address/components/province_picker.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class AddressAddScreen extends StatefulWidget {
  const AddressAddScreen({
    super.key,
    this.addressModel,
    this.isEditMode = false,
  });

  final bool isEditMode;
  final CustomerShippingAddressModel? addressModel;

  @override
  State<AddressAddScreen> createState() => _AddressAddScreenState();
}

class _AddressAddScreenState extends State<AddressAddScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();

  bool isReady = false;
  bool isReady2 = false;
  bool isError = false;
  late CustomerShippingAddressModel model;
  bool isPrimary = false;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Text Controller
  final TextEditingController _cAddress = TextEditingController();
  final TextEditingController _cSubdistrict = TextEditingController();
  final TextEditingController _cDistrict = TextEditingController();
  final TextEditingController _cProvince = TextEditingController();
  final TextEditingController _cCountry = TextEditingController();
  final TextEditingController _cZipcode = TextEditingController();
  final TextEditingController _cFirstname = TextEditingController();
  final TextEditingController _cLastname = TextEditingController();
  final TextEditingController _cPhone = TextEditingController();

  // Focus Node
  final FocusNode _fAddress = FocusNode();
  final FocusNode _fSubDistrict = FocusNode();
  final FocusNode _fDistrict = FocusNode();
  final FocusNode _fProvince = FocusNode();
  final FocusNode _fZipcode = FocusNode();
  final FocusNode _fFirstname = FocusNode();
  final FocusNode _fLastname = FocusNode();
  final FocusNode _fPhone = FocusNode();

  // Map
  GoogleMapController? _mapController;
  bool _mapNeedRender = false;
  late LatLng _mapCenter;
  Set<Marker> _mapMarkers = {};
  late Uint8List? _mapMarkerIcon;

  _initState() async {
    CustomerModel? _customer = _customerController.customerModel;

    CustomerShippingAddressModel _model = widget.addressModel 
      ?? CustomerShippingAddressModel(
        shippingFirstname: _customer?.firstname ?? '',
        shippingLastname: _customer?.lastname ?? '',
        telephone: _customer?.telephone?.replaceAll('+66', '0') ?? '',
      );
    setState(() {
      model = _model;
    });

    _fAddress.addListener(_checkUpdateLatLngFromAddress);
    setState(() {
      _cAddress.text = _model.address;
      _cSubdistrict.text = model.subdistrict?.name ?? '';
      _cDistrict.text = model.district?.name ?? '';
      _cProvince.text = model.province?.name ?? '';
      _cCountry.text = model.country?.name ?? '';
      _cZipcode.text = model.zipcode;
      _cFirstname.text = model.shippingFirstname;
      _cLastname.text = model.shippingLastname;
      _cPhone.text = model.telephone;
      
      _mapCenter = LatLng(
        _model.lat ?? 13.810076929,
        _model.lng ?? 100.5966026673
      );
    });

    LatLng _tempCenter = LatLng(
      _model.lat ?? 13.810076929,
      _model.lng ?? 100.5966026673
    );
    _onAddMarkerButtonPressed(_tempCenter);
    setState(() => _mapNeedRender = !_model.isValidAddress());

    setState(() {
      isReady = true;
      isReady2 = isReady && false;
    });
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  void dispose() {
    _fAddress.removeListener(_checkUpdateLatLngFromAddress);
    _fAddress.dispose();
    _fSubDistrict.dispose();
    _fDistrict.dispose();
    _fProvince.dispose();
    _fZipcode.dispose();
    _fFirstname.dispose();
    _fLastname.dispose();
    _fPhone.dispose();
    _cCountry.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    try {
      CustomerShippingAddressModel? shippingAddress;
      final res = await ApiService.processRead('shipping-address-get-selected');
      if(res?['result'] != null) {
        shippingAddress = CustomerShippingAddressModel.fromJson(res?['result']);
        await _customerController.updateShippingAddress(shippingAddress);
      }
    } catch (e) {
      if(kDebugMode) printError(info: '$e');
    }
  }

  _deleteAddress() {
    ShowDialog.showOptionDialog(
      lController.getLang("delete data"),
      "${lController.getLang("text_delete_address1")} ?",
      () async {
        Get.back();
        bool res = await ApiService.processDelete(
          "shipping-address",
          needLoading: true,
          input: { "_id": model.id }
        );
        if(res){
          await _refreshData();
          Get.back(result: {"refresh": true});
        }
      },
    );
  }

  void _onMapCreated(GoogleMapController controller )=>
    setState(() => _mapController = controller);

  Future<void> _checkUpdateLatLngFromAddress() async {
    if(_mapNeedRender && model.isValidAddress()){
      String _addressStr = model.displayAddress(lController, withCountry: true);
      await locationFromAddress(_addressStr).then((value) {
        if(mounted && value.isNotEmpty){
          LatLng _tempCenter = LatLng(
            value.first.latitude,
            value.first.longitude
          );
          _onAddMarkerButtonPressed(_tempCenter);
          setState(() => _mapNeedRender = false);
        }
      });
    }
  }

  void _onAddMarkerButtonPressed(LatLng latLng) async {
    _mapMarkerIcon = await getBytesFromAsset(defaultPin, 100);
    if(_mapMarkers.isNotEmpty){
      _mapMarkers.clear();
    }
    setState(() {
      _mapCenter = latLng;
      _mapMarkers.add(Marker(
        position: latLng,
        markerId: MarkerId(latLng.toString()),
        icon: BitmapDescriptor.fromBytes(_mapMarkerIcon!),
      ));
      _mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 12)
        )
      );
    });
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer.asUint8List();
  }

  readyToShow(bool value) {
    if(mounted){
      setState(() => isReady2 = value && isReady);
      if(!isReady2) setState(() => isError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang(
          widget.isEditMode ? "Edit Address" : "Add New Address"
        )),
        bottom: const AppBarDivider(),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: !isReady2 || isError? 0: 1,
              duration: const Duration(milliseconds: 250),
              child: IgnorePointer(
                ignoring: !isReady2 || isError,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: kPadding,
                    children: [
                      const Gap(gap: kHalfGap),
                      TextFormField(
                        controller: _cAddress,
                        focusNode: _fAddress,
                        maxLines: 3,
                        minLines: 2,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: '${lController.getLang("Delivery To")} *',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (String value) {
                          setState(() => model.address = value);
                        },
                        validator: (str) => validateString(str),
                      ),
                      const Gap(),
              
                      ProvincePicker<CustomerShippingAddressModel>(
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
                            _checkUpdateLatLngFromAddress();
                          });
                        },
                      ),
                      const Gap(gap: kGap+kHalfGap),
              
                      // Contact Info
                      Text(
                        lController.getLang("Contact Information"),
                        style: headline6
                      ),
                      const Gap(gap: kGap),
                      TextFormField(
                        controller: _cFirstname,
                        focusNode: _fFirstname,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: '${lController.getLang("First Name")} *',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (String value) {
                          setState(() => model.shippingFirstname = value);
                        },
                        validator: (str) => validateString(str),
                      ),
                      const Gap(),
                      TextFormField(
                        controller: _cLastname,
                        focusNode: _fLastname,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: '${lController.getLang("Last Name")} *',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (String value) {
                          setState(() => model.shippingLastname = value);
                        },
                        validator: (str) => validateString(str),
                      ),
                      const Gap(),
                      TextFormField(
                        controller: _cPhone,
                        focusNode: _fPhone,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: '${lController.getLang("Telephone Number")} *',
                          alignLabelWithHint: true,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        onChanged: (String value) {
                          setState(() => model.telephone = value);
                        },
                        validator: (str) => validatateNumber(str),
                      ),
              
                      // Map
                      if(model.isValidAddress()) ...[
                        const Gap(),
                        Container(
                          decoration: const BoxDecoration(
                            color: kGrayLightColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(kRadius),
                            ),
                          ),
                          height: 250,
                          width: Get.width,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(kRadius),
                                ),
                                child: GoogleMap(
                                  onTap: (latlng) {
                                    Get.to(
                                      () => PinOnMaps(
                                        isEditMode: widget.isEditMode,
                                        latLng: _mapCenter,
                                        addressModel: model,
                                        onSubmit: (latitude, longitude) {
                                          _onAddMarkerButtonPressed(LatLng(latitude, longitude));
                                        }
                                      ),
                                    );
                                  },
                                  scrollGesturesEnabled: false,
                                  zoomControlsEnabled: false,
                                  zoomGesturesEnabled: false,
                                  myLocationButtonEnabled: false,
                                  markers: _mapMarkers,
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _mapCenter,
                                    zoom: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if(!isReady2 && !isError)...[
              Align(
                alignment: Alignment.center,
                child: Loading(),
              )
            ],
            if(isError)...[
              Align(
                alignment: Alignment.center,
                child: NoData(
                  title: widget.isEditMode ? null : "Error",
                ),
              )
            ]
          ],
        ),
      ),
      bottomNavigationBar: !isReady2
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

  Future<void> _onTapSave() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(_formKey.currentState!.validate()){
      if(_cCountry.text == ''){
        ShowDialog.showErrorToast(
          desc: "${lController.getLang("text_error_required_2")} '${lController.getLang("Country")}' ");
      }else if(_cProvince.text == ''){
        ShowDialog.showErrorToast(
          desc: "${lController.getLang("text_error_required_2")} '${lController.getLang("Province")}' ");
      }else if (_cDistrict.text == ''){
        ShowDialog.showErrorToast(
          desc: "${lController.getLang("text_error_required_2")} '${lController.getLang("District")}' ");
      }else if (_cSubdistrict.text == ''){
        ShowDialog.showErrorToast(
          desc: "${lController.getLang("text_error_required_2")} '${lController.getLang("Subdistrict")}' ");
      }else if (_cZipcode.text == ''){
        ShowDialog.showErrorToast(
          desc: "${lController.getLang("text_error_required_2")} '${lController.getLang("ZIP Code")}' ");
      }else if (_cAddress.text == ''){
        _fAddress.requestFocus();
      }else if (_cFirstname.text == ''){
        _fFirstname.requestFocus();
      }else if (_cLastname.text == ''){
        _fLastname.requestFocus();
      }else if (_cPhone.text == ''){
        _fPhone.requestFocus();
      }else{
        CustomerShippingAddressModel addressModel = CustomerShippingAddressModel(
          address: _cAddress.text,
          subdistrict: model.subdistrict,
          district: model.district,
          province: model.province,
          zipcode: model.zipcode,
          country: model.country,
          shippingFirstname: _cFirstname.text,
          shippingLastname: _cLastname.text,
          telephone: _cPhone.text,
          isPrimary: 1,
          isSelected: 1,
          lat: _mapCenter.latitude,
          lng: _mapCenter.longitude,
        );
        if(widget.isEditMode){
          addressModel.id = widget.addressModel!.id;
          var res = await ApiService.processUpdate(
            'shipping-address',
            needLoading: true,
            input: { "address": addressModel }
          );
          if(res){
            await _refreshData();
            Get.back(result: {"refresh": true});
          }
        }else{
          var res = await ApiService.processCreate(
            'shipping-address',
            needLoading: true,
            input: { "address": addressModel }
          );
          if(res){
            await _refreshData();
            Get.back(result: {"refresh": true});
          }
        }
      }
    }
  }
}