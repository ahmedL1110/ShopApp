import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopCubit.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopStates.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/shared/components/compoents.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status) {
            showToast(
              text: state.model.message,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        if (ShopCubit.get(context).homeModel != null &&
            ShopCubit.get(context).categoriesModel != null)
          return productsBuilder(ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel, cubit);
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel? model, CategoriesModel? categories, ShopCubit cubic) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(), //لما تطلع على الاخر تعطي منظر
        child: Column(
          children: [
            CarouselSlider(
              items: model!.data.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage(e.image),
                      width: double.infinity,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 200.0,
                initialPage: 0,
                viewportFraction: 1.0,
                //بملي الصورة على الشاشة
                enableInfiniteScroll: true,
                //يضل يلف حول نفسه
                reverse: false,
                //ما يتقلب بين الصور
                autoPlay: true,
                autoPlayInterval: Duration(
                  seconds: 3,
                ),
                //وفت لكل صورة
                autoPlayAnimationDuration: Duration(
                  seconds: 1,
                ),
                //وقت التنقل
                autoPlayCurve: Curves.linear,
                //الشكل
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    //بدي احجمه عشان يزبط
                    height: 100.0,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal, //طريق الحركة
                        itemBuilder: (context, index) =>
                            buildCategories(categories!.data.data[index]),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10.0,
                            ),
                        itemCount: categories!.data.data.length),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                //ببعدهم مسافات عن بعض
                crossAxisSpacing: 1.0,
                //نفس فوق بس حسب كل اتجاه
                childAspectRatio: 1 / 1.605,
                //الطول على العرض
                children: List.generate(
                    model.data.banners.length,
                    (index) =>
                        buildGridProduct(model.data.products[index], cubic)),
              ),
            ),
          ],
        ),
      );

  Widget buildCategories(DataModel modle) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage('${modle.image}'),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(.8),
            width: 100.0,
            child: Text(
              '${modle.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget buildGridProduct(ProductModel model, ShopCubit cubit) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(
                    model.image,
                  ),
                  width: double.infinity,
                  height: 180.0,
                  //fit: BoxFit.fitWidth,
                ),
                if (model.discount != 0)
                  Container(
                    color: Colors.indigoAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Text(
                      'discount'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.0,
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1.3, //بقرب الخط من بعض
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.old_price.round()}',
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.blueGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          cubit.changeFavorites(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: cubit.favorites[model.id]!
                              ? Colors.blue
                              : Colors.grey,
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 14.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
