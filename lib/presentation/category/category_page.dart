import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import 'category_bloc.dart';
import 'product_form_page.dart';
import 'product_detail_page.dart';

/// Tab 2: Danh mục sản phẩm
class CategoryPage extends StatefulWidget {
  final bool showAppBar;

  const CategoryPage({super.key, this.showAppBar = true});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: const Text('Danh mục'))
          : null,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_category',
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<CategoryBloc>(),
                child: const ProductFormPage(),
              ),
            ),
          );
          if (result == true && context.mounted) {
            context.read<CategoryBloc>().add(const CategoryEvent.loadProducts());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          state.mapOrNull(
            actionSuccess: (s) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.message),
                backgroundColor: AppColors.success,
              ),
            ),
          );
        },
        builder: (context, state) {
          return state.map(
            initial: (_) {
              context
                  .read<CategoryBloc>()
                  .add(const CategoryEvent.loadProducts());
              return const AppLoadingIndicator();
            },
            loading: (_) => const AppLoadingIndicator(),
            loaded: (loaded) {
              final filtered = _searchQuery.isEmpty
                  ? loaded.products
                  : loaded.products.where((p) {
                      final q = _searchQuery.toLowerCase();
                      return p.name.toLowerCase().contains(q) ||
                          p.category.toLowerCase().contains(q);
                    }).toList();
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<CategoryBloc>()
                      .add(const CategoryEvent.loadProducts());
                },
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm sản phẩm...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () =>
                                      setState(() => _searchQuery = ''),
                                )
                              : null,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                        ),
                        onChanged: (v) =>
                            setState(() => _searchQuery = v),
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text('Không tìm thấy sản phẩm'))
                          : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return Dismissible(
                          key: Key(product.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: AppColors.error,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            context.read<CategoryBloc>().add(
                                  CategoryEvent.deleteProduct(product.id),
                                );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Text(
                                '${product.category} • Loại ${product.regulationClass}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(product.exportPrice),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Nhập: ${CurrencyFormatter.format(product.importPrice)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final result = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<CategoryBloc>(),
                                      child: ProductDetailPage(product: product),
                                    ),
                                  ),
                                );
                                if (result == true && context.mounted) {
                                  context.read<CategoryBloc>().add(const CategoryEvent.loadProducts());
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    ),
                  ],
                ),
              );
            },
            actionSuccess: (_) => const AppLoadingIndicator(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context
                  .read<CategoryBloc>()
                  .add(const CategoryEvent.loadProducts()),
            ),
          );
        },
      ),
    );
  }
}
