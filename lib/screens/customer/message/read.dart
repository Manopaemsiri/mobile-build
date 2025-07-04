import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/message/components/app_bar_message.dart';
import 'package:coffee2u/screens/customer/message/components/message_chat.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.model
  });

  final CustomerChatroomModel model;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final FirebaseController controllerFirebase = Get.find<FirebaseController>();

  final TextEditingController _textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isSending = false;
  bool showAsset = true;
  ImagePicker imagePicker = ImagePicker();

  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    controllerFirebase.readMessage(widget.model);
  }

  @override
  void dispose() {
    focusNode.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarMessage(model: widget.model),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controllerFirebase.subscribeChatroom(
                  widget.model.firebaseChatroomId
                ),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return NoDataCoffeeMug(
                      titleText: 'No messages',
                    );
                  } else {
                    List<Map<String, dynamic>> dataModel = [];
                    List<dynamic> widgetList = snapshot.data?.docs ?? [];
                    int len = widgetList.length;
                    for(var i=0; i<len; i++){
                      var tempData = widgetList[i].data();
                      dataModel.add({
                        "text": tempData["text"] ?? '',
                        "images": tempData["images"] ?? [],
                        "sender": tempData["sender"] ?? {},
                        "fromCustomer": tempData["fromCustomer"] == null
                          ? false: tempData["fromCustomer"].toString() == 'true',
                        "createdAt": tempData["createdAt"] == null
                          ? DateTime.now(): DateTime.parse(tempData["createdAt"])
                      });
                    }

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        kGap, kGap, kGap, 0
                      ),
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: dataModel.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> d = dataModel[index];
                          bool showAvatar = true;
                          bool showPaddingTop = false;
                          if(index > 0){
                            Map<String, dynamic> n = dataModel[index-1];
                            if((d["fromCustomer"] == true && n['fromCustomer'] == false) 
                            || d["fromCustomer"] == true 
                            || (d["fromCustomer"] == false && n['fromCustomer'] == false)){
                              showAvatar = false;
                            }
                            if(d["fromCustomer"] != n['fromCustomer']){
                              showPaddingTop = true;
                              
                            }
                          }

                          return MessageChat(
                            model: d,
                            showAvatar: showAvatar,
                            partnerShop: widget.model.partnerShop,
                            showPaddingTop: showPaddingTop,
                          );
                        },
                      ),
                    );
                  }
                }
              ),
            ),
            Container(
              padding: kHalfPadding,
              decoration: const BoxDecoration(
                color: kWhiteColor,
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if(!isSending)...[
                      if(showAsset)...[
                        const Gap(gap: kHalfGap),
                        GestureDetector(
                          onTap: onTakeAPhoto,
                          child: const Icon(
                            FontAwesomeIcons.camera,
                            color: kAppColor,
                          ),
                        ),
                        const Gap(gap: kGap),
                        GestureDetector(
                          onTap: onPickImage,
                          child: const Icon(
                            FontAwesomeIcons.image,
                              color: kAppColor
                          ),
                        ),
                        const Gap(gap: kGap),
                      ]else...[
                        const Gap(gap: kHalfGap),
                        GestureDetector(
                          onTap: () {
                            if(mounted) setState(() => showAsset = true);
                          },
                          child: const Icon(
                            FontAwesomeIcons.chevronRight,
                              color: kAppColor
                          ),
                        ),
                        const Gap(gap: kGap),
                      ]
                    ],
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: kGap),
                        decoration: BoxDecoration(
                          color: kAppColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _textController,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: '${lController.getLang("Type message")}...',
                                  border: InputBorder.none,
                                ),
                                enabled: !isSending,
                                onChanged: (str) {
                                  if(mounted) setState(() => showAsset = false);
                                },
                                onTap: () {
                                  if(mounted) setState(() => showAsset = false);
                                },
                              ),
                            ),
                            isSending
                            ? const Padding(
                              padding: EdgeInsets.only(right: kGap),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                            : IconButton(
                              icon: const Icon(
                                Icons.send_rounded,
                                color: kAppColor
                              ),
                              splashRadius: 1.5*kGap,
                              splashColor: kAppColor.withAlpha(100),
                              onPressed: _onSendMessage,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendMessage() async {
    if(_textController.text != '' && !isSending){
      setState((){
        isSending = true;
      });
      await controllerFirebase.sendMessage(
        widget.model,
        text: _textController.text
      );
      _textController.clear();
      setState((){
        isSending = false;
      });
    }
  }

  Future<void> onTakeAPhoto() async {
    final temp = await imagePicker.pickImage(source: ImageSource.camera);
    if(temp != null && !isSending && mounted){
      setState(() => isSending = true);
      final  images = await uploadImages([temp]);
      if(images != null){
        await controllerFirebase.sendMessage(
          widget.model,
          images: images
        );
      }
      setState(()=> isSending = false);
    }
  }

  Future<void> onPickImage() async {
    final temp = await imagePicker.pickMultiImage();
    if(temp.isNotEmpty && !isSending && mounted){
      setState(() => isSending = true);
      final images = await uploadImages(temp);
      if(images != null){
        await controllerFirebase.sendMessage(
          widget.model,
          images: images
        );
      }
      setState(()=> isSending = false);
    }
  }

  Future<List<String>?> uploadImages(List<XFile> items) async {
    List<FileModel>? files = await ApiService.uploadMultipleFile(
      items,
      needLoading: false,
      folder: 'chats',
      resize: 1500,
    );
    if(files != null){
      return files.map((e) => e.path).toList();
    }

    return null;
  }

}