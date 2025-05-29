import 'package:get/get.dart';

class PartnerShopSortontroller extends GetxController {
  PartnerShopSortontroller({this.initSortKey});
  final Map<String, dynamic>? initSortKey;

  late Map<String, dynamic> _sortKey = { 'name': 'desc-sales-count', 'value': 'desc-salesCount' };
  final List<Map<String, dynamic>> _sortings = [];

  Map<String, dynamic> get sortKey => _sortKey;
  List<Map<String, dynamic>> get sortings => _sortings;

  @override
  void onInit() {
    super.onInit();
    if(initSortKey != null) _sortKey = initSortKey!;
    _loadData();
  }

  Future<void> _loadData() async {
    _getSortingList();
    update();
  }
  
  Future<void> _getSortingList() async {
    _sortings.add({ 'name': 'desc-sales-count', 'value': 'desc-salesCount' });
    _sortings.add({ 'name': 'asc-name', 'value': 'asc-name' });
    _sortings.add({ 'name': 'desc-name', 'value': 'desc-name' });

    _sortings.add({ 'name': 'asc-price', 'value': 'asc-priceInVAT' });
    _sortings.add({ 'name': 'desc-price', 'value': 'desc-priceInVAT' });

    _sortings.add({ 'name': 'asc-price-per-weight', 'value': 'asc-memberPricePerWeight' });
    _sortings.add({ 'name': 'desc-price-per-weight', 'value': 'desc-memberPricePerWeight' });

    _sortings.add({ 'name': 'asc-rating', 'value': 'asc-rating' });
    _sortings.add({ 'name': 'desc-rating', 'value': 'desc-rating' });
  }

  void onSelectSorting(Map<String, dynamic> item) {
    if(item['value'] != null){
      _sortKey = item;
      update();
    }
  }
}