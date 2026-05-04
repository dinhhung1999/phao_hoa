import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_formula.dart';
import '../../presentation/category/category_bloc.dart';
import 'formula_bloc.dart';
import 'formula_form_page.dart';

/// Page displaying all product formulas with calculated prices
class FormulaListPage extends StatefulWidget {
  final bool showAppBar;

  const FormulaListPage({super.key, this.showAppBar = true});

  @override
  State<FormulaListPage> createState() => _FormulaListPageState();
}

class _FormulaListPageState extends State<FormulaListPage> {
  Map<String, double> _priceMap = {};

  @override
  void initState() {
    super.initState();
    context.read<FormulaBloc>().add(const FormulaEvent.loadFormulas());
    _loadPrices();
  }

  void _loadPrices() {
    final categoryState = context.read<CategoryBloc>().state;
    categoryState.mapOrNull(
      loaded: (s) => _buildPriceMap(s.products),
      paginatedLoaded: (s) => _buildPriceMap(s.products),
    );
  }

  void _buildPriceMap(List<Product> products) {
    _priceMap = {
      for (final p in products) p.id: p.exportPrice,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<FormulaBloc, FormulaState>(
            listener: (context, state) {
              state.mapOrNull(
                actionSuccess: (s) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.message)),
                  );
                },
                error: (s) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(s.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
              );
            },
          ),
          BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (s) {
                  setState(() => _buildPriceMap(s.products));
                },
                paginatedLoaded: (s) {
                  setState(() => _buildPriceMap(s.products));
                },
              );
            },
          ),
        ],
        child: BlocBuilder<FormulaBloc, FormulaState>(
          builder: (context, state) {
            return state.map(
              initial: (_) => const Center(
                  child: CircularProgressIndicator.adaptive()),
              loading: (_) => const Center(
                  child: CircularProgressIndicator.adaptive()),
              loaded: (loaded) => _buildFormulaList(loaded.formulas),
              actionSuccess: (_) => const Center(
                  child: CircularProgressIndicator.adaptive()),
              error: (e) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(e.message,
                        style: const TextStyle(color: AppColors.error)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context
                          .read<FormulaBloc>()
                          .add(const FormulaEvent.loadFormulas()),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm công thức'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFormulaList(List<ProductFormula> formulas) {
    if (formulas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science_outlined,
                size: 64, color: AppColors.textSecondaryOf(context)),
            const SizedBox(height: 16),
            Text(
              'Chưa có công thức ghép nào',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn + để tạo công thức ghép sản phẩm',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FormulaBloc>().add(const FormulaEvent.loadFormulas());
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: formulas.length,
        itemBuilder: (context, index) {
          final formula = formulas[index];
          return _FormulaCard(
            formula: formula,
            priceMap: _priceMap,
            onEdit: () => _navigateToForm(context, formula: formula),
            onDelete: () => _confirmDelete(context, formula),
          );
        },
      ),
    );
  }

  void _navigateToForm(BuildContext context, {ProductFormula? formula}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<FormulaBloc>(),
          child: FormulaFormPage(formula: formula),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductFormula formula) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá công thức'),
        content: Text('Bạn có chắc muốn xoá công thức "${formula.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<FormulaBloc>()
                  .add(FormulaEvent.deleteFormula(formula.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  final ProductFormula formula;
  final Map<String, double> priceMap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FormulaCard({
    required this.formula,
    required this.priceMap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final calculatedPrice = formula.calculatePrice(priceMap);
    final hasPrice = priceMap.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Product name + actions
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.15),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.science_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formula.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (formula.notes != null && formula.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              formula.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') onEdit();
                      if (v == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Chỉnh sửa'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Xoá',
                                style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Formula breakdown
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Công thức',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryOf(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...formula.components
                        .where((c) => c.quantity > 0)
                        .map((comp) {
                      final compPrice = priceMap[comp.productId];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 6,
                                color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${comp.quantity} × ${comp.productName}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            if (hasPrice && compPrice != null)
                              Text(
                                CurrencyFormatter.format(
                                    comp.quantity * compPrice),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryOf(context),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    if (formula.laborCost > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 6,
                                color: AppColors.warning),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text('Tiền công ghép',
                                  style: TextStyle(fontSize: 13)),
                            ),
                            Text(
                              CurrencyFormatter.format(formula.laborCost),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Calculated price
              if (hasPrice) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.calculate_outlined,
                              size: 18, color: AppColors.success),
                          SizedBox(width: 8),
                          Text('Giá tự tính',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                        ],
                      ),
                      Text(
                        CurrencyFormatter.format(calculatedPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
