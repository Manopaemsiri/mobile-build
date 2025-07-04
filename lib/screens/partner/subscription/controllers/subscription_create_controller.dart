import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/subscription/checkout.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/language_controller.dart';
import '../update.dart';

/*
  type: int
    1: create
    2: update
*/
class SubscriptionCreateController extends GetxController {
  PartnerProductSubscriptionModel data;
  LanguageController lController;
  CustomerSubscriptionModel? subscription;
  int type;

  SubscriptionCreateController({
    required this.data,
    required this.lController,
    this.subscription,
    this.type = 1,
  }){
    if(type == 2) assert(subscription != null);
  }

  List<SelectionSteps> _step = [];
  List<SelectionSteps> get step => _step;

  PageController? _pageController;
  PageController? get pageController => _pageController;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool isOneTimeChange = false;

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }

  Future<void> _onInit() async {
    _pageController = PageController();
    _pageController?.addListener(() {
    if (_pageController?.hasClients == true){
      _currentPage = _pageController?.page?.round() ?? 0;
      update();
    }
  });
    try{
      _step = [ ...data.selectionSteps ];

    if (type == 2 && subscription != null && subscription!.selectionSteps.isNotEmpty) {
      for (int i = 0; i < _step.length; i++) {
        final originStep = _step[i];
        final updatedStep = subscription!.selectionSteps.firstWhereOrNull(
          (s) => s.name == originStep.name
        );

        if (updatedStep != null) {
          List<RelatedProduct> updatedProducts = [];

          for (var prod in originStep.products) {
            final matched = updatedStep.products.firstWhereOrNull(
              (p) => p.product?.id == prod.product?.id
            );

            updatedProducts.add(prod.copyWith(
              quantity: matched?.inCart ?? 0
            ));
          }

          _step[i] = originStep.copyWith(products: updatedProducts);
        }
      }
    }
    
    if (data.hasRelatedProducts == 1 && data.relatedProducts.isNotEmpty && type == 1) {
  final relatedStep = SelectionSteps(
    name: lController.getLang('Select Initial Subscription Products'),
    credit: data.relatedCredit,
    products: data.relatedProducts.map((p) {
      subscription?.relatedProducts.firstWhereOrNull(
        (k) => k.product?.id == p.product?.id,
      );

      int q = 0; 

      return p.copyWith(quantity: q);
    }).toList(),
    type: 0,
  );

  _step.insert(0, relatedStep);
}

    }catch (_){}

    
    update();
  }

  bool _validation({bool checkProductEmpty = false}) {
    bool temp = true;
    final dataProducts = _step[_currentPage].products
      .where((d) => d.quantity > 0);
    final double sumCredit = dataProducts
      .fold(0, (sum, item) => sum + (item.credit*item.quantity));
    if(sumCredit > _step[_currentPage].credit){
      ShowDialog.showErrorToast(
        desc: lController.getLang('Incorrect information')
      );
      temp = false;
    }else if(checkProductEmpty){
      final dataProducts = _step.expand((d) => d.products)
        .where((d) => d.quantity > 0).toList();
      if(dataProducts.isEmpty){
        ShowDialog.showErrorToast(
          desc: lController.getLang('Please select products')
        );
        temp = false;
      }
    }
    return temp;
  }

  nextPage() {
    final isLastPage = (_pageController?.page ?? 0) == _step.length - 1;
    final isNotLastPage = (_pageController?.page ?? 0) < _step.length - 1;
    final dataVal = _validation(checkProductEmpty: isLastPage);
    if (dataVal) {
      if (isNotLastPage) {
        _pageController?.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      } else {
        if (type == 1) {
          onSubmit();
        } else if (type == 2) {
          final updatedProducts = _step
          .expand((d) => d.products)
          .where((e) => e.quantity > 0)
          .toList();

          ShowDialog.dialogChoiceButtons(
            titleText: 'Confirm Update',
            message: '',
            confirmText: 'ทุกครั้ง',
            secondaryText: 'ครั้งเดียว',
            onConfirm: () async {
              isOneTimeChange = false;
              Get.back();
              final result = await submitUpdate();
              if (result) Get.back(result: true);
            },
            onSecondary: () async {
              isOneTimeChange = true;
              Get.back();
              final result = await submitUpdate();
              if (result) Get.back(result: true);
            },
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: updatedProducts.map((e) {
                  final product = e.product;
                  final imageUrl = product?.image?.path ?? '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 48),
                              ),
                            )
                          : const Icon(Icons.image_not_supported, size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${product?.name ?? "Unnamed"} (x${e.quantity})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ); 
        }
      }
    }
  }
  previousPage() {
    if((_pageController?.page ?? 0) == 0){
      Get.back();
    }else{
      _pageController?.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  increaseItem(int i, int productIndex) {
    SelectionSteps? temp;
    try {
      temp = _step[i];
    } catch (_) {}
    if (temp != null) {
    final product = temp.products[productIndex];

 
    final double sumCredit = temp.products
      .where((d) => d.quantity > 0)
      .fold(0, (sum, item) => sum + (item.credit * item.quantity));

 
    final bool canIncrease = sumCredit + product.credit <= temp.credit;

    if (canIncrease) {
      product.quantity += 1;
      _step[i] = temp;
      update();
    } else {
      Get.snackbar('⚠️', 'เกินจำนวนเครดิตที่กำหนดไว้');
    }
  }
  }
  decreaseItem(int i, int productIndex) {
    SelectionSteps? temp;
    try {
      temp = _step[i];
    } catch (_) {}
    if(temp != null && temp.products[productIndex].quantity > 0){
      try {
        temp.products[productIndex].quantity -= 1;
        _step[i] = temp;
        update();
      } catch (_) {}
    }
  }

  bool isCurrentStepFilled() {
  final stepData = _step[_currentPage];
  final double sumCredit = stepData.products
      .where((d) => d.quantity > 0)
      .fold(0, (sum, item) => sum + (item.credit * item.quantity));
  return (stepData.credit - sumCredit).clamp(0, double.infinity) == 0;
}
 

  @override
  void onClose() {
    _pageController?.removeListener(() { });
    _pageController?.dispose();
    _step.clear();
    super.onClose();
  }

  Future<void> onSubmit() async {
    try {
      List<Map<String, dynamic>> relatedProducts = _step
        .where((d) => d.type == 0)
        .expand((d) => d.products
          .map((e) => {
            'productId': e.product?.id,
            'unitId': e.unit?.id,
            'inCart': e.quantity,
            'addPriceInVAT': e.addPriceInVAT,
            'credit': e.credit,
          }
        )).toList();
      List<Map<String, dynamic>> dataFinalSteps = _step.where((d) => d.type == 1).map((d) {
        List<Map<String, dynamic>> dataFinalProducts = [];
        if(d.products.isNotEmpty){
          dataFinalProducts = d.products.where((e) => e.quantity > 0).map((e) {
            return {
              'productId': e.product?.id,
              'unitId': e.unit?.id,
              'inCart': e.quantity,
              'addPriceInVAT': e.addPriceInVAT,
              'credit': e.credit,
            };
          }).toList();
        }
        return {
          'name': d.name,
          'icon': d.icon?.path,
          'order': d.order,
          'credit': d.credit,
          'products': dataFinalProducts,
        };
      }).toList();
      Map<String, dynamic> dataInput = {
        'subscriptionId': data.id,
        'type': 1,
        'relatedProducts': relatedProducts,
        'selectionSteps': dataFinalSteps,
      };
  
      final res = await ApiService.processUpdate(
        'subscription-cart', 
        input: dataInput, needLoading: false
      );

      _step.expand((s) => s.products)
        .where((p) => p.quantity > 0)
        .map((p) => '- ${p.product?.name ?? 'Unnamed'} (x${p.quantity})')
        .join('\n');

      if (res == true) {
        return Get.to(() => PartnerProductSubscriptionCheckoutScreen());
      } else {
        ShowDialog.showErrorToast(
          title: lController.getLang("Error"),
          desc: lController.getLang("Could not proceed. Please try again."),
        );
      }
    } catch (_) {}
  }

 Future<bool> submitUpdate() async {
  try {
    final relatedProducts = _step
      .where((d) => d.type == 0)
      .expand((d) => d.products)
      .map((e) => {
        'productId': e.product?.id,
        'unitId': e.unit?.id,
        'inCart': e.quantity,
        'addPriceInVAT': e.addPriceInVAT,
        'credit': e.credit,
      })
    .toList();

    final dataSelectionSteps = _step
      .where((d) => d.type == 1)
      .map((d) => {
        'name': d.name,
        'credit': d.credit,
        'products': d.products
          .map((e) => {
            'productId': e.product?.id,
            'unitId': e.unit?.id,
            'inCart': e.quantity,
            'addPriceInVAT': e.addPriceInVAT,
            'credit': e.credit,
          })
        .toList(),
      })
    .toList();

    final dataInput = {
      '_id': subscription?.id,
      'selectType': isOneTimeChange ? 1 : 0,
      'selectionSteps': dataSelectionSteps,
      if (relatedProducts.isNotEmpty) 'relatedProducts': relatedProducts,
      if ((subscription?.relatedCredit ?? 0) > 0)
        'relatedCredit': subscription?.relatedCredit,
    };

    final res = await ApiService.processUpdate(
      'subscription',
      input: dataInput,
      needLoading: true,
    );

    if (res == true) { 
      return true;
    } else {
      ShowDialog.showForceDialog(
        '', 'Update failed',() => Get.back(),
      );
      return false;
    }
  } catch (e) {
   ShowDialog.showForceDialog(
      '', 'Update error: ${e.toString()}', () => Get.back(),
    );
    return false;
  }
}

}