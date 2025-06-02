import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/product/product.dart';
import '../../screen/home/home_provider.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_sizes.dart';
import 'app_image_card.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => search(context),
      icon: AppIcons.search,
    );
  }

  void search(BuildContext context) async {
    final product = await showSearch<Product>(
      context: context,
      delegate: _ProductSearchDelegate(),
    );

    if (product != null && context.mounted) {
      context.go(Routes.productWithId(product.id));
    }
  }
}

class _ProductSearchDelegate extends SearchDelegate<Product> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(CupertinoIcons.clear, color: AppColors.black),
        ),
      Consumer<HomeProvider>(builder: (context, provider, _) {
        return IconButton(
          onPressed: query.isNotEmpty && !provider.loadingSearch ? () => provider.search(query) : null,
          icon: provider.loadingSearch
              ? const Padding(
                  padding: AppSizes.paddingAll8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.black,
                    ),
                  ),
                )
              : AppIcons.search,
        );
      }),
      AppSizes.w12,
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        CupertinoIcons.chevron_back,
        color: AppColors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();

    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.searchItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: AppImageCard(imageUrl: provider.searchItems[index].images.first),
              subtitle: Text(provider.searchItems[index].description, maxLines: 2),
              title: Text(provider.searchItems[index].title),
              onTap: () {
                final item = provider.searchItems[index];
                provider.clearSearchList();
                close(context, item);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();

    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.searchItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(provider.searchItems[index].title),
              onTap: () {
                query = provider.searchItems[index].title;
                provider.search(query).then((_) {
                  if(context.mounted) showResults(context);
                });
              },
            );
          },
        );
      },
    );
  }
}
