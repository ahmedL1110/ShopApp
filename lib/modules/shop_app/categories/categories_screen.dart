import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopCubit.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopStates.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/shared/components/compoents.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if(ShopCubit.get(context).categoriesModel!=null )return ListView.separated(
          itemBuilder: (context, index) => buildCaItem(
              ShopCubit.get(context).categoriesModel!.data.data[index]),
          separatorBuilder: (context, index) => MyDivider(),
          itemCount: ShopCubit.get(context).categoriesModel!.data.data.length,
        );
        else return Center(child:CircularProgressIndicator());
      },
    );
  }

  Widget buildCaItem(DataModel model) {
    return Padding(
      padding: EdgeInsets.all(
        20.0,
      ),
      child: Row(
        children: [
          Image(
            image: NetworkImage('${model.image}'),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
          ),
        ],
      ),
    );
  }
}
