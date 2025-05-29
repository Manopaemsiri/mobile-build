import 'package:get/get.dart';

import '../../../../apis/api_service.dart';
import '../../../../models/index.dart';

class PartnerShopFilterController extends GetxController {
  PartnerShopFilterController({
    this.categoryId, 
    this.eventId,
    this.showSubCategory = false,
    this.initCategories = const [],
    this.initSubCategories = const [],
    this.initBrands = const [],
    this.initProductTags = const [],
    this.shopId,
  });
  final String? categoryId;
  final String? eventId;
  final bool showSubCategory;
  final List<dynamic> initCategories;
  final List<String> initSubCategories;
  final List<String> initBrands;
  final List<String> initProductTags;
  final String? shopId;

  bool loading = true;

  List<PartnerProductBrandModel> _brands = [];
  List<PartnerProductSubCategoryModel> _subCategories = [];
  List<Map<String, dynamic>> _categories = [];
  List<String> _productTags = [];
  List<String> _selectedBrands = [];
  List<String> _selectedSubCategories = [];
  List<Map<String, dynamic>> _selectedCategories = [];
  List<String> _selectedProductTags = [];

  List<PartnerProductBrandModel> get brands => _brands;
  List<Map<String, dynamic>> get categories => _categories;
  List<PartnerProductSubCategoryModel> get subCategories => _subCategories;
  List<String> get productTags => _productTags;
  
  List<String> get selectedBrands => _selectedBrands;
  List<String> get selectedSubCategories => _selectedSubCategories;
  List<Map<String, dynamic>> get selectedCategories => _selectedCategories;
  List<String> get selectedProductTags => _selectedProductTags;
  
