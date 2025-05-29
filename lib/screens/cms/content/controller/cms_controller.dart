import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:get/get.dart';

class CmsContentController extends GetxController {
  CmsContentController(this.url);
  final String? url;

  // final LanguageController lController = Get.find<LanguageController>();
  CmsContentModel? dataModel;
  final List<FileModel> _gallery = [];


  bool _isReady = false;
  final bool _trimDigits = true;
  final AppController controllerApp = Get.find<AppController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  final LanguageController _lController = Get.find<LanguageController>();

  CmsContentModel? get data => dataModel;
  List<FileModel>? get gallery => _gallery;
  bool get isReady => _isReady;
  bool get trimDigits => _trimDigits;
  AppController get appController => controllerApp;
  CustomerController get customerController => controllerCustomer;
  LanguageController get lController => _lController;


  @override
  void onInit() {
    _initState();
    super.onInit();
  }

  _initState() async {
    CmsContentModel? item;
    if(url?.isNotEmpty == true){
      final input = { "url": url };
      if(controllerCustomer.partnerShop != null && controllerCustomer.partnerShop?.type != 9) {
        if(controllerCustomer.partnerShop?.isValid() == true) input['partnerShopId'] = controllerCustomer.partnerShop!.id!;
      }else {
        input['partnerShopCode'] = "CENTER";
      }
      Map<String, dynamic>? res1 = await ApiService.processRead(
        "cms-content",
        input: input,
      );
      if(res1?["result"] != null && res1?["result"]?.isNotEmpty == true){
        item = CmsContentModel.fromJson(res1!["result"]);
      }
    }
    if(item?.isValid() == true){
      dataModel = item;

      if (dataModel?.image != null && dataModel?.image!.path != null) {
        _gallery.add(dataModel!.image!);
      }
      if (dataModel?.gallery != null) {
        dataModel?.gallery?.forEach((d) {
          if(d.path.isNotEmpty) _gallery.add(d);
        });
      }
    }else {
      dataModel = null;
    }
    _isReady = true;
    update();
  }
}