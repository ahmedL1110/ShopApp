import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/search/cubit/ShopSearchCubit.dart';
import 'package:shop_app/modules/shop_app/search/cubit/ShopSearchState.dart';
import 'package:shop_app/shared/components/compoents.dart';

class SearchScreen extends StatelessWidget {
  var FormKey = GlobalKey<FormState>();
  var SearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopSearchCubit(),
      child: BlocConsumer<ShopSearchCubit, ShopSearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: FormKey,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defailTextFild(
                      onS: (String text) {
                        ShopSearchCubit.get(context).search(text);
                      },
                      controller: SearchController,
                      type: TextInputType.text,
                      stringError: 'Enter text to search',
                      lable: 'Search',
                      prefix: Icons.search_sharp,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    if (state is ShopSearchLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is ShopSearchSuccessState)Expanded(child: ListView.separated(
                          itemBuilder: (context, index) => buildProductItem(
                            ShopSearchCubit.get(context)
                                .searchModel!
                                .data!
                                .data[index],
                            context,
                            isOlpdPrice: false,
                          ),
                          separatorBuilder: (context, index) => MyDivider(),
                          itemCount: ShopSearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data
                              .length,
                        ),)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
