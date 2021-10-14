import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:trkar_vendor/model/car_made.dart';
import 'package:trkar_vendor/model/car_types.dart';
import 'package:trkar_vendor/model/carmodel.dart';
import 'package:trkar_vendor/model/category.dart';
import 'package:trkar_vendor/model/main_category.dart';
import 'package:trkar_vendor/model/manufacturer_model.dart';
import 'package:trkar_vendor/model/part__category.dart';
import 'package:trkar_vendor/model/prod_country.dart';
import 'package:trkar_vendor/model/product_type_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/tags_model.dart';
import 'package:trkar_vendor/model/transmissions.dart';
import 'package:trkar_vendor/model/year.dart';

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
  String nameEn;
  String description;
  String avg_valuations;
  String descriptionEn;
  String price;
  String discount;
  String qty_reminder;
  String createdAt;
  bool isSelect = false;
  String carMadeId;
  String maincategory_id;
  Main_Category maincategory;
  String carModelId;
  List<PhotoProduct> photo;
  List<Asset> photos;
  List<Tag> tags;
  Year yearto;
  Year yearfrom;
  String yeartoId;
  String yearfromId;
  String allcategory_id;
  String partCategoryId;
  String vendorId;
  String storeId;
  String manufacturer_id;
  String Main_categoryid;
  String prodcountry_id;
  String productType_id;
  String cartype_id;
  String transmission_id;
  String quantity;
  String serialNumber;
  String transmissionId;
  Main_Category category;
  ProdCountry prodCountry;
  CarMade carMade;
  List<Carmodel> carModel;
  CarType carType;
  Year year;
  Part_Category partCategory;
  Store store;
  Vendor vendor;
  Manufacturer manufacturer;
  Transmission transmission;
  OriginCountry originCountry;
  ProductType producttypeId;
  String serialCoding;
  String actualPrice;
  String serialId;
  int approved;
  int tyres_belong;
  String holesalePrice;
  String noOfOrders;

  String width;
  String height;
  String size;
  List<Main_Category> allcategory;

  Product(
      {this.id,
      this.name,
      this.nameEn,
      this.description,
      this.descriptionEn,
      this.price,
      this.discount,
      this.createdAt,
      this.carMadeId,
      this.avg_valuations,
      this.carModelId,
      this.carModel,
      this.partCategoryId,
      this.photo,
      this.yearto,
      this.yearfrom,
      this.vendorId,
      this.maincategory,
      this.manufacturer_id,
      this.transmission_id,
      this.qty_reminder,
      this.prodcountry_id,
      this.storeId,
      this.cartype_id,
      this.prodCountry,
      this.quantity,
      this.allcategory,
      this.tyres_belong,
      this.maincategory_id,
      this.serialNumber});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    avg_valuations = json['avg_valuations'].toString();
    nameEn = json['name_en'];
    tyres_belong = json['tyres_belong'];
    descriptionEn = json['description_en'];
    price = json['price']??'0';
    actualPrice = json['actual_price'].toString();
    discount = json['discount'].toString();
    createdAt = json['created_at'];
    carMadeId = json['car_made_id'].toString();
    carModelId = json['car_model_id'];
    cartype_id = json['cartype_id'].toString();
    yearfrom =
        json['year_from'] != null ? new Year.fromJson(json['year_from']) : null;
    yearto =
        json['year_to'] != null ? new Year.fromJson(json['year_to']) : null;
    //partCategoryId = json['part_category_id'].toString();
    //CategoryId = json['category_id'].toString();
    vendorId = json['vendor_id'].toString();
    storeId = json['store_id'].toString();
    quantity = json['quantity'].toString();
    serialNumber = json['serial_number'];
    if (json['photo'] != null) {
      photo = new List<PhotoProduct>();
      json['photo'].forEach((v) {
        photo.add(new PhotoProduct.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = new List<Tag>();
      json['tags'].forEach((v) {
        tags.add(new Tag.fromJson(v));
      });
    }
    if (json['allcategory'] != null) {
      allcategory = new List<Main_Category>();
      json['allcategory'].forEach((v) {
        allcategory.add(new Main_Category.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Main_Category.fromJson(json['category'])
        : null;
    prodCountry = json['origin_country'] != null
        ? new ProdCountry.fromJson(json['origin_country'])
        : null;
    maincategory = json['main_category'] != null
        ? new Main_Category.fromJson(json['main_category'])
        : null;
    carMade = json['car_made'] != null
        ? new CarMade.fromJson(json['car_made'])
        : null;
    if (json['car_model'] != null) {
      carModel = new List<Carmodel>();
      json['car_model'].forEach((v) {
        carModel.add(new Carmodel.fromJson(v));
      });
    }
    carType = json['car_type'] != null
        ? new CarType.fromJson(json['car_type'])
        : null;
    year = json['year'];
    partCategory = json['part_category'] != null
        ? new Part_Category.fromJson(json['part_category'])
        : null;
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    manufacturer = json['manufacturer'] != null
        ? new Manufacturer.fromJson(json['manufacturer'])
        : null;
    originCountry = json['origin_country'] != null
        ? new OriginCountry.fromJson(json['origin_country'])
        : null;
    transmissionId = json['transmission_id'].toString();
    transmission = json['transmission'] != null
        ? new Transmission.fromJson(json['transmission'])
        : null;
    producttypeId = json['product_type'] != null
        ? new ProductType.fromJson(json['product_type'])
        : null;
    serialCoding = json['serial_coding'];
    serialId = json['serial_id'];
    approved = json['approved'];
    qty_reminder = json['qty_reminder'].toString();

    width = json['width'].toString();
    height = json['height'].toString();
    size = json['size'].toString();

    holesalePrice = json['holesale_price']==null?'':json['holesale_price'].toString();
    noOfOrders = json['no_of_orders']==null?'':json['no_of_orders'].toString();
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['width']=width??'';
    data['height']=height??'';
    data['size']=size??'';

    this.name == null ? null : data['name'] = this.name;
    this.description == null ? null : data['description'] = this.description;
    this.nameEn == null ? null : data['name_en'] = this.nameEn;
    this.descriptionEn == null
        ? null
        : data['description_en'] = this.descriptionEn;

    this.price == null ? '1' : this.price.isEmpty? '1' : data['price'] = this.price;
    if (this.productType_id == '1') {
      this.discount == null || this.discount == '0.0'
          ? null
          : data['discount'] = this.discount;
      print(this.discount);
    }
    this.carMadeId == null ? null : data['car_made_id'] = this.carMadeId;
    data['allcategory'] = this.allcategory_id;
    //data['car_model_id'] = this.carModelId;
    this.yearfromId == null ? null : data['year_from'] = this.yearfromId;
    this.yeartoId == null ? null : data['year_to'] = this.yeartoId;
    if (this.carModel != null) {
      data['models'] = this.carModel.map((v) => v.id).toList().toString();
    }
    this.partCategoryId == null
        ? null
        : this.partCategoryId.isEmpty
            ? null
            :this.partCategoryId=='null'
            ? null
            : data['part_category_id'] = this.partCategoryId;
    this.cartype_id == null
        ? null
        : this.cartype_id.isEmpty
            ? null
            : data['cartype_id'] = this.cartype_id;
    this.prodcountry_id == null
        ? null
        : data['prodcountry_id'] = this.prodcountry_id;
    data['producttype_id'] = this.productType_id;
    this.Main_categoryid == null
        ? null
        : data['maincategory_id'] = this.Main_categoryid;
    data['manufacturer_id'] = this.manufacturer_id;
    this.qty_reminder == null || this.qty_reminder == "null" ? data['qty_reminder'] = '1' : data['qty_reminder'] = this.qty_reminder;
    this.transmission_id == null
        ? null
        : data['transmission_id'] = this.transmission_id;
    data['store_id'] = this.storeId;
    this.quantity == null || this.quantity == "0"|| this.quantity == "null"
        ? data['quantity'] = "1"
        : data['quantity'] = this.quantity;

    this.holesalePrice == null ? null : data['holesale_price'] = this.holesalePrice;
    this.noOfOrders == null ? null : data['no_of_orders'] = this.noOfOrders;
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

class PhotoProduct {
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

  PhotoProduct(
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

  PhotoProduct.fromJson(Map<String, dynamic> json) {
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

class Vendor {
  int id;
  String vendorName;
  String email;
  String type;
  String serial;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  int useridId;
  String lang;
  String commercialNo;
  String commercialDoc;
  String taxCardNo;
  String taxCardDoc;
  String bankAccount;
  int approved;
  int complete;
  int declined;
  int rejected;
  String companyName;

  Vendor(
      {this.id,
      this.vendorName,
      this.email,
      this.type,
      this.serial,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.useridId,
      this.lang,
      this.commercialNo,
      this.commercialDoc,
      this.taxCardNo,
      this.taxCardDoc,
      this.bankAccount,
      this.approved,
      this.complete,
      this.declined,
      this.rejected,
      this.companyName});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorName = json['vendor_name'];
    email = json['email'];
    type = json['type'];
    serial = json['serial'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    useridId = json['userid_id'];
    lang = json['lang'];
    commercialNo = json['commercial_no'];
    commercialDoc = json['commercial_doc'];
    taxCardNo = json['tax_card_no'];
    taxCardDoc = json['tax_card_doc'];
    bankAccount = json['bank_account'];
    approved = json['approved'];
    complete = json['complete'];
    declined = json['declined'];
    rejected = json['rejected'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_name'] = this.vendorName;
    data['email'] = this.email;
    data['type'] = this.type;
    data['serial'] = this.serial;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['userid_id'] = this.useridId;
    data['lang'] = this.lang;
    data['commercial_no'] = this.commercialNo;
    data['commercial_doc'] = this.commercialDoc;
    data['tax_card_no'] = this.taxCardNo;
    data['tax_card_doc'] = this.taxCardDoc;
    data['bank_account'] = this.bankAccount;
    data['approved'] = this.approved;
    data['complete'] = this.complete;
    data['declined'] = this.declined;
    data['rejected'] = this.rejected;
    data['company_name'] = this.companyName;
    return data;
  }
}

class OriginCountry {
  int id;
  String countryName;
  String nameEn;
  String countryCode;
  int status;
  String lang;

  OriginCountry(
      {this.id, this.countryName, this.countryCode, this.status, this.lang});

  OriginCountry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    nameEn = json['name_en'];
    countryCode = json['country_code'];
    status = json['status'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    data['status'] = this.status;
    data['lang'] = this.lang;
    return data;
  }
}
