import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final AppController _appController = Get.find<AppController>();
  late final CustomerController customerController = Get.find<CustomerController>();
  
  // Form Key
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _cFirstname = TextEditingController();
  final TextEditingController _cLastname = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cCode = TextEditingController();
  final TextEditingController _cCustomerType = TextEditingController();
  final TextEditingController _cTelephone = TextEditingController();
  
  final FocusNode _fLastname = FocusNode();
  final FocusNode _fEmail = FocusNode();
  
  // Avatar
  ImagePicker picker = ImagePicker();
  XFile imageFile = XFile('');
  bool isPicked = false;
  String path = '';

  @override
  void initState() {
    _initState();
    super.initState();
  }
  Future<void> _initState() async {
    await _appController.getSetting();
    path = customerController.customerModel?.avatar?.path ?? '';
    _cFirstname.text = customerController.customerModel?.firstname ?? '';
    _cLastname.text = customerController.customerModel?.lastname ?? '';
    _cEmail.text = customerController.customerModel?.email ?? '';
    _cCode.text = customerController.customerModel?.code ?? '';
    _cCustomerType.text = customerController.customerModel?.group?.name ?? '';
    _cTelephone.text = customerController.customerModel?.telephone ?? '';
    if(mounted) setState(() {});
  }

  @override
  void dispose() {
    _cFirstname.dispose();
    _cLastname.dispose();
    _cEmail.dispose();
    _cCode.dispose();
    _cCustomerType.dispose();
    _cTelephone.dispose();
    _fLastname.dispose();
    _fEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Profile")),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: kPadding,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              const SizedBox(height: kHalfGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(
                            () => Scaffold(
                              extendBodyBehindAppBar: true,
                              appBar: AppBar(
                                systemOverlayStyle: const SystemUiOverlayStyle(
                                  statusBarColor: Colors.transparent,
                                  statusBarBrightness: Brightness.dark,
                                  statusBarIconBrightness: Brightness.light,
                                ),
                                backgroundColor: Colors.black,
                                foregroundColor: kWhiteColor,
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: kWhiteColor,
                                      size: 32,
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                              body: Center(
                                child: Container(
                                  decoration: const BoxDecoration(color: kDarkColor),
                                  child: PhotoView(
                                    imageProvider: NetworkImage(
                                      imageFile.path != '' && isPicked
                                        ? imageFile.path: path,
                                    ),
                                  )
                                ),
                              ),
                            ),
                            transition: Transition.downToUp,
                            fullscreenDialog: true,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kAppColor, width: 3.0),
                          ),
                          child: ImageProfileCircle(
                            imageUrl: imageFile.path != '' && isPicked
                              ? imageFile.path: path,
                            isFile: imageFile.path != '' && isPicked,
                            size: 80,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            final _file = await picker.pickImage(source: ImageSource.gallery);
                            if(_file != null){
                              setState((){
                                imageFile = _file;
                                isPicked = true;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: kAppColor, width: 2.0)
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                CupertinoIcons.photo_camera_solid,
                                size: 20,
                                color: kAppColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: kGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    text: lController.getLang("First Name"),
                  ),
                  const SizedBox(height: kHalfGap),
                  TextFormField(
                    controller: _cFirstname,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (str) => _fLastname.requestFocus(),
                  ),

                  const SizedBox(height: kGap),
                  LabelText(
                    text: lController.getLang("Last Name"),
                  ),
                  const SizedBox(height: kHalfGap),
                  TextFormField(
                    controller: _cLastname,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (str) => _fEmail.requestFocus(),
                  ),
                  
                  const SizedBox(height: kGap),
                  LabelText(
                    text: lController.getLang("Email"),
                  ),
                  const SizedBox(height: kHalfGap),
                  TextFormField(
                    controller: _cEmail,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
                  ),
                  
                  const SizedBox(height: kGap),
                  LabelText(
                    text: lController.getLang("Customer Code"),
                  ),
                  const SizedBox(height: kHalfGap),
                  TextFormField(
                    controller: _cCode,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: kGrayLightColor,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    enabled: false,
                  ),

                  if(_appController.enabledCustomerGroup && _cCustomerType.text.isNotEmpty)...[
                    const SizedBox(height: kGap),
                    LabelText(
                      text: lController.getLang("Customer Type"),
                    ),
                    const SizedBox(height: kHalfGap),
                    TextFormField(
                      controller: _cCustomerType,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: kGrayLightColor,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      ),
                      enabled: false,
                    ),
                  ],
                  
                  const SizedBox(height: kGap),
                  LabelText(
                    text: lController.getLang("Telephone Number"),
                  ),
                  const SizedBox(height: kHalfGap),
                  TextFormField(
                    controller: _cTelephone,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: kGrayLightColor,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    enabled: false,
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<CustomerController>(builder: (controller) {
        return Padding(
          padding: kPaddingSafeButton,
          child: ButtonFull(
            color: kAppColor,
            title: lController.getLang("Save"),
            onPressed: () => _onSubmit(customerController),
          ),
        );
      })
    );
  }

  void _onSubmit(CustomerController _controller) async {
    FileModel? _avatar;
    if(isPicked){
      FileModel _file = await ApiService.uploadFile(
        imageFile,
        needLoading: true,
        folder: 'avatars',
        resize: 250,
      );
      if(_file.isValid()) _avatar = _file;
    }

    Map<String, dynamic> _input = {
      "firstname": _cFirstname.text,
      "lastname": _cLastname.text,
      "email": _cEmail.text,
    };
    if(_avatar != null) _input["avatar"] = _avatar;
    bool res = await ApiService.processUpdate(
      'account',
      input: _input,
      needLoading: true,
    );
    if(res){
      _controller.updateCustomerAccount(
        firstname: _cFirstname.text,
        lastname: _cLastname.text,
        email: _cEmail.text,
        avatar: _avatar,
      );
      ShowDialog.showSuccessToast(
        title: lController.getLang("Successed"),
        desc: lController.getLang('text_edit_profile_1')
      );
    }
  }
}