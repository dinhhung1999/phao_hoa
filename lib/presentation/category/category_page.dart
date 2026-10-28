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
    context.read<CategoryBloc>().add(
      const CategoryEvent.loadProductsPaginated(),
    );

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

  Future<void> _addProduct() async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CategoryBloc>(),
          child: const ProductFormPage(),
        ),
      ),
    );
    if (mounted) {
      context.read<CategoryBloc>().add(const CategoryEvent.refreshProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: const Text('Danh mục')) : null,
      floatingActionButton: MediaQuery.sizeOf(context).width >= 1100
          ? null
          : FloatingActionButton(
              heroTag: 'fab_category',
              onPressed: _addProduct,
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
            priceHistoryLoaded: (_) => const AppLoadingIndicator(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context.read<CategoryBloc>().add(
                const CategoryEvent.loadProductsPaginated(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginatedList(
    List<Product> products,
    bool hasMore,
    bool isLoadingMore,
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
          if (MediaQuery.sizeOf(context).width >= 1100)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Sản phẩm',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${products.length} mục',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _addProduct,
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm sản phẩm'),
                  ),
                ],
              ),
            ),
          _buildSearchBar(),
          Expanded(
            child: filtered.isEmpty
                ? ListView(
                    // Needed for RefreshIndicator to work on empty
                    children: [
                      SizedBox(height: 120),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: AppColors.textHintOf(context),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Không tìm thấy sản phẩm',
                              style: TextStyle(
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      Widget itemBuilder(BuildContext context, int index) {
                        if (index >= filtered.length) {
                          return Center(
                            child: isLoadingMore
                                ? const CircularProgressIndicator.adaptive()
                                : OutlinedButton.icon(
                                    onPressed: () =>
                                        context.read<CategoryBloc>().add(
                                          const CategoryEvent.loadMoreProducts(),
                                        ),
                                    icon: const Icon(Icons.expand_more),
                                    label: const Text('Tải thêm sản phẩm'),
                                  ),
                          );
                        }
                        return _buildProductCard(filtered[index]);
                      }

                      if (constraints.maxWidth >= 850) {
                        return GridView.builder(
                          controller: _scrollCtl,
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 560,
                                mainAxisExtent: 88,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: filtered.length + (hasMore ? 1 : 0),
                          itemBuilder: itemBuilder,
                        );
                      }
                      return ListView.separated(
                        controller: _scrollCtl,
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length + (hasMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: itemBuilder,
                      );
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
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
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
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
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
        onTap: () async {
          final categoryBloc = context.read<CategoryBloc>();
          await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: categoryBloc,
                child: ProductDetailPage(product: product),
              ),
            ),
          );
          if (context.mounted) {
            categoryBloc.add(const CategoryEvent.refreshProducts());
          }
        },
      ),
    );
  }
}
