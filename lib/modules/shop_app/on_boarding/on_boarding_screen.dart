// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_app/Login/LoginShopScreen.dart';
import 'package:shop_app/shared/components/compoents.dart';
import 'package:shop_app/shared/network/remote/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boaedController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              //ممكن تاخدها ك ميثود برا
              CacheHelper.saveData(key: 'onBoarding', value: true)
                  .then((value) {
                if (value) {
                  navigateAndFinish(
                    context,
                    LoginShopScreen(),
                  );
                }
              });
            },
            child: const Text(
              'SKIP',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boaedController,
                onPageChanged: (int index) {
                  if (index == 2) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    isLast = false;
                  }
                },
                physics: const BouncingScrollPhysics(),
                //تطير لون النطة في الحركة
                itemBuilder: (context, index) => bulidBoardingItem(size),
                itemCount: 3,
              ),
            ),
            // SizedBox(
            //   height: 40.0,
            // ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boaedController,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    //هاي لتزين الشكل
                    dotColor: Colors.grey,
                    //طول ولون وعرض النقط
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.redAccent,
                    //لون النقطة الي انت فيها
                    spacing: 4,
                    //تباعد عن بعض
                    expansionFactor: 3, //هذا الي بدك تنقل عليه كيف بكبر
                  ),
                ),
                const Spacer(),
                //هاي تخلي المسافة بينهم الي قبل والي بعد الى الاخرى
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      CacheHelper.saveData(key: 'onBoarding', value: true)
                          .then((value) {
                        if (value) {
                          navigateAndFinish(
                            context,
                            LoginShopScreen(),
                          );
                        }
                      });
                    } else {
                      boaedController.nextPage(
                        duration: const Duration(
                          //التنقل
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn, //شكل التنقل
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_outlined),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bulidBoardingItem(Size size) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            child: Image(
              image: NetworkImage('https://student.valuxapps.com/storage/uploads/categories/1644527120pTGA7.clothes.png'),
            ),
          ),
          SizedBox(
            height: size.height*0.008,
          ),
          Text(
            'Screen Title',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: size.height*0.01,
          ),
          Text(
            'Screen Body',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: size.height*0.04,
          )
        ],
      );
}
