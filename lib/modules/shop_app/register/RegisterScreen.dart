import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/Shop_Layout.dart';
import 'package:shop_app/modules/shop_app/register/cubit/ShopRegisterCubit.dart';
import 'package:shop_app/modules/shop_app/register/cubit/ShopRegisterState.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/remote/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var NameController = TextEditingController();
  var EmailController = TextEditingController();
  var PhoneController = TextEditingController();
  var PasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterState>(
        listener: (BuildContext context, Object? state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status) {
              //بلعب على صح او غلط لانو بكل الاحوال راح يصير نجاح
              showToast(
                  text: state.loginModel.message, state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!
                    .token; //لما تسجيل خروج بطلع بايروو تخليه تلقائي يحمل الجديد بكون ما تعمل مرتين رن
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                  text: state.loginModel.message, state: ToastStates.ERROR);
            }
          }else if (ShopRegisterCubit.get(context).loginModel == null) {
            showToast(
                text: 'هنالك غلط في النظام ولا يمكن التسجيل الان',
                state: ToastStates.SUCCESS);
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black87,
                                  ),
                        ),
                        Text(
                          'register now to browse our hot offers',
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
                          controller: NameController,
                          type: TextInputType.name,
                          stringError: 'name must not be emoty',
                          prefix: Icons.person,
                          lable: 'Name',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defailTextFild(
                          controller: EmailController,
                          type: TextInputType.emailAddress,
                          stringError: 'email must not be emoty',
                          prefix: Icons.email_sharp,
                          lable: 'Email Address',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defailTextFild(
                          controller: PasswordController,
                          type: TextInputType.visiblePassword,
                          stringError: 'password must not be emoty',
                          prefix: Icons.lock,
                          lable: 'Password',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defailTextFild(
                          controller: PhoneController,
                          type: TextInputType.phone,
                          stringError: 'phone must not be emoty',
                          prefix: Icons.phone,
                          lable: 'Phone',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultBotton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              ShopRegisterCubit.get(context).userRegister(
                                name: NameController.text,
                                phone: PhoneController.text,
                                email: EmailController.text,
                                password: PasswordController.text,
                              );
                            }
                          },
                          text: 'REGISTER',
                          istoUpperCase: true,
                        ),
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
