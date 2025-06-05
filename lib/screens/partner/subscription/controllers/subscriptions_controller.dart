import 'package:coffee2u/apis/api_service.dart';
import 'package:get/get.dart';

import '../../../../models/index.dart';

class SubscriptionsController extends GetxController {
  SubscriptionsController();

  int stateStatus = 0;

  List<PartnerProductSubscriptionModel> dataModel = [];

  int _page = 0;
  
  bool _isLoading = false;
  bool _isEnded = false;

  List<PartnerProductSubscriptionModel> get data => dataModel;
  bool get isLoading => _isLoading;
  bool get isEnded => _isEnded;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
  
  Future<void> onRefresh() async {
    _page = 0;
    _isLoading = false;
    _isEnded = false;
    dataModel = [];
    update();
    loadData();
  }
  Future<void> loadData() async {
    if(!_isEnded && !_isLoading){
      try {
        _page += 1;
        _isLoading = true;
        
        final res = await ApiService.processList('partner-product-subscriptions', input: {
          'paginate': {
            'page': _page,
            'pp': 26,
          }
        });
        PaginateModel paginateModel =
          PaginateModel.fromJson(res?['paginate']);

        var len = res?['result'].length;
        for(var i = 0; i < len; i++){
          PartnerProductSubscriptionModel model =
            PartnerProductSubscriptionModel.fromJson(res!['result'][i]);
          dataModel.add(model);
        }
        dataModel;
        if(dataModel.length == paginateModel.total){
          _isEnded = true;
          _isLoading = false;
        }else if(res != null){
          _isLoading = false;
        }
      } catch (_) {
        _isEnded = true;
        _isLoading = false;
      }
      update();
    }
  }
  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) await loadData();
  }
}