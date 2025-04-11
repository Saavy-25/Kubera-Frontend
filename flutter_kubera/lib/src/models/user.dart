import 'dart:io';

class User {
  final String id;
  final String username;
  final List<String> receiptIds;
  final List<String> shoppingListIds;
  final List<String> favoriteStoreIds;
  List<Cookie> cookies;

  User({
    required this.id,
    required this.username,
    required this.receiptIds,
    required this.shoppingListIds,
    required this.favoriteStoreIds,
    required this.cookies
  });

  factory User.fromJson(Map<String, dynamic> json, List<Cookie> c) {
    var receiptIdFromJson = json['receiptIds'] as List? ?? [];
    var shoppingListIdFromJson = json['shoppingListIds'] as List? ?? [];
    var favoriteStoreIdFromJson = json['favoriteStoreIds'] as List? ?? [];

    List<String> receipts = receiptIdFromJson.map((value) => value.toString()).toList();
    List<String> lists = shoppingListIdFromJson.map((value) => value.toString()).toList();
    List<String> stores = favoriteStoreIdFromJson.map((value) => value.toString()).toList();

    return User(
      id: json['_id'],
      username: json['username'],
      receiptIds: receipts,
      shoppingListIds: lists,
      favoriteStoreIds: stores,
      cookies: c
    );
  }

  set updateCookies(List<Cookie> c){
    cookies = c;
  }

  List<Cookie> get headerCookies{
    return cookies;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, 
      'username': username,
      'receiptIds': receiptIds,
      'shoppingListIds': shoppingListIds,
      'favoriteStoreIds': favoriteStoreIds,
    };
  }
}