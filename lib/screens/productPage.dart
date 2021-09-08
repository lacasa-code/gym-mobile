import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/products_model.dart';
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
                builder: (_) => SearchOverlay(),
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
                            Nav.route(context, Edit_Product(widget.product));
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
                                  .getProducts(context);
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
                  dataRow('رقم ID', "${widget.product.id}", Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'mainCategory')}',
                      "${widget.product.maincategory == null ? '' : widget.product.maincategory.mainCategoryName}",
                      Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'subCategory')}',
                      "${widget.product.category == null ? '' : widget.product.category.name}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'PartCategory')}',
                      "${widget.product.partCategory == null ? '' : widget.product.partCategory.categoryName}",
                      Colors.white),
                  dataRow('${getTransrlate(context, 'serial')}',
                      "${widget.product.serialNumber}", Colors.black26),
                  dataRow('${getTransrlate(context, 'description')}',
                      "${widget.product.description}", Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'brand')}',
                      "${widget.product.carMade == null ? '' : widget.product.carMade.carMade}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'prodcountry')}',
                      "${widget.product.originCountry == null ? '' : widget.product.originCountry.countryName}",
                      Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'store')}',
                      "${widget.product.store == null ? '' : widget.product.store.nameStore}",
                      Colors.black26),
                  dataRow('${getTransrlate(context, 'quantity')}',
                      "${widget.product.quantity}", Colors.white),
                  dataRow('${getTransrlate(context, 'price')}',
                      "${widget.product.actualPrice}", Colors.black26),
                  dataRow('${getTransrlate(context, 'discount')}',
                      "${widget.product.discount} %", Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'productType')}',
                      "${widget.product.producttypeId == null ? '' : widget.product.producttypeId.producttype}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'Compatiblecars')}',
                      "${widget.product.carModel == null ? '' : widget.product.carModel.map((e) => e.carmodel).toList().toString()}",
                      Colors.white),
                  dataRow(
                      '${getTransrlate(context, 'tags')}',
                      "${widget.product.tags == null ? '' : widget.product.tags.map((e) => e.name).toList().toString()}",
                      Colors.black26),
                  dataRow(
                      '${getTransrlate(context, 'qty_reminder')}',
                      "${widget.product.qty_reminder.toString()}",
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
}
