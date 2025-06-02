import 'package:flutter/foundation.dart';

import '../../models/product/product.dart';
import '../../service/network_service.dart';


class HomeProvider extends ChangeNotifier {
  static const _limit = 10;
  int offset = 0;
  bool _stopPagination = false;
  bool loading = false;
  bool loadingSearch = false;

  List<Product> _items = [];
  List<Product> _searchItems = [];

  List<Product> get items => _items;
  List<Product> get searchItems => _searchItems;

  void fetchProducts() async {
    if(_stopPagination || loading) return;

    loading = true;
    notifyListeners();

    final data = await Network.request(api: Apis.products, queryParams: Apis.paginationProduct(offset, _limit));
    if(data == null) {
      _stopPagination = true;
      loading = false;
      notifyListeners();
      return;
    }

    final products = Network.parseProductList(data);
    _items.addAll(products);

    loading = false;
    offset += _limit;
    if(products.length < _limit) {
      _stopPagination = true;
    }
    notifyListeners();
  }

  Future<void> onRefresh() async {
    loading = true;
    notifyListeners();

    final data = await Network.request(api: Apis.products, queryParams: Apis.paginationProduct(0, _limit));
    if(data == null) {
      loading = false;
      notifyListeners();
      return;
    }

    final products = Network.parseProductList(data);
    _items = products;
    loading = false;
    offset = _limit;
    _stopPagination = false;
    notifyListeners();
  }

  Future<void> search(String text) async {
    loadingSearch = true;
    notifyListeners();

    final data = await Network.request(api: Apis.products, queryParams: Apis.searchProduct(text));

    if(data == null) {
      loadingSearch = false;
      notifyListeners();
      return;
    }

    _searchItems = Network.parseProductList(data);
    loadingSearch = false;
    notifyListeners();
  }

  void clearSearchList() {
    _searchItems = [];
    notifyListeners();
  }
}