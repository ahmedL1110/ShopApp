import 'package:shop_app/models/shop_app/change_favorites_model.dart';
import 'package:shop_app/models/shop_app/login_models.dart';
import 'package:shop_app/modules/shop_app/Login/LoginShopScreen.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates{}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates{}

class ShopChangeFavoritesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates{}

class ShopLoadingGetFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState extends ShopStates{}

class ShopLoadingGetUserDataState extends ShopStates{}

class ShopSuccessGetUserDataState extends ShopStates{
  final ShopLoginModel shopLoginModel;

  ShopSuccessGetUserDataState(this.shopLoginModel);
}

class ShopErrorGetUserDataState extends ShopStates{}

class ShopLoadingUpUserDataState extends ShopStates{}

class ShopSuccessUpUserDataState extends ShopStates{
  final ShopLoginModel shopLoginModel;

  ShopSuccessUpUserDataState(this.shopLoginModel);
}

class ShopErrorUpUserDataState extends ShopStates{}
