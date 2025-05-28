import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/order/components/order_item.dart';
import 'package:coffee2u/screens/customer/order/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';


class OrderList extends StatefulWidget {
  const OrderList({
    super.key,
    required this.order,
    this.trimDigits = false
  });
  final int order;
  final bool trimDigits;

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final LanguageController lController = Get.find<LanguageController>();
  List<CustomerOrderModel> dataModel = [];

  late bool trimDigits = widget.trimDigits;
  int page = 0;
  bool isLoading = false;
  bool isEnded = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> onRefresh() async {
    setState(() {
      page = 0;
      isLoading = false;
      isEnded = false;
      dataModel = [];
    });
    loadData();
  }

  Future<void> loadData() async {
    if (!isEnded && !isLoading) {
      try {
        page += 1;
        setState(() {
          isLoading = true;
        });

        ApiService.processList("orders", input: {
          "paginate": { "page": page, "pp": 10 },
          "dataFilter": {
            "shippingStatus": widget.order > 0? widget.order: '',
          }
        }).then((value) {
          PaginateModel paginateModel = PaginateModel.fromJson(value?["paginate"]);

          var len = value?["result"].length;
          for (var i = 0; i < len; i++) {
            CustomerOrderModel model = CustomerOrderModel.fromJson(value!["result"][i]);
            dataModel.add(model);
          }

          if(mounted){
            setState(() {
              dataModel;
              if(dataModel.length >= paginateModel.total!){
                isEnded = true;
                isLoading = false;
              }else if(value != null){
                isLoading = false;
              }
            });
          }
        });
      }catch(e){ if(kDebugMode) printError(info: '$e'); }
    }
  }

  void onLoadMore(info) async {
    if (info.visibleFraction > 0 && !isEnded && !isLoading) {
      await loadData();
    }
  }

  Widget loaderWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Loading(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: kAppColor,
      child: SingleChildScrollView(
        child: isEnded && dataModel.isEmpty
          ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child:  Center (
              child: NoDataCoffeeMug(),
            ),
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dataModel.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: List.generate(dataModel.length, (index) {
                      CustomerOrderModel item = dataModel[index];
                      return OrderItem(
                        model: item,
                        onTap: () => Get.to(() => CustomerOrderScreen(
                          orderId: item.id ?? '',
                        )), 
                        lController: lController,
                        trimDigits: trimDigits
                      );
                    }),
                  ),
              if(isEnded && dataModel.isNotEmpty) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.5*kGap, bottom: kGap),
                    child: Text(
                      lController.getLang("No more data"),
                      textAlign: TextAlign.center,
                      style: title.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kGrayColor,
                      ),
                    ),
                  ),
                )
              ],
              if(!isEnded) ...[
                VisibilityDetector(
                  key: const Key('loader-widget'),
                  onVisibilityChanged: onLoadMore,
                  child: loaderWidget(),
                ),
              ],
              const SizedBox(height: kGap),
            ],
          ),
      ),
    );
  }
}