  @override
  void onInit() {
    super.onInit();
    if(initBrands.isNotEmpty) _selectedBrands = List.from(initBrands);
    if(initCategories.isNotEmpty) _selectedCategories = List.from(initCategories);
    if(initSubCategories.isNotEmpty) _selectedSubCategories = List.from(initSubCategories);
    if(initProductTags.isNotEmpty) _selectedProductTags = List.from(initProductTags);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      categoryId?.isEmpty == true
        ? _loadCategoriesMain()
        : _loadSubCategories(),
      _loadBrands(),
      _loadProductTags(),
    ]);
    loading = false;
    update();
  }
  
  Future<void> _loadBrands() async {
    List<PartnerProductBrandModel> items = [];
    try {
      Map<String, dynamic> input = {
        'dataFilter': { 'categoryId': categoryId }
      };
      if(eventId != null) input['dataFilter']['eventId'] = eventId;
      final Map<String, dynamic>? res = await ApiService.processList('partner-product-brands', input: input);
      if(res?['result'] != null){
        final length = res?['result'].length ?? 0;
        for (var i = 0; i < length; i++) {
          items.add(PartnerProductBrandModel.fromJson(res?['result'][i]));
        }
      }
    } catch (e) {
      items = [];
    }
    _brands = items;
  }

  Future<void> _loadCategoriesMain() async {
    await _loadCategories();
    await _loadCategoryGroups();
  }
  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> items = [];
    try {
      Map<String, dynamic> input = {'dataFilter': {}};
      if(shopId != null && shopId?.isNotEmpty == true) input['dataFilter']['partnerShopId'] = shopId;
      final Map<String, dynamic>? res = await ApiService.processList('partner-product-categories', input: input);
      if(res?['result'] != null){
        final length = res?['result'].length ?? 0;
        for (var i = 0; i < length; i++) {
          PartnerProductCategoryModel model = PartnerProductCategoryModel.fromJson(res?['result'][i]);
          Map<String, dynamic> temp = {
            'id': model.id, 
            'name': model.name,
            'order': model.order
          };
          items.add(temp);
        }
      }
    } catch (e) {
      items = [];
    }
    _categories = items;
  }
  Future<void> _loadCategoryGroups() async {
    List<Map<String, dynamic>> items = [];
    try {
      Map<String, dynamic> input = {'dataFilter': {}};
      if(shopId != null && shopId?.isNotEmpty == true) input['dataFilter']['partnerShopId'] = shopId;
      final Map<String, dynamic>? res = await ApiService.processList('partner-product-category-groups', input: input);
      if(res?['result'] != null){
        final length = res?['result'].length ?? 0;
        for (var i = 0; i < length; i++) {
          PartnerProductCategoryGroupModel model =
            PartnerProductCategoryGroupModel.fromJson(res?['result'][i]);
          Map<String, dynamic> temp = {
            'id': model.id, 
            'name': model.name,
            'categories': model.categories.map((e) => e.id).toList(),
            'order': model.order
          };
          items.add(temp);
        }
      }
    } catch (e) {
      items = [];
    }
    _categories = mapAndFilterCategories(_categories, items);
  }
  
  List<Map<String, dynamic>> mapAndFilterCategories(List<Map<String, dynamic>> listA, List<Map<String, dynamic>> listB) {
    Set<String?> categoryIdsInListB = listB
        .expand((item) => item['categories'] as List<String?>)
        .toSet();

    List<Map<String, dynamic>> result = listA
        .where((itemA) => !categoryIdsInListB.contains(itemA['id']))
        .toList();

    result.addAll(listB);
    result.sort((a, b) => a['order'].compareTo(b['order']));
    return result;
  }

  Future<void> _loadSubCategories() async {
    List<PartnerProductSubCategoryModel> items = [];
    if(showSubCategory && categoryId != null){
      try {
        final Map<String, dynamic>? res = await ApiService.processList('partner-product-sub-categories', input: {
          'dataFilter': { 'categoryId': categoryId }
        });
        if(res?['result'] != null){
          final length = res?['result'].length;
          for(var i = 0; i < length; i++){
            items.add(PartnerProductSubCategoryModel.fromJson(res?['result'][i]));
          }
        }
      } catch (e) {
        items = [];
      }
    }
    _subCategories = items;
  }
  
  Future<void> _loadProductTags() async {
    List<String> items = [];
    try {
      Map<String, dynamic> input = { 'dataFilter': {} };
      if(categoryId?.isNotEmpty == true) input['dataFilter']['categoryId'] = categoryId;
      if(eventId?.isNotEmpty == true) input['dataFilter']['eventId'] = eventId;
      final Map<String, dynamic>? res = await ApiService.processList('partner-product-tags', input: input);
      if(res?['result'] != null){
        final length = res?['result'].length;
        for(var i = 0; i < length; i++) {
          items.add(res?['result'][i]);
        }
      }
    } catch (e) {
      items = [];
    }
    _productTags = items;
  }
  
  void onSelectBrand(PartnerProductBrandModel item) {
    if(item.id != null){
      _selectedBrands = _onAddItem(_selectedBrands, item.id!).cast<String>();
      update();
    }
  }

  void onSelectCategory(Map<String, dynamic> item) {
    if(item['id'] != null){
      int existingIndex = _selectedCategories.indexWhere((element) => element['id'] == item['id']);
      if (existingIndex != -1) {
        _selectedCategories.removeAt(existingIndex);
      } else {
        _selectedCategories.add(item);
      }
    }
    update();
  }

  void onSelectSubCategory(PartnerProductSubCategoryModel item) {
    if(item.id != null){
      _selectedSubCategories = _onAddItem(_selectedSubCategories, item.id!).cast<String>();
      update();
    }
  }

  onSelectProductTags(String item){
    if(item.isNotEmpty){
      _selectedProductTags = _onAddItem(_selectedProductTags, item).cast<String>();
      update();
    }
  }

  List<dynamic> _onAddItem(List<String> list, String item) {
    List<dynamic> temp= list;
    if (temp.contains(item)) {
      temp.remove(item);
    }else{
      temp.add(item);
    }
    return temp;
  }

  void clearFilter() {
    _selectedCategories = [];
    _selectedSubCategories = [];
    _selectedBrands = [];
    _selectedProductTags = [];
    update();
  }
}