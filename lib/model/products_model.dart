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
  String createdAt;
  bool isSelect=false;
  int carMadeId;
  int carModelId;
  List<Photo> photo;
  int yearId;
  int partCategoryId;
  int vendorId;
  int storeId;
  int manufacturer_id;
  int prodcountry_id;
  int transmission_id;
  int quantity;
  String serialNumber;

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
      this.quantity,
      this.serialNumber});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    discount = json['discount'];
    manufacturer_id = json['manufacturer_id'];
    transmission_id = json['transmission_id'];
    prodcountry_id = json['prodcountry_id'];
    createdAt = json['created_at'];
    carMadeId = json['car_made_id'];
    carModelId = json['car_model_id'];

      if (json['photo'] != null) {
        photo = new List<Photo>();
        json['photo'].forEach((v) {
          photo.add(new Photo.fromJson(v));
        });
      };

    yearId = json['year_id'];
    partCategoryId = json['part_category_id'];
    vendorId = json['vendor_id'];
    storeId = json['store_id'];
    quantity = json['quantity'];
    serialNumber = json['serial_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['created_at'] = this.createdAt;
    data['car_made_id'] = this.carMadeId;
    data['car_model_id'] = this.carModelId;
    data['year_id'] = this.yearId;
    data['part_category_id'] = this.partCategoryId;
    data['transmission_id'] = this.transmission_id;
    data['vendor_id'] = this.vendorId;
    data['store_id'] = this.storeId;
    data['quantity'] = this.quantity;
    data['serial_number'] = this.serialNumber;
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
