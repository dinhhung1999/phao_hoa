import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../domain/entities/product.dart';
import 'category_bloc.dart';
import 'product_form_page.dart';
import 'product_detail_page.dart';

/// Tab 2: Danh mục sản phẩm — with pagination + pull-to-refresh
class CategoryPage extends StatefulWidget {
  final bool showAppBar;

  const CategoryPage({super.key, this.showAppBar = true});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _scrollCtl = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Trigger paginated load on first build
    context.read<CategoryBloc>().add(const CategoryEvent.loadProductsPaginated());

    // Listen to scroll for lazy loading
    _scrollCtl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryBloc>().add(const CategoryEvent.loadMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollCtl.hasClients) return false;
    final maxScroll = _scrollCtl.position.maxScrollExtent;
    final currentScroll = _scrollCtl.offset;
    // Trigger when within 200px of the bottom
    return currentScroll >= (maxScroll - 200);
  }

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
            context
                .read<CategoryBloc>()
                .add(const CategoryEvent.refreshProducts());
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
            initial: (_) => const AppLoadingIndicator(),
            loading: (_) => const AppLoadingIndicator(),
            loaded: (loaded) => _buildList(loaded.products, false, false),
            paginatedLoaded: (loaded) => _buildPaginatedList(
              loaded.products,
              loaded.hasMore,
              loaded.isLoadingMore,
            ),
            actionSuccess: (_) => const AppLoadingIndicator(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context
                  .read<CategoryBloc>()
                  .add(const CategoryEvent.loadProductsPaginated()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginatedList(
    List<Product> products, bool hasMore, bool isLoadingMore,
  ) {
    final filtered = _searchQuery.isEmpty
        ? products
        : products.where((p) {
            final q = _searchQuery.toLowerCase();
            return p.name.toLowerCase().contains(q);
          }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoryBloc>().add(const CategoryEvent.refreshProducts());
      },
      child: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          Expanded(
            child: filtered.isEmpty
                ? ListView(
                    // Needed for RefreshIndicator to work on empty
                    children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 64, color: AppColors.textHint),
                            SizedBox(height: 12),
                            Text('Không tìm thấy sản phẩm',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    controller: _scrollCtl,
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length + (hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index >= filtered.length) {
                        // Loading more indicator
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      return _buildProductCard(filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Product> products, bool hasMore, bool isLoadingMore) {
    return _buildPaginatedList(products, hasMore, isLoadingMore);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm sản phẩm...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.unit),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(product.exportPrice),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.exportColor,
              ),
            ),
            Text(
              CurrencyFormatter.format(product.importPrice),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
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
            context
                .read<CategoryBloc>()
                .add(const CategoryEvent.refreshProducts());
          }
        },
      ),
    );
  }
}
