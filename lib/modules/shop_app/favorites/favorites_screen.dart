import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopCubit.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopStates.dart';
import 'package:shop_app/shared/components/compoents.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        if (ShopCubit.get(context).homeModel != null &&state is! ShopLoadingGetFavoritesState) {
          return ListView.separated(
            itemBuilder: (context, index) =>
                buildProductItem(cubit.favoritesModel!.data!.data[index].product, context),
            separatorBuilder: (context, index) => MyDivider(),
            itemCount:
                ShopCubit.get(context).favoritesModel!.data!.data.length,
          );
        }
          return Center(child: CircularProgressIndicator());
      },
    );
  }

}
