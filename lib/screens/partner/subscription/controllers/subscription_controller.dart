import 'package:coffee2u/apis/api_service.dart';
import 'package:get/get.dart';
import '../../../../models/index.dart';

class SubscriptionController extends GetxController {
  final String id;
  SubscriptionController({required this.id});

  int stateStatus = 0;

  PartnerProductSubscriptionModel? dataModel;
  PartnerProductSubscriptionModel? get data => dataModel;

  String? _signature;
  String? get signature => _signature;

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }

  Future<void> _onInit() async {
    stateStatus = 0;

    try {

      final res = await ApiService.processRead('partner-product-subscription', input: { '_id': id });

      if (res?['result']?.isNotEmpty == true) {
        PartnerProductSubscriptionModel model = PartnerProductSubscriptionModel.fromJson(res?['result']);
        dataModel = model;
        stateStatus = model.isValid() ? 1 : 2;

        await _fetchSignature(model.id);

        update();
        return;
      }
    } catch (e) {
      print('Error loading subscription: $e');
    }

    stateStatus = 3;
    update();
  }

  Future<void> _fetchSignature(String subscriptionId) async {
    try {
      final res = await ApiService.processRead('customer-signature', input: {
        'subscriptionId': subscriptionId
      });

      if (res?['result']?.isNotEmpty == true) {
        CustomerSubscriptionModel model = CustomerSubscriptionModel.fromJson(res?['result']);
        _signature = model.signature;

        print('Signature loaded: $_signature');
      }
    } catch(e) {
      print('Error loading signature: $e');
    }
  }
}
