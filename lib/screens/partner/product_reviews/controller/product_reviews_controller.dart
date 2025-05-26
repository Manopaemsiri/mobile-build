import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/models/index.dart';
import 'package:get/get.dart';

class ProductReviewsController extends GetxController {
  final String productId;
  ProductReviewsController(this.productId);

  List<PartnerProductRatingModel> _data = [];
  List<PartnerProductRatingModel>  get data => _data;
  
  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  void onRefresh() {
    page = 0;
    isLoading = false;
    isEnded = false;
    _data = [];
    update();
    _getData();
  }

   void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) await _getData();
  }

  Future<void> _getData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        isLoading = true;
        update();
        
        final res = await ApiService.processList("partner-product-ratings", input: {
          "dataFilter": {
            'productId': productId, 
            'channel': 'C2U',
          },
          "paginate": {
            "page": page,
            "pp": 20,
          }
        });
        PaginateModel paginateModel =
            PaginateModel.fromJson(res?["paginate"]);

        var len = res?["result"].length;
        for (var i = 0; i < len; i++) {
          PartnerProductRatingModel model =
              PartnerProductRatingModel.fromJson(res!["result"][i]);
          _data.add(model);
        }
        _data;
        if (_data.length == paginateModel.total) {
          isEnded = true;
          isLoading = false;
        } else if (res != null) {
          isLoading = false;
        }
        update();
      } catch (_) {}
    }
  }
}