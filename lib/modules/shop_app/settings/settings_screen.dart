import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopCubit.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopStates.dart';
import 'package:shop_app/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/remote/cache_helper.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (ShopCubit.get(context).userData != null) {
          var model = ShopCubit.get(context).userData;

          nameController.text = ShopCubit.get(context).userData!.data!.name;
          emailController.text = ShopCubit.get(context).userData!.data!.email;
          phoneController.text = ShopCubit.get(context).userData!.data!.phone;
          return SingleChildScrollView(child:  Padding(
            padding: EdgeInsets.all(
              20.0,
            ),
            child: Column(
              children: [
                if(state is ShopLoadingUpUserDataState) LinearProgressIndicator(),
                SizedBox(
                  height: 30.0,
                ),
                defailTextFild(
                  lable: 'Name',
                  prefix: Icons.person,
                  stringError: 'Name must not be empty',
                  controller: nameController,
                  type: TextInputType.name,
                ),
                SizedBox(
                  height: 15.0,
                ),
                defailTextFild(
                  lable: 'Email Address',
                  prefix: Icons.email_rounded,
                  stringError: 'Email Address must not be empty',
                  controller: emailController,
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 15.0,
                ),
                defailTextFild(
                  lable: 'Phone',
                  prefix: Icons.phone,
                  stringError: 'Phone must not be empty',
                  controller: phoneController,
                  type: TextInputType.phone,
                ),
                SizedBox(
                  height: 15.0,
                ),
                defaultBotton(
                  function: () {
                    ShopCubit.get(context).UpUserData(
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                    );
                  },
                  text: 'UpData',
                ),
                SizedBox(
                  height: 15.0,
                ),
                defaultBotton(
                  function: () {
                    CacheHelper.removData(
                      key: 'token',
                    ).then((value) {
                      if (value) {
                        navigateAndFinish(context, OnBoardingScreen());
                      }
                    });
                  },
                  text: 'LOGOUT',
                ),
              ],
            ),
          ),);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
