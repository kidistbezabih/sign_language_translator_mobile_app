import 'package:flutter/material.dart';

class SearchController with ChangeNotifier {
  SearchController(this._searchKey);

  late String _searchKey;

  String get searchKey => _searchKey ?? '';

  void setSearchKey(String key) async {
    _searchKey = key;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
