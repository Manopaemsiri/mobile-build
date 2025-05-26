import 'package:coffee2u/apis/api_service.dart';
import 'package:get/get.dart';

import '../../../../models/index.dart';

class CustomerSubscriptionController extends GetxController {
  final String id;
  CustomerSubscriptionController({required this.id});

  int stateStatus = 0;

  CustomerSubscriptionModel? _data;
  CustomerSubscriptionModel? get data => _data;

  late List<PartnerProductModel> _relatedProducts = [];
  List<PartnerProductModel> get relatedProducts => _relatedProducts;
  late final List<PartnerProductModel> _products = [];
  List<PartnerProductModel> get products => _products;

  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  Future<void> _onInit() async {
    try {
      final res = await ApiService.processRead('subscription', input: { '_id': id });
      if(res?['result']?.isNotEmpty){
        _data = CustomerSubscriptionModel.fromJson(res?['result']);
        await Future.wait([
          _getRelatedProducts(),
          _getproducts(),
        ]);
        stateStatus = 1;
        update();
        return;
      }
    } catch (_) {}
    stateStatus = 3;
    update();
    return;
  }

  Future<void> _getRelatedProducts() async {
    _relatedProducts = (_data?.relatedProducts ?? [])
    .where((d) => d.quantity > 0)
    .map((d) {
      PartnerProductModel k = d.product!;
      k.inCart = d.quantity;
      k.addPriceInVAT = d.addPriceInVAT > 0? d.addPriceInVAT: 0;
      return k;
    })
    .toList();
  }
  
  Future<void> _getproducts() async {
  List<RelatedProduct> _steps = (_data?.selectionSteps ?? [])
      .map((d) => d.products)
      .expand((d) => d)
      .where((d) => d.inCart > 0)
      .toList();

  final List<PartnerProductModel> _p = _steps.map((d) {
    PartnerProductModel k = d.product!;
    k.inCart = d.inCart;
    k.addPriceInVAT = d.addPriceInVAT > 0 ? d.addPriceInVAT : 0;
    return k;
  }).toList();

  _products
    ..clear()
    ..addAll(_p);
}

  Future<void> getDataAgain() async {
    try {
      stateStatus = 0;
      update();

      final res = await ApiService.processRead('subscription', input: { '_id': id });

      if (res?['result'] != null) {
        _data = CustomerSubscriptionModel.fromJson(res?['result']);

        _relatedProducts.clear(); 
        _products.clear();

        await Future.wait([
          _getRelatedProducts(),
          _getproducts(),
        ]);

        stateStatus = 1;
      } else {
        stateStatus = 2;
      }

      update();
    } catch (e) {
      print('❌ getDataAgain error: \$e');
      stateStatus = 3;
      update();
    }
  }


}