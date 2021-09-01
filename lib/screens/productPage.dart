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

  ProductPage({Key key,this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _carouselCurrentPage = 0;

  @override
  void initState() {
    widget.product.manufacturer==null?null:widget.product.manufacturer_id=widget.product.manufacturer.id.toString();
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
                    width: ScreenUtil.getWidth(context)/1.5,
                    child: Text(
                      "${themeColor.getlocal()=='ar'?widget.product.name??widget.product.nameEn:widget.product.nameEn??widget.product.name}",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                if (widget.product.approved==0) Container() else Container(

                    child: PopupMenuButton<int>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: InkWell(
                            onTap: (){
                              Nav.route(context, Edit_Product( widget.product));
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
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
                          child:  InkWell(
                            onTap: (){
                              API(context).Delete('products/${widget.product.id}').then((value) {
                                if (value != null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                        "${value['message']??value['errors']?? getTransrlate(context, 'doneDelete')}"
                                    ),
                                  );
                                }
                                Provider.of<Provider_Data>(context,listen: false).getProducts(context);
                              });
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
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
                    )

                ),

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
              child: DataTable(dataRowHeight: 75,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
              ' ',
              style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
              ' ',
              style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows:  <DataRow>[
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('رقم ID'),),
              DataCell(Text("${widget.product.id}")),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'mainCategory')}')),
              DataCell(Text('${widget.product.maincategory==null?'':widget.product.maincategory.mainCategoryName}')),
          ],
        ),
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'subCategory')}')),
              DataCell(Text('${widget.product.category==null?'':widget.product.category.name}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'PartCategory')}')),
              DataCell(Text('${widget.product.partCategory==null?'':widget.product.partCategory.categoryName}')),
          ],
        ),
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'serial')}')),
              DataCell(Text('${widget.product.serialNumber}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'description')}')),
              DataCell(Container(width: ScreenUtil.getWidth(context)/2,child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('${widget.product.description}'),
              ))),
          ],
        ),
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'brand')}')),
              DataCell(Text('${widget.product.carMade==null?'':widget.product.carMade.carMade}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'prodcountry')}')),
              DataCell(Text('${widget.product.originCountry==null?'':widget.product.originCountry.countryName}')),
          ],
        ),
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'store')}')),
              DataCell(Text('${widget.product.store==null?'':widget.product.store.nameStore}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'quantity')}')),
              DataCell(Text('${widget.product.quantity}')),
          ],
        ),
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'price')}')),
              DataCell(Text('${widget.product.actualPrice}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'discount')}')),
              DataCell(Text('${widget.product.discount} %')),
          ],
        ),


        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'productType')}')),
              DataCell(Text('${widget.product.producttypeId==null?'':widget.product.producttypeId.producttype}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'Compatiblecars')}')),
              DataCell(Text('${widget.product.carModel==null?'':widget.product.carModel.map((e) => e.carmodel).toList().toString()}')),
          ],
        ),
        DataRow(color: MaterialStateProperty.resolveWith((states) => Colors.black26) ,
          cells: <DataCell>[
              DataCell(Text('${getTransrlate(context, 'tags')}')),
              DataCell(Text('${widget.product.tags==null?'':widget.product.tags.map((e) => e.name).toList().toString()}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('${getTransrlate(context, 'qty_reminder')}')),
            DataCell(Text('${widget.product.qty_reminder.toString()}')),
          ],
        ),
      ],
    ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),

    );
  }
}
