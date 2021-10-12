import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Product_item extends StatefulWidget {
  Product_item({Key key, this.hall_model, this.selectStores, this.isSelect})
      : super(key: key);
  final Product hall_model;
  List<int> selectStores;
  bool isSelect = false;

  @override
  _Product_itemState createState() => _Product_itemState();
}

class _Product_itemState extends State<Product_item> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    final data = Provider.of<Provider_Data>(context);

    return Container(
      width: ScreenUtil.getWidth(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 0),
              blurRadius: 3)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    "${widget.hall_model.photo.isNotEmpty ? widget.hall_model.photo[0].image : ''}",
                height: ScreenUtil.getHeight(context) / 6,
                width: ScreenUtil.getWidth(context) / 5,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) =>Image.asset("assets/images/logo.png",color: Colors.grey,),
              ),
              widget.isSelect
                  ? widget.hall_model.approved==0?Container(): Container(
                      color: Colors.white,
                      child: Checkbox(
                          activeColor: Colors.orange,
                          value: widget.hall_model.isSelect,
                          onChanged: (bool value) {
                            setState(() {
                              widget.hall_model.isSelect = value;
                            });
                            !widget.hall_model.isSelect
                                ? widget.selectStores
                                    .remove(widget.hall_model.id)
                                : widget.selectStores.add(widget.hall_model.id);
                            data.setproducts_select(widget.selectStores);
                          }),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: ScreenUtil.getWidth(context) / 1.7,
                child: AutoSizeText(
                 "${themeColor.getlocal()=='ar'? widget.hall_model.name ??widget.hall_model.nameEn:widget.hall_model.nameEn??widget.hall_model.name}",
                  minFontSize: 14,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
              Text(
                "${getTransrlate(context, 'price')} :  ${widget.hall_model.actualPrice}",
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              AutoSizeText(
                '${getTransrlate(context, 'rate')}  : ${widget.hall_model.avg_valuations??0}/5',
                minFontSize: 10,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoSizeText(
                '${getTransrlate(context, 'productType')}  : ${widget.hall_model.producttypeId!=null?themeColor.getlocal()=='ar'?widget.hall_model.producttypeId.producttype??'':widget.hall_model.producttypeId.name_en??'':''}',
                minFontSize: 10,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.hall_model.allcategory!=null? widget.hall_model.allcategory.isEmpty?Container():   Container(
                width: ScreenUtil.getWidth(context) / 1.5,
                child: Text(
                  '${getTransrlate(context, 'Category')}: ${widget.hall_model.allcategory.map((e) => "${themeColor.getlocal()=='ar'?e.mainCategoryName: e.mainCategoryNameen}${ widget.hall_model.allcategory.last.id==e.id?'':' >>'}").toList()}'.replaceAll('[', '').replaceAll(']', ''),
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                ),
              ):Container(),
              Container(
                width: ScreenUtil.getWidth(context) / 1.5,
                child: AutoSizeText(
                  "${themeColor.getlocal()=='ar'? widget.hall_model.description??widget.hall_model.descriptionEn:widget.hall_model.descriptionEn??widget.hall_model.description}",
                  minFontSize: 10,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
