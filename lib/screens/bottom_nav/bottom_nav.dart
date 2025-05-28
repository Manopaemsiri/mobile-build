import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/screens/customer/frequently_bought_products/list.dart';
import 'package:coffee2u/screens/customer/notifications/list.dart';
import 'package:coffee2u/screens/customer/order/list.dart';
import 'package:coffee2u/screens/home/home_screen.dart';
import 'package:coffee2u/screens/more/more_screen.dart';
import 'package:coffee2u/screens/update_version/read.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({
    super.key,
    this.initialTab = 0,
    this.showPopup = true
  });

  final int initialTab;
  final bool showPopup;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final CustomerController _customerController = Get.find<CustomerController>();

  late final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(showPopup: widget.showPopup),
    CustomerOrdersScreen(),
    const FrequentlyBoughtProductsScreen(),
    const NotificationScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() => _selectedIndex = widget.initialTab);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        onResumed();
        break;
      default:
    }
  }

  onResumed() async {
    final List<String> allowVersions = [];
    final res = await ApiService.processRead('mobile-check-version');
    final len = res?['result']?['versions']?.length ?? 0;
    for (var i = 0; i < len; i++) {
      allowVersions.add(res?['result']?['versions'][i].trim());
    }
    if(!allowVersions.contains(appVersion)) Get.to(() => UpdateVersionScreen(res: res ?? {}));
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if(_selectedIndex == 0){
      // _frontendController.refreshHomepage();
      // _frontendController.refreshPartnerShops(
      //   lat: _customerController.shippingAddress?.lat,
      //   lng: _customerController.shippingAddress?.lng,
      //   customerId: _customerController.customerModel?.id
      // );
    }else if(_selectedIndex == 2){
      if(!_customerController.isCustomer()){
        Get.to(() => const SignInMenuScreen());
      }else{
        _customerController.updateFrequentlyProducts();
      }
    }else if(_selectedIndex == 3){
      if(!_customerController.isCustomer()){
        Get.to(() => const SignInMenuScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseController.streamNewOrderStatuses,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firebaseController.streamNewMessages,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
            
            
            int countNotifications = 0;
            if(_customerController.isCustomer()){
              if(snapshot1.hasData && snapshot1.data!.docs.isNotEmpty){
                countNotifications = snapshot1.data!.docs.length;
              }
            }
            
            int countNewMessages = 0;
            if(_customerController.isCustomer()){
              if(snapshot2.hasData && snapshot2.data!.docs.isNotEmpty){
                countNewMessages = snapshot2.data!.docs.length;
              }
            }
        
            return Scaffold(
              body: IndexedStack(
                index: _selectedIndex,
                children: _widgetOptions,
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: kWhiteColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.article),
                    label: 'History',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_basket),
                    label: 'Frequently',
                  ),
                  BottomNavigationBarItem(
                    icon: badges.Badge(
                      showBadge: countNotifications > 0,
                      badgeStyle: const BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: kAppColor,
                      ),
                      badgeContent: Text(
                        '$countNotifications',
                        style: caption.copyWith(
                          fontSize: 12,
                          color: kWhiteColor,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      position: badges.BadgePosition.topEnd(),
                      child: const Icon(Icons.notifications),
                    ),
                    label: 'Notification',
                  ),
                  BottomNavigationBarItem(
                    icon: badges.Badge(
                      showBadge: countNewMessages > 0,
                      badgeStyle: const BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: kAppColor,
                      ),
                      badgeContent: Text(
                        '$countNewMessages',
                        style: caption.copyWith(
                          fontSize: 12,
                          color: kWhiteColor,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      position: badges.BadgePosition.topEnd(),
                      child: const Icon(Icons.more_horiz),
                    ),
                    label: 'More',
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}