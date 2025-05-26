import 'dart:convert';

ResApiError resApiErrorhFromJson(String str) =>
    ResApiError.fromJson(json.decode(str));
String resApiErrorToJson(ResApiError data) => json.encode(data.toJson());

class ResApiError {
  ResApiError({
    this.message,
    this.error,
  });
  String? message;
  DataModelError? error;

  factory ResApiError.fromJson(Map<String, dynamic> json) => ResApiError(
    message: json["message"],
    error: json["error"] == null
      ? null: DataModelError.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error?.toJson(),
  };
}

class DataModelError {
  DataModelError({
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.confirmPassword,
    this.telephone,
    this.id,
    this.address,
    this.system,
    this.email,
    this.oldPassword,
    this.newPassword,
    this.confirmNewPassword,
    this.orderId,
    this.shopId,
    this.rating,
    this.productIds,
    this.productId,

    this.paymentMethodId,
    this.paymentIntentId,

    this.expired,
  });

  String? username;
  String? password;
  String? firstname;
  String? lastname;
  String? confirmPassword;
  String? telephone;
  String? id;
  String? address;
  String? system;
  String? email;
  String? oldPassword;
  String? newPassword;
  String? confirmNewPassword;
  String? orderId;
  String? shopId;
  String? rating;
  String? productIds;
  String? productId;
  
  String? paymentMethodId;
  String? paymentIntentId;

  String? expired;

  factory DataModelError.fromJson(Map<String, dynamic> json) => DataModelError(
    id: json["_id"],
    username: json["username"],
    password: json["password"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    confirmPassword: json["confirmPassword"],
    telephone: json["telephone"],
    address: json["address"],
    system: json["system"],
    email: json["email"],
    oldPassword: json["oldPassword"],
    newPassword: json["newPassword"],
    confirmNewPassword: json["confirmNewPassword"],
    orderId: json["orderId"],
    shopId: json["shopId"],
    rating: json["rating"],
    productIds: json["productIds"],
    productId: json["productId"],

    paymentMethodId: json["paymentMethodId"],
    paymentIntentId: json["paymentIntentId"],
    
    expired: json["expired"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "password": password,
    "firstname": firstname,
    "lastname": lastname,
    "confirmPassword": confirmPassword,
    "telephone": telephone,
    "address": address,
    "system": system,
    "email": email,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
    "confirmNewPassword": confirmNewPassword,
    "orderId": orderId,
    "shopId": shopId,
    "rating": rating,
    "productIds": productIds,
    "productId": productId,
    "paymentMethodId": paymentMethodId,
    "paymentIntentId": paymentIntentId,
    "expired": expired,
  };

  String? errorText() {
    if (id != null) {
      return "$id";
    } else if (username != null) {
      return "$username";
    } else if (password != null) {
      return "$password";
    } else if (firstname != null) {
      return "$firstname";
    } else if (lastname != null) {
      return "$lastname";
    } else if (confirmPassword != null) {
      return "$confirmPassword";
    } else if (telephone != null) {
      return "$telephone";
    } else if (address != null) {
      return "$address";
    } else if (system != null) {
      return "$system";
    } else if (email != null) {
      return "$email";
    } else if (oldPassword != null) {
      return "$oldPassword";
    } else if (newPassword != null) {
      return "$newPassword";
    } else if (confirmNewPassword != null) {
      return "$confirmNewPassword";
    } else if (paymentMethodId != null) {
      return "$paymentMethodId";
    } else if (paymentIntentId != null) {
      return "$paymentIntentId";
    } else if (orderId != null) {
      return "$orderId";
    } else if (shopId != null) {
      return "$shopId";
    } else if (rating != null) {
      return "$rating";
    } else if (productIds != null) {
      return "$productIds";
    } else if (productId != null) {
      return "$productId";
    } else if (expired != null) {
      return "$expired";
    }
    
    return null;
  }
}
