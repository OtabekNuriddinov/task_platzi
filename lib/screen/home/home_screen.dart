import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/widgets/product_view.dart';
import '../../core/widgets/search_button.dart';
import 'home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      context.read<HomeProvider>().fetchProducts();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listener);
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        centerTitle: true,
        title: const Text(AppStrings.appName),
        actions: const [
          SearchButton(),
          AppSizes.w12,
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: context.read<HomeProvider>().onRefresh,
            child: Consumer<HomeProvider>(
              builder: (_, provider, __) => ProductView(
                products: provider.items,
                controller: controller,
              ),
            ),
          ),
          Consumer<HomeProvider>(
            builder: (_, provider, __) {
              if(provider.loading) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              return const SizedBox.shrink();
            },
          )

        ],
      ),
    );
  }
}
