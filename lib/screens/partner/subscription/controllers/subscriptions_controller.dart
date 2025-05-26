import 'package:coffee2u/apis/api_service.dart';
import 'package:get/get.dart';

import '../../../../models/index.dart';

class SubscriptionsController extends GetxController {
  SubscriptionsController();

  int stateStatus = 0;

  List<PartnerProductSubscriptionModel> _data = [];

  int _page = 0;
  bool _isLoading = false;
  bool _isEnded = false;

  List<PartnerProductSubscriptionModel> get data => _data;
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
    _data = [];
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
          _data.add(model);
        }
        _data;
        if(_data.length == paginateModel.total){
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