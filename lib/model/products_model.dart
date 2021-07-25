import 'package:dio/dio.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/category.dart';
import 'package:trkar_vendor/model/tags_model.dart';

class Products_model {
  List<Product> product;
  int total;

  Products_model({this.product, this.total});

  Products_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      product = new List<Product>();
      json['data'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Product {
  int id;
  String name;
  String description;
  String price;
  String discount;
  String qty_reminder;
  String createdAt;
  bool isSelect=false;
  String carMadeId;
  String carModelId;
  List<Photo> photo;
  List<Asset> photos;
  List<Tag> tags;
  String yearId;
  String CategoryId;
  String partCategoryId;
  String vendorId;
  String storeId;
  String manufacturer_id;
  String Main_categoryid;
  String prodcountry_id;
  String cartype_id;
  String transmission_id;
  String quantity;
  String serialNumber;

  Categories category;

  CarMade carMade;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.discount,
      this.createdAt,
      this.carMadeId,
      this.carModelId,
      this.yearId,
      this.partCategoryId,
      this.photo,
      this.vendorId,
      this.manufacturer_id,
      this.transmission_id,
      this.prodcountry_id,
      this.storeId,
      this.cartype_id,
      this.quantity,
      this.serialNumber});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    discount = json['discount'].toString();
    createdAt = json['created_at'];
    carMadeId = json['car_made_id'].toString();
    carModelId = json['car_model_id'];
    cartype_id= json['cartype_id'].toString();
    yearId = json['year_id'];
    partCategoryId = json['part_category_id'].toString();
    CategoryId = json['category_id'].toString();
    vendorId = json['vendor_id'].toString();
    storeId = json['store_id'].toString();
    quantity = json['quantity'].toString();
    serialNumber = json['serial_number'];
    if (json['photo'] != null) {
      photo = new List<Photo>();
      json['photo'].forEach((v) { photo.add(new Photo.fromJson(v)); });
    }
    if (json['tags'] != null) {
      tags = new List<Tag>();
      json['tags'].forEach((v) { tags.add(new Tag.fromJson(v)); });
    }
    category = json['category'] != null ? new Categories.fromJson(json['category']) : null;
    carMade = json['car_made'] != null ? new CarMade.fromJson(json['car_made']) : null;
    // if (json['car_model'] != null) {
    //   carModel = new List<CarModel>();
    //   json['car_model'].forEach((v) { carModel.add(new CarModel.fromJson(v)); });
    // }
    // carType = json['car_type'] != null ? new CarType.fromJson(json['car_type']) : null;
     //year = json['year'];
    // partCategory = json['part_category'] != null ? new PartCategory.fromJson(json['part_category']) : null;
    // store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    // vendor = json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    // manufacturer = json['manufacturer'] != null ? new Manufacturer.fromJson(json['manufacturer']) : null;
    // originCountry = json['origin_country'] != null ? new OriginCountry.fromJson(json['origin_country']) : null;
    // transmissionId = json['transmission_id'];
    // transmission = json['transmission'] != null ? new Transmission.fromJson(json['transmission']) : null;
    // producttypeId = json['producttype_id'] != null ? new ProducttypeId.fromJson(json['producttype_id']) : null;
    // serialCoding = json['serial_coding'];
    // serialId = json['serial_id'];
    // approved = json['approved'];
    // qtyReminder = json['qty_reminder'];
    // holesalePrice = json['holesale_price'];
    // noOfOrders = json['no_of_orders'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['car_made_id'] = this.carMadeId;
    data['category_id'] = this.CategoryId;
    data['car_model_id'] = this.carModelId;
    data['year_id'] = this.yearId;
    data['models'] = 'ffffff';
    data['part_category_id'] = this.partCategoryId;
    data['cartype_id'] = this.cartype_id;
    data['maincategory_id'] = this.CategoryId;
    data['prodcountry_id'] = this.prodcountry_id;
    data['producttype_id'] = this.cartype_id;
    data['maincategory_id'] = this.Main_categoryid;
    data['manufacturer_id'] = this.manufacturer_id;
    data['qty_reminder'] = this.qty_reminder;
    data['transmission_id'] = this.transmission_id;
    data['store_id'] = this.storeId;
    data['quantity'] = this.quantity;
    data['serial_number'] = this.serialNumber;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.id).toList().toString();
    }
    // if (this.photos != null) {
    //   data['photo[]'] = this.photos.map((v) async {
    //     for (var file in photos) {
    //       return await MultipartFile.fromFile(file.identifier);
    //     }
    //   }).toList();
    // }

    return data;
  }
}

class Photo {
  int id;
  int modelId;
  String uuid;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String conversionsDisk;
  int size;
  int orderColumn;
  String createdAt;
  String updatedAt;
  String image;
  String url;
  String fullurl;
  String thumbnail;
  String preview;

  Photo(
      {this.id,
      this.modelId,
      this.uuid,
      this.collectionName,
      this.name,
      this.fileName,
      this.mimeType,
      this.disk,
      this.conversionsDisk,
      this.size,
      this.orderColumn,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.url,
      this.fullurl,
      this.thumbnail,
      this.preview});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelId = json['model_id'];
    uuid = json['uuid'];
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    conversionsDisk = json['conversions_disk'];
    size = json['size'];
    orderColumn = json['order_column'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    url = json['url'];
    fullurl = json['fullurl'];
    thumbnail = json['thumbnail'];
    preview = json['preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_id'] = this.modelId;
    data['uuid'] = this.uuid;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['conversions_disk'] = this.conversionsDisk;
    data['size'] = this.size;
    data['order_column'] = this.orderColumn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['url'] = this.url;
    data['fullurl'] = this.fullurl;
    data['thumbnail'] = this.thumbnail;
    data['preview'] = this.preview;
    return data;
  }
}
