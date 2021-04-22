/// status_code : 200
/// message : "success"
/// data : [{"id":1,"question":"first question ?","answer":"first answer","created_at":"2021-03-18 07:08:10"},{"id":23,"question":"New Question","answer":"React Client-Side Answer","created_at":"2021-03-18 18:29:24"},{"id":32,"question":"ei wq oeiwqoio","answer":"odopeoqwpe","created_at":"2021-03-21 10:53:47"},{"id":33,"question":"What day is today?","answer":"Thursday","created_at":"2021-04-01 08:26:42"}]
/// total : 4

class Faq_model {
  int _statusCode;
  String _message;
  List<Faq> _data;
  int _total;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Faq> get data => _data;
  int get total => _total;

  Faq_model({
      int statusCode, 
      String message, 
      List<Faq> data,
      int total}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
    _total = total;
}

  Faq_model.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Faq.fromJson(v));
      });
    }
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status_code"] = _statusCode;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    map["total"] = _total;
    return map;
  }

}

/// id : 1
/// question : "first question ?"
/// answer : "first answer"
/// created_at : "2021-03-18 07:08:10"

class Faq {
  int _id;
  String _question;
  String _answer;
  String _createdAt;

  int get id => _id;
  String get question => _question;
  String get answer => _answer;
  String get createdAt => _createdAt;

  Faq({
      int id, 
      String question, 
      String answer, 
      String createdAt}){
    _id = id;
    _question = question;
    _answer = answer;
    _createdAt = createdAt;
}

  Faq.fromJson(dynamic json) {
    _id = json["id"];
    _question = json["question"];
    _answer = json["answer"];
    _createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["question"] = _question;
    map["answer"] = _answer;
    map["created_at"] = _createdAt;
    return map;
  }

}