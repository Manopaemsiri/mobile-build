import 'dart:convert';
import 'package:coffee2u/models/index.dart';

CustomerGroupModel customerGroupModelFromJson(String str) => CustomerGroupModel.fromJson(json.decode(str));
String customerGroupModelToJson(CustomerGroupModel data) => json.encode(data.toJson());

class CustomerGroupModel {
  final String? id;
  final String? name;
  final FileModel? icon;
  final FileModel? image;
  final int? canUpdateShipping;
  final int? autoUseShipping;
  final int? canUpdateBilling;
  final int? autoUseBilling;
  final int? requiredTaxId;
  final int? enableRegistration;
  final int? order;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CustomerGroupModel({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.canUpdateShipping,
    this.autoUseShipping,
    this.canUpdateBilling,
    this.autoUseBilling,
    this.requiredTaxId,
    this.enableRegistration,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CustomerGroupModel copyWith({
    String? id,
    String? name,
    FileModel? icon,
    FileModel? image,
    int? canUpdateShipping,
    int? autoUseShipping,
    int? canUpdateBilling,
    int? autoUseBilling,
    int? requiredTaxId,
    int? enableRegistration,
    int? order,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => CustomerGroupModel(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    image: image ?? this.image,
    canUpdateShipping: canUpdateShipping ?? this.canUpdateShipping,
    autoUseShipping: autoUseShipping ?? this.autoUseShipping,
    canUpdateBilling: canUpdateBilling ?? this.canUpdateBilling,
    autoUseBilling: autoUseBilling ?? this.autoUseBilling,
    requiredTaxId: autoUseBilling ?? this.requiredTaxId,
    enableRegistration: autoUseBilling ?? this.enableRegistration,
    order: order ?? this.order,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) => CustomerGroupModel(
    id: json["_id"],
    name: json["name"],
    icon: json["icon"] == null ? null : FileModel.fromJson(json["icon"]),
    image: json["image"] == null ? null : FileModel.fromJson(json["image"]),
    canUpdateShipping: json["canUpdateShipping"],
    autoUseShipping: json["autoUseShipping"],
    canUpdateBilling: json["canUpdateBilling"],
    autoUseBilling: json["autoUseBilling"],
    requiredTaxId: json["requiredTaxId"],
    enableRegistration: json["enableRegistration"],
    order: json["order"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "icon": icon?.toJson(),
    "image": image?.toJson(),
    "canUpdateShipping": canUpdateShipping,
    "autoUseShipping": autoUseShipping,
    "canUpdateBilling": canUpdateBilling,
    "autoUseBilling": autoUseBilling,
    "requiredTaxId": requiredTaxId,
    "enableRegistration": enableRegistration,
    "order": order,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  bool isValid() => id != null;

  bool needTaxId() => isValid() && requiredTaxId == 1? true: false;

  bool enableAddressCorrection() => isValid() && canUpdateShipping == 1? true: false;
  bool enableBillingAddressCorrection() => isValid() && canUpdateBilling == 1? true: false;
  bool enableAutoBillingAddress() => isValid() && autoUseBilling == 1? true: false;
  bool enableAutoAddress() => isValid() && autoUseShipping == 1? true: false;
}
