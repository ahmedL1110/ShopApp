import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/shop_app/cubit/ShopCubit.dart';

Widget defaultBotton({
  double width = double.infinity,
  Color backround = Colors.blue,
  bool istoUpperCase = false,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      color: backround,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          istoUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defailTextFild({
  required TextEditingController controller,
  required TextInputType type,
  required String stringError,
  bool isPassword = false,
  var ontap,
  var onS,
  var onchanged,
  required String lable,
  required IconData prefix,
  IconData? suffix,
  var suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      onChanged: onchanged,
      onFieldSubmitted: onS,
      keyboardType: type,
      obscureText: isPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return stringError;
        }
      },
      onTap: ontap,
      decoration: InputDecoration(
          labelText: lable,
          border: OutlineInputBorder(),
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
              : null),
    );

Widget TastIntem(Map map) => Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${map['time']}',
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${map['title']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  '${map['date']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              // AppCubit.get(context).updateData(status: 'doen', id: )
            },
            icon: Icon(
              Icons.archive_sharp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );

Widget buildArticleItem(article, context, {Widget? widget}) => InkWell(
      onTap: () {
        navigateTo(context, widget: widget);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 130.0,
              height: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 130.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${article['title']}',
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${article['publishedAt']}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[350],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget MyDivider() => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

void navigateTo(context, {dynamic widget}) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Widget articleBuilder(list, {required Widget widgetTo}) {
  if (list.isEmpty)
    return Center(child: CircularProgressIndicator());
  else
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      //تخلي ما في لون لما تحرك الشاشة لفوق وتحت
      itemBuilder: (context, index) =>
          buildArticleItem(list[index], context, widget: widgetTo),
      separatorBuilder: (context, index) => MyDivider(),
      itemCount: 10,
    );
}

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false, //بدك ترجع الى الي قبل ولا لا
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //تظهر على شاشة
        timeInSecForIosWeb: 1,
        backgroundColor: ChooseToastColor(state),
        textColor: Colors.black87,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color ChooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

String? token;

Widget buildProductItem(modle, context, {bool isOlpdPrice = true}) => Padding(
      padding: const EdgeInsets.all(
        20.0,
      ),
      child: Container(
        height: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(
                    '${modle.image}',
                  ),
                  width: 120.0,
                  height: 120.0,
                  //fit: BoxFit.fitWidth,
                ),
                if (isOlpdPrice && modle.discount != 0)
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${modle.name}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1.3, //بقرب الخط من بعض
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '${modle.price}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      if (isOlpdPrice && modle.discount != 0)
                        Text(
                          '${modle.oldPrice}',
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.blueGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(modle.id!);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites[modle.id]!
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
      ),
    );
