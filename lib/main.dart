import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/Shop_Layout.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopCubit.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopStates.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/remote/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'modules/shop_app/Login/LoginShopScreen.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //هاي ميثود بتضمن الي قبل main يطبق بعدها بشتغل runApp

  //Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  dynamic isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;
  dynamic onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');//بخزنه في cons

  if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = LoginShopScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final dynamic isDark;
  final Widget startWidget;

  //
  MyApp({required this.isDark, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ShopCubit()..getfavorites()..getHomeData()..getcategories()..getUserData(),
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, states) {},
          builder: (context, states) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ligthTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.light,
              // themeMode: NewsCubit.get(context).isDark
              //     ? ThemeMode.dark
              //     : ThemeMode.light,
              home: startWidget,
            );
          },
        ),);
  }
}
