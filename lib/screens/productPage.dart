import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/add_product.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';

import 'Edit_product.dart';

class ProductPage extends StatefulWidget {
  Product product;

  ProductPage({Key key, this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _carouselCurrentPage = 0;
  String url="products";

  @override
  void initState() {
    widget.product.manufacturer == null
        ? null
        : widget.product.manufacturer_id =
            widget.product.manufacturer.id.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/ic_shopping_cart_bottom.svg',
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'products')),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => SearchOverlay(url: 'products/search/dynamic',),
              );
            },
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: ScreenUtil.getWidth(context) / 1.5,
                    child: Text(
                      "${themeColor.getlocal() == 'ar' ? widget.product.name ?? widget.product.nameEn : widget.product.nameEn ?? widget.product.name}",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                if (widget.product.approved == 0)
                  Container()
                else
                  Container(
                      child: PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: InkWell(
                          onTap: () {
                            _navigate_edit_hell(context, widget.product);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("${getTransrlate(context, 'edit')}"),
                              Icon(
                                Icons.edit_outlined,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: InkWell(
                          onTap: () {
                            API(context)
                                .Delete('products/${widget.product.id}')
                                .then((value) {
                              if (value != null) {
                                showDialog(
                                  context: context,
                                  builder: (_) => ResultOverlay(
                                      "${value['message'] ?? value['errors'] ?? getTransrlate(context, 'doneDelete')}"),
                                );
                              }
                              Provider.of<Provider_Data>(context, listen: false)
                                  .getProducts(context,'products');
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("${getTransrlate(context, 'delete')}"),
                              Icon(
                                CupertinoIcons.delete,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              ],
            ),
            CarouselSlider(
              items: widget.product.photo
                  .map((item) => CachedNetworkImage(
                        imageUrl: item.image,
                        fit: BoxFit.contain,
                      ))
                  .toList(),
              options: CarouselOptions(
                  autoPlay: true,
                  height: 175,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _carouselCurrentPage = index;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  dataRow('${getTransrlate(context, 'id')}', "${widget.product.id}", Colors.black26),
               //${getTransrlate(context, 'CarType')}  : ${widget.hall_model.carType!=null?themeColor.getlocal()=='ar'?widget.hall_model.carType.typeName??'':widget.hall_model.carType.name_en??'':''}

                  dataRow(
                      '${getTransrlate(context, 'Category')}',
                      ' ${widget.product.allcategory?.map((e) =>  "${themeColor.getlocal()=='ar'?e.mainCategoryName: e.mainCategoryNameen}${ widget.product.allcategory.last.id==e.id?'':'>>'}")?.toList()}'.replaceAll('[', '').replaceAll(']', ''),
                      Colors.white),
                  widget.product.tyres_belong==1?  dataRow(
                      '${getTransrlate(context, 'tayars')}',
                      "${widget.product.width??''}/ ${widget.product.height??''}/ ${widget.product.size??''}",
                      Colors.black26):Container(),

                  dataRow('${getTransrlate(context, 'serial')}',
                      "${widget.product.serialNumber}", Colors.black26),
                  dataRow('${getTransrlate(context, 'description')}',
                      "${themeColor.getlocal()=='ar'?widget.product.description??widget.product.descriptionEn:widget.product.descriptionEn??widget.product.description}", Colors.white),

                  dataRow(
                      '${getTransrlate(context, 'prodcountry')}',
                      "${widget.product.originCountry == null ? '' :themeColor.getlocal()=='ar'? widget.product.originCountry.countryName :widget.product.originCountry.nameEn}",
                      Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'store')}',
                      "${widget.product.store == null ? '' : widget.product.store.nameStore}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'productType')}',
                      "${widget.product.producttypeId == null ? '' : widget.product.producttypeId.producttype}",
                      Colors.white),
                  widget.product.producttypeId.id==2?Container(): dataRow('${getTransrlate(context, 'quantity')}',
                      "${widget.product.quantity}", Colors.white),
                  dataRow('${getTransrlate(context, 'price')}',
                      "${widget.product.actualPrice}", Colors.black26),
                  dataRow('${getTransrlate(context, 'discount')}',
                      "${widget.product.discount} %", Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'tags')}',
                      "${widget.product.tags == null ? '' : widget.product.tags.isEmpty? '' : widget.product.tags.map((e) => themeColor.getlocal()=='ar'? e.name??e.name_en:e.name_en??e.name).toList().toString()}",
                      Colors.black26),
                  widget.product.producttypeId.id==2?Container():   dataRow(
                      '${getTransrlate(context, 'qty_reminder')}',
                      "${widget.product.qty_reminder.toString()}",
                      Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'CarType')}',
                      "${widget.product.carType == null ? '' : themeColor.getlocal()=='ar'?widget.product.carType.typeName??'':widget.product.carType.name_en??''}",
                      Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'brand')}',
                      "${widget.product.manufacturer == null ? '' :themeColor.getlocal()=='ar'? widget.product.manufacturer.manufacturerName??widget.product.manufacturer.name_en :widget.product.manufacturer.name_en??widget.product.manufacturer.manufacturerName}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'Compatiblecars')}',
                      "${widget.product.carModel == null ? '' :widget.product.carModel.isEmpty ? '' : widget.product.carModel.map((e) => themeColor.getlocal()=='ar'?e.carmodel??e.name_en:e.name_en??e.carmodel).toList().toString()}",
                      Colors.white),

                  dataRow(
                      '${getTransrlate(context, 'yearfrom')}',
                      "${widget.product.yearfrom == null ? '' : widget.product.yearfrom.year}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'yearto')}',
                      "${widget.product.yearto == null ? '' : widget.product.yearto.year}",
                      Colors.white),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget dataRow(String title, String value, Color color) {
    return value == null || value.isEmpty
        ? Container()
        : Container(
            color: color,
            child: Center(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: ScreenUtil.getWidth(context) / 2.2,
                        child: Text('$title')),
                    Container(
                        width: ScreenUtil.getWidth(context) / 2.2,
                        child: Text("${value}")),
                  ],
                ),
              ),
            ),
          );
  }

  _navigate_edit_hell(BuildContext context, Product hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Edit_Product(hall)));
    Timer(Duration(seconds: 3), () => Provider.of<Provider_Data>(context,listen: false).getProducts(context,url));
  }
}
