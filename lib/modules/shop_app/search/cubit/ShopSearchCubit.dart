import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/search_model.dart';
import 'package:shop_app/modules/shop_app/search/cubit/ShopSearchState.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopSearchCubit extends Cubit<ShopSearchState> {
  ShopSearchCubit() : super(ShopSearchInitialState());

  static ShopSearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search(String text) {
    emit(ShopSearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      data: {
        'text': text,
      },
      token: token,
    ).then((value) {
      //print(value.data.toString());
      searchModel = SearchModel.fromJson(value.data);
      print(searchModel!.data!.data[0].image);
      emit(ShopSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShopSearchErrorState());
    });
  }
}
