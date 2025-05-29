import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SalesManagersScreen extends StatefulWidget {
  const SalesManagersScreen({
    super.key,
    this.initId = '',
    required this.onPressed,
  });

  final String? initId;
  final Function(String?) onPressed;

  @override
  State<SalesManagersScreen> createState() => _SalesManagersScreenState();
}

class _SalesManagersScreenState extends State<SalesManagersScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  List<dynamic> data = [];
  TextEditingController cSearch = TextEditingController();
  FocusNode fSearch = FocusNode();
  String? selectedId;
  bool fieldIsEmpty = true;
  bool isReady = false;

  @override
  void initState() {
    setState(() => selectedId = widget.initId);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    cSearch.dispose();
    fSearch.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    try {
      List<dynamic> items = [];
      final input = {
        "dataFilter": {
          "keywords" : cSearch.text
        }
      };
      final res = await ApiService.processList('sales-managers', input: input);
      var len = res?['result'].length ?? 0;
      for (var i = 0; i < len; i++){
        items.add(res?['result'][i]);
      }
      if(mounted){
        setState(() {
          data = items;
          isReady = true;
        });
      }
    } catch (e) {
      printError(info: '$e');
      if(mounted){
        setState(() {
          data = [];
          isReady = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          title: Text(
            lController.getLang("Choose Sales Manager")
          ),
        ),
        body: CustomScrollView(
          slivers: [
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverPinnedHeader(
                  child: Container(
                    color: kWhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, 0),
                          child: TextFormField(
                            controller: cSearch,
                            focusNode: fSearch,
                            onChanged: (value) {
                              if(value.isNotEmpty){
                                setState(() {
                                  fieldIsEmpty = false;
                                });
                              }else {
                                setState(() {
                                  fieldIsEmpty = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: '${lController.getLang("Search")}...',
                              suffixIcon: fieldIsEmpty
                              ? IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: getData,  
                              )
                              : IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () => cSearch.clear(),  
                              )
                            ),
                          enableInteractiveSelection: true,
                            onFieldSubmitted: (str) => getData(),
                            textInputAction: TextInputAction.search,
                            toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              selectAll: true,
                              paste: true,
                            ),
                          ),
                        ),
                        const Gap(),
                        const Divider(height: 0, thickness: 2),
                      ],
                    ),
                  ),
                ),
                if(isReady)...[
                  SliverToBoxAdapter(
                    child: data.isEmpty
                    ? NoDataCoffeeMug()
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (c, index) {
                        dynamic d = data[index];
                        return Card(
                          child: Padding(
                            padding: kQuarterPadding,
                            child: RadioListTile<String?>(
                              value: d["_id"],
                              groupValue: selectedId,
                              onChanged: _onSelect,
                              title: Text(
                                "${d["firstname"]} ${d["lastname"]}", 
                                style: subtitle1.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              toggleable: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]else...[
                  SliverFillRemaining(child: Center(child: Loading()))
                ]
              ]
            ),
            
          ],
        ),
      ),
    );
  }

  void _onSelect(String? id) {
    setState(() => selectedId = id);
    widget.onPressed(id);
    Get.back();
  }

}