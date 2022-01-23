class Bill_model {
  Bill_model({
      this.data, 
      this.statusCode,});

  Bill_model.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Bill.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }
  List<Bill> data;
  int statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    map['status_code'] = statusCode;
    return map;
  }

}

class Bill {
  Bill({
      this.id, 
      this.billNo, 
      this.amount, 
      this.shortDescription, 
      this.status, 
      this.dueDate, 
      this.discountAmount, 
      this.taxAmount, 
      this.billPeriodFrom, 
      this.billPeriodTo, 
      this.createdAt, 
      this.updatedAt,});

  Bill.fromJson(dynamic json) {
    id = json['id'];
    billNo = json['bill_no'];
    amount = json['amount'];
    shortDescription = json['short_description'];
    status = json['status'];
    dueDate = json['due_date'];
    discountAmount = json['discount_amount'];
    taxAmount = json['tax_amount'];
    billPeriodFrom = json['bill_period_from'];
    billPeriodTo = json['bill_period_to'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int id;
  dynamic billNo;
  int amount;
  String shortDescription;
  String status;
  String dueDate;
  int discountAmount;
  int taxAmount;
  String billPeriodFrom;
  String billPeriodTo;
  String createdAt;
  String updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['bill_no'] = billNo;
    map['amount'] = amount;
    map['short_description'] = shortDescription;
    map['status'] = status;
    map['due_date'] = dueDate;
    map['discount_amount'] = discountAmount;
    map['tax_amount'] = taxAmount;
    map['bill_period_from'] = billPeriodFrom;
    map['bill_period_to'] = billPeriodTo;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}