import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/models/paginated_result.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../../domain/entities/transaction_item.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';
import '../models/transaction_item_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource _datasource;

  TransactionRepositoryImpl(this._datasource);

  String _friendlyError(Object e) {
    if (e is FirebaseException) {
      switch (e.code) {
        case 'unavailable':
          return 'Mất kết nối đến máy chủ. Vui lòng kiểm tra mạng và thử lại.';
        case 'permission-denied':
          return 'Không có quyền thực hiện thao tác này. Vui lòng liên hệ quản trị.';
        case 'timeout':
          return 'Kết nối quá thời gian. Vui lòng thử lại.';
        default:
          return 'Lỗi: ${e.message ?? e.code}';
      }
    }
    return e.toString();
  }

  @override
  Future<Either<Failure, String>> createExportOrder({
    required entity.Transaction transaction,
    required List<TransactionItem> items,
  }) async {
    try {
      final txModel = _txToModel(transaction);
      final itemModels = items.map(_itemToModel).toList();
      final id = await _datasource.createExportOrder(
        transaction: txModel,
        items: itemModels,
      );
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(_friendlyError(e)));
    }
  }

  @override
  Future<Either<Failure, String>> createImportOrder({
    required entity.Transaction transaction,
    required List<TransactionItem> items,
  }) async {
    try {
      final txModel = _txToModel(transaction);
      final itemModels = items.map(_itemToModel).toList();
      final id = await _datasource.createImportOrder(
        transaction: txModel,
        items: itemModels,
      );
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(_friendlyError(e)));
    }
  }

  @override
  Future<Either<Failure, List<entity.Transaction>>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) async {
    try {
      final models = await _datasource.getTransactionHistory(
        startDate: startDate,
        endDate: endDate,
        type: type,
        warehouseLocation: warehouseLocation,
      );
      return Right(models.map(_txToEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entity.Transaction>>> getTransactionsByDate(
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final models = await _datasource.getTransactionHistory(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      return Right(models.map(_txToEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.Transaction>> getTransactionWithItems(
    String id,
  ) async {
    try {
      final (txModel, itemModels) =
          await _datasource.getTransactionWithItems(id);
      final items = itemModels.map(_itemToEntity).toList();
      final tx = _txToEntity(txModel).copyWithItems(items);
      return Right(tx);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<entity.Transaction>>> getTransactionHistoryPaginated({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
    int limit = 20,
    dynamic startAfter,
  }) async {
    try {
      final (models, lastDoc) = await _datasource.getTransactionHistoryPaginated(
        startDate: startDate,
        endDate: endDate,
        type: type,
        warehouseLocation: warehouseLocation,
        limit: limit,
        startAfter: startAfter as DocumentSnapshot?,
      );
      return Right(PaginatedResult(
        items: models.map(_txToEntity).toList(),
        lastDocument: lastDoc,
        hasMore: models.length >= limit,
      ));
    } catch (e) {
      return Left(FirestoreFailure(_friendlyError(e)));
    }
  }

  @override
  Future<Either<Failure, void>> updateDebtPayment({
    required String transactionId,
    required double newPaidAmount,
    required double totalValue,
    String? customerId,
    required double previousPaidAmount,
  }) async {
    try {
      await _datasource.updateDebtPayment(
        transactionId: transactionId,
        newPaidAmount: newPaidAmount,
        totalValue: totalValue,
        customerId: customerId,
        previousPaidAmount: previousPaidAmount,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(_friendlyError(e)));
    }
  }

  @override
  Future<Either<Failure, List<entity.Transaction>>> getTransactionsByProductId(
    String productId, {
    int limit = 20,
  }) async {
    try {
      final models = await _datasource.getTransactionsByProductId(
        productId,
        limit: limit,
      );
      return Right(models.map(_txToEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(_friendlyError(e)));
    }
  }

  entity.Transaction _txToEntity(TransactionModel m) => entity.Transaction(
    id: m.id,
    type: m.type,
    customerId: m.customerId,
    customerName: m.customerName,
    customerType: m.customerType,
    warehouseLocation: m.warehouseLocation,
    isDebt: m.isDebt,
    totalQuantity: m.totalQuantity,
    totalValue: m.totalValue,
    paidAmount: m.paidAmount,
    itemsSummary: m.itemsSummary,
    note: m.note,
    createdAt: m.createdAt,
    createdBy: m.createdBy,
  );

  TransactionModel _txToModel(entity.Transaction e) => TransactionModel(
    id: e.id,
    type: e.type,
    customerId: e.customerId,
    customerName: e.customerName,
    customerType: e.customerType,
    warehouseLocation: e.warehouseLocation,
    isDebt: e.isDebt,
    totalQuantity: e.totalQuantity,
    totalValue: e.totalValue,
    paidAmount: e.paidAmount,
    itemsSummary: e.itemsSummary,
    note: e.note,
    createdAt: e.createdAt,
    createdBy: e.createdBy,
  );

  TransactionItem _itemToEntity(TransactionItemModel m) => TransactionItem(
    id: m.id,
    productId: m.productId,
    productName: m.productName,
    category: m.category,
    regulationClass: m.regulationClass,
    quantity: m.quantity,
    unitPriceAtTime: m.unitPriceAtTime,
    subtotal: m.subtotal,
  );

  TransactionItemModel _itemToModel(TransactionItem e) => TransactionItemModel(
    id: e.id,
    productId: e.productId,
    productName: e.productName,
    category: e.category,
    regulationClass: e.regulationClass,
    quantity: e.quantity,
    unitPriceAtTime: e.unitPriceAtTime,
    subtotal: e.subtotal,
  );

  @override
  Future<Either<Failure, void>> updateTransaction({
    required entity.Transaction oldTransaction,
    required List<TransactionItem> oldItems,
    required entity.Transaction newTransaction,
    required List<TransactionItem> newItems,
  }) async {
    try {
      await _datasource.updateTransaction(
        transactionId: oldTransaction.id,
        oldTransaction: _txToModel(oldTransaction),
        oldItems: oldItems.map(_itemToModel).toList(),
        newTransaction: _txToModel(newTransaction),
        newItems: newItems.map(_itemToModel).toList(),
      );
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(_friendlyError(e)));
    }
  }
}

/// Extension to create a transaction copy with items
extension TransactionCopyWith on entity.Transaction {
  entity.Transaction copyWithItems(List<TransactionItem> items) {
    return entity.Transaction(
      id: this.id,
      type: type,
      customerId: customerId,
      customerName: customerName,
      customerType: customerType,
      warehouseLocation: warehouseLocation,
      isDebt: isDebt,
      totalQuantity: totalQuantity,
      totalValue: totalValue,
      paidAmount: paidAmount,
      itemsSummary: itemsSummary,
      note: note,
      createdAt: createdAt,
      createdBy: createdBy,
      items: items,
    );
  }
}
