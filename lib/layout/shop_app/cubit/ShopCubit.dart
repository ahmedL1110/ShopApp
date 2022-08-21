import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopStates.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/models/shop_app/change_favorites_model.dart';
import 'package:shop_app/models/shop_app/favorites_model.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/models/shop_app/login_models.dart';
import 'package:shop_app/modules/shop_app/categories/categories_screen.dart';
import 'package:shop_app/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shop_app/modules/shop_app/products/products_screen.dart';
import 'package:shop_app/modules/shop_app/settings/settings_screen.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreen = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen()
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.in_favorites,
        });
      });
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getcategories() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[
        productId]!; //عشان يغير لحظي قبل ما يرسل الداتا الي ما تبين للمستخدم
    emit(
        ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      if(value.data['status'])getfavorites();//حطيتها هنا لتسريع العمل
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if(!changeFavoritesModel!.status){//لو رجع ست ايرو وقتها في مشكلة
        favorites[productId] = !favorites[
        productId]!;//بحالة صار ايروو وما وصل الى توتيكت الى اي سبب كان وقتها اقلب ورجع ثاني بسرعة
      }//else{
      //   getfavorites();//بحالة كان صح وغيرت يعمل في واجهة فيوريت استعاد من جديد عشان لودنج
      // }//عشان ما بنفع اعمل لودنج على انو فاضي او لا لانو دايما مش فاضي بس بصير عليه تغيرات بناء على تشينج هنا لو كان صح
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[
      productId]!;//بحالة صار ايرو راح يقلب ثاني ثاني لانو قلب سريع فوق فوق
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;
  void getfavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userData;
  void getUserData() {
    emit(ShopLoadingGetUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      //print(value.data.toString());
      userData = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessGetUserDataState(userData!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserDataState());
    });
  }

  void UpUserData({
  required String name,
    required String phone,
    required String email,
    //required String password,
}) {
    emit(ShopLoadingUpUserDataState());
    DioHelper.putData(
      url: Update_Profile,
      token: token,
      data: {
        'name' : name,
        'email' : email,
        //'password' : password,
        'phone' : phone,
      },
    ).then((value) {
      //print(value.data.toString());
      userData = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUpUserDataState(userData!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpUserDataState());
    });
  }
}
