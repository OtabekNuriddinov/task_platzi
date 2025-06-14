import 'package:flutter/foundation.dart' hide Category;
import '../../models/category/category.dart';
import '../../service/network_service.dart';

// Note: No code has been written for the error condition yet.
class CatalogProvider extends ChangeNotifier {
  final List<Category> _items = [];
  List<Category> get category => _items;
  bool loading = false;

  Future<void> fetchAll() async {
    loading = true;
    notifyListeners();

    final data = await Network.request(api: Apis.categories);
    if(data != null) {
      _items.addAll(Network.parseCategoryList(data));
    }

    loading = false;
    notifyListeners();
  }
}