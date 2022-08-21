import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/Shop_Layout.dart';
import 'package:shop_app/modules/shop_app/Login/cubit/ShopLoginCubit.dart';
import 'package:shop_app/modules/shop_app/Login/cubit/ShopLoginState.dart';
import 'package:shop_app/modules/shop_app/register/RegisterScreen.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/remote/cache_helper.dart';

// ignore: must_be_immutable
class LoginShopScreen extends StatelessWidget {
  // ignore: non_constant_identifier_names
  var FormKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginState>(
        listener: (BuildContext context, Object? state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
              //بلعب على صح او غلط لانو بكل الاحوال راح يصير نجاح
              showToast(
                  text: state.loginModel.message, state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                    token = state.loginModel.data!.token;  //لما تسجيل خروج بطلع بايروو تخليه تلقائي يحمل الجديد بكون ما تعمل مرتين رن
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                  text: state.loginModel.message, state: ToastStates.ERROR);
            }
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: FormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black87,
                                  ),
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                color:
                                    Colors.grey, //copyWith لتغير اشياء اضافية
                              ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defailTextFild(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          stringError: 'please enter your email address',
                          lable: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defailTextFild(
                            onS: (value) {
                              if (FormKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            stringError: 'password is too shorh',
                            lable: 'Password',
                            prefix: Icons.lock_open_sharp,
                            suffix: ShopLoginCubit.get(context).suffix,
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              ShopLoginCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        if(state is! ShopLoginLoadingState) defaultBotton(
                          function: () {
                            if (FormKey.currentState!.validate()) {
                              //هاي عشان لو كان فاضي ما يصير ويطلع ايرو ولو تعبى سوى المطلوب
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          text: 'ligon',
                          istoUpperCase: true,
                        )else Center(child: CircularProgressIndicator(),),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t hava an account?'),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, widget: RegisterScreen());
                              },
                              child: const Text('REGISTER'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
