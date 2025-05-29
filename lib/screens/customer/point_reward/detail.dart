import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steps_indicator/steps_indicator.dart';

class PointRewardDetailScreen extends StatefulWidget {
  const PointRewardDetailScreen({
    super.key,
  });

  @override
  State<PointRewardDetailScreen> createState() => _PointRewardDetailScreenState();
}

class _PointRewardDetailScreenState extends State<PointRewardDetailScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isLoading = true;
  CustomerTierModel _tier = CustomerTierModel();
  List<CustomerTierModel> _tiers = [];
  int _stepIndex = 0;

  _initState() async {
    var res1 = await ApiService.processRead('tier');
    CustomerTierModel tier = CustomerTierModel.fromJson(res1!['result']['data']);
    _tier = tier;
        
    var res2 = await ApiService.processList('customer-tiers');
    if(res2!['result'] != null){
      List<CustomerTierModel> temp = [];
      int len = res2['result'].length;
      for(int i=0; i<len; i++){
        temp.add(CustomerTierModel.fromJson(res2['result'][i]));
      }
      _tiers = temp;
      _stepIndex = temp.indexWhere((d) => d.id == tier.id) + 1;
    }
    
    if(mounted) setState(() => isLoading = false);
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lController.getLang("Customer Tier")),
        elevation: 1,
      ),
      body: isLoading
        ? Center(child: Loading())
        : ListView(
          padding: kPadding,
          physics: const RangeMaintainingScrollPhysics(),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  padding: const EdgeInsets.only(top: kGap),
                  child: StepsIndicator(
                    isHorizontal: false,
                    selectedStep: _stepIndex,
                    nbSteps: _tiers.length,
                    selectedStepColorOut: kAppColor,
                    selectedStepColorIn: kAppColor,
                    doneStepColor: kAppColor,
                    doneLineColor: kAppColor,
                    undoneLineColor: Colors.grey.shade300,
                    lineLength: 113.5,
                    doneLineThickness: 5,
                    undoneLineThickness: 5,
                    enableLineAnimation: true,
                    enableStepAnimation: true,
                    doneStepWidget: const Icon(
                      Icons.check_circle,
                      color: kAppColor,
                      size: 21,
                    ),
                    unselectedStepWidget: Icon(
                      Icons.circle,
                      color: Colors.grey.shade300,
                      size: 21,
                    ),
                    selectedStepWidget: Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: kOtGap),
                Expanded(
                  child: Column(
                    children: [
                      ..._tiers.map((CustomerTierModel dataModel){
                        return _customerTier(dataModel);
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: kGap),
            Text(
              '*** ${lController.getLang("text_point_1")} ***',
              textAlign: TextAlign.center,
              style: subtitle2.copyWith(
                color: kDarkLightColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
    );
  }

  Widget _customerTier(CustomerTierModel model) {
    double boxSize = 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(kOtGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: title.copyWith(
                    color: model.id == _tier.id 
                      ? kAppColor: kDarkLightColor,
                    fontFamily: "CenturyGothic",
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: kOtGap),
                Row(
                  children: [
                    SizedBox(
                      width: boxSize,
                      child: AspectRatio(
                        aspectRatio: 16/10,
                        child: ImageUrl(
                          imageUrl: model.icon?.path ?? '',
                          fit: BoxFit.contain
                        ),
                      ),
                    ),
                    const SizedBox(width: kOtGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${lController.getLang("Earn 1 point every")} ${priceFormat(model.pointEarnRate, lController, digits: 0, trimDigits: true)} ${lController.getLang("spent")}',
                            style: subtitle2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: kDarkLightColor,
                            ),
                          ),
                          Text(
                            '${lController.getLang("Minimum Purchase")} ${priceFormat(model.minOrderMonthly, lController, digits: 0, trimDigits: true)} ${lController.getLang("per month")}',
                            style: subtitle2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: kGrayColor,
                            ),
                          ),
                          Text(
                            '${lController.getLang("or")} ${priceFormat(model.minOrderMonthly*12, lController, digits: 0, trimDigits: true)} ${lController.getLang("per year")}',
                            style: subtitle2.copyWith(
                              fontWeight: FontWeight.w400,
                              color: kGrayColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: kQuarterGap),
      ],
    );
  }
}