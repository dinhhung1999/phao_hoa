import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/domain/entities/customer.dart';
import 'package:phao_hoa/domain/entities/product.dart';
import 'package:phao_hoa/domain/entities/transaction.dart';
import 'package:phao_hoa/domain/entities/transaction_item.dart';
import 'package:phao_hoa/domain/entities/debt_record.dart';
import 'package:phao_hoa/domain/entities/warehouse_stock.dart';
import 'package:phao_hoa/domain/entities/warehouse.dart';
import 'package:phao_hoa/domain/entities/price_record.dart';
import 'package:phao_hoa/domain/entities/checklist.dart';
import 'package:phao_hoa/domain/entities/app_user.dart';
import 'package:phao_hoa/domain/entities/inventory_snapshot.dart';

void main() {
  final now = DateTime(2026, 4, 10, 14, 0);

  group('Customer', () {
    test('should create with required fields', () {
      final customer = Customer(
        id: '1',
        name: 'Nguyễn Văn A',
        type: 'khach_quen',
        createdAt: now,
        updatedAt: now,
      );
      expect(customer.name, equals('Nguyễn Văn A'));
      expect(customer.totalDebt, equals(0));
      expect(customer.isActive, isTrue);
    });

    test('hasDebt should return true when totalDebt > 0', () {
      final customer = Customer(
        id: '1',
        name: 'Test',
        type: 'khach_le',
        totalDebt: 500000,
        createdAt: now,
        updatedAt: now,
      );
      expect(customer.hasDebt, isTrue);
    });

    test('hasDebt should return false when totalDebt is 0', () {
      final customer = Customer(
        id: '1',
        name: 'Test',
        type: 'khach_le',
        totalDebt: 0,
        createdAt: now,
        updatedAt: now,
      );
      expect(customer.hasDebt, isFalse);
    });

    test('should support equality via Equatable', () {
      final c1 = Customer(id: '1', name: 'A', type: 'khach_le', createdAt: now, updatedAt: now);
      final c2 = Customer(id: '1', name: 'A', type: 'khach_le', createdAt: now, updatedAt: now);
      expect(c1, equals(c2));
    });

    test('should not equal when fields differ', () {
      final c1 = Customer(id: '1', name: 'A', type: 'khach_le', createdAt: now, updatedAt: now);
      final c2 = Customer(id: '2', name: 'B', type: 'khach_quen', createdAt: now, updatedAt: now);
      expect(c1, isNot(equals(c2)));
    });
  });

  group('Product', () {
    test('should create with required fields', () {
      final product = Product(
        id: 'p1',
        name: 'Pháo hoa ABC',
        unit: 'kiện',
        importPrice: 100000,
        exportPrice: 150000,
        createdAt: now,
        updatedAt: now,
      );
      expect(product.name, equals('Pháo hoa ABC'));
      expect(product.isActive, isTrue);
      expect(product.category, equals(''));
    });

    test('should support equality via Equatable', () {
      final p1 = Product(id: 'p1', name: 'A', unit: 'kiện', importPrice: 100, exportPrice: 150, createdAt: now, updatedAt: now);
      final p2 = Product(id: 'p1', name: 'A', unit: 'kiện', importPrice: 100, exportPrice: 150, createdAt: now, updatedAt: now);
      expect(p1, equals(p2));
    });
  });

  group('Transaction', () {
    test('should calculate unpaidAmount correctly', () {
      final tx = Transaction(
        id: 'tx1',
        type: 'xuat',
        customerName: 'Test',
        customerType: 'khach_le',
        warehouseLocation: 'kho_1',
        totalValue: 1000000,
        paidAmount: 600000,
        createdAt: now,
        createdBy: 'user@example.com',
      );
      expect(tx.unpaidAmount, equals(400000));
    });

    test('unpaidAmount should be 0 when fully paid', () {
      final tx = Transaction(
        id: 'tx1',
        type: 'xuat',
        customerName: 'Test',
        customerType: 'khach_le',
        warehouseLocation: 'kho_1',
        totalValue: 1000000,
        paidAmount: 1000000,
        createdAt: now,
        createdBy: 'user@example.com',
      );
      expect(tx.unpaidAmount, equals(0));
    });

    test('should default isDebt to false', () {
      final tx = Transaction(
        id: 'tx1',
        type: 'nhap',
        customerName: 'Test',
        customerType: 'khach_le',
        warehouseLocation: 'kho_1',
        totalValue: 500000,
        paidAmount: 500000,
        createdAt: now,
        createdBy: 'user@example.com',
      );
      expect(tx.isDebt, isFalse);
    });
  });

  group('TransactionItem', () {
    test('should create with price snapshot', () {
      final item = TransactionItem(
        id: 'i1',
        productId: 'p1',
        productName: 'Pháo A',
        quantity: 10,
        unitPriceAtTime: 150000,
        subtotal: 1500000,
      );
      expect(item.quantity, equals(10));
      expect(item.unitPriceAtTime, equals(150000));
      expect(item.subtotal, equals(1500000));
    });
  });

  group('DebtRecord', () {
    test('isDebt should return true for debt type', () {
      final record = DebtRecord(
        id: 'd1',
        type: 'debt',
        amount: 500000,
        runningBalance: 500000,
        createdAt: now,
      );
      expect(record.isDebt, isTrue);
      expect(record.isPayment, isFalse);
    });

    test('isPayment should return true for payment type', () {
      final record = DebtRecord(
        id: 'd2',
        type: 'payment',
        amount: 200000,
        runningBalance: 300000,
        createdAt: now,
      );
      expect(record.isDebt, isFalse);
      expect(record.isPayment, isTrue);
    });
  });

  group('WarehouseStock', () {
    test('should return stock at specific location', () {
      final stock = WarehouseStock(
        productId: 'p1',
        productName: 'Product A',
        totalQuantity: 100,
        stockByLocation: {'kho_1': 60, 'kho_2': 40},
      );
      expect(stock.getStockAt('kho_1'), equals(60));
      expect(stock.getStockAt('kho_2'), equals(40));
    });

    test('should return 0 for unknown location', () {
      final stock = WarehouseStock(
        productId: 'p1',
        productName: 'Product A',
        totalQuantity: 100,
        stockByLocation: {'kho_1': 100},
      );
      expect(stock.getStockAt('kho_99'), equals(0));
    });
  });

  group('PriceRecord', () {
    test('should calculate profit per unit', () {
      final record = PriceRecord(
        id: 'pr1',
        productId: 'p1',
        importPrice: 100000,
        exportPrice: 150000,
        recordedAt: now,
      );
      expect(record.profitPerUnit, equals(50000));
    });

    test('should calculate profit margin percentage', () {
      final record = PriceRecord(
        id: 'pr1',
        productId: 'p1',
        importPrice: 100000,
        exportPrice: 150000,
        recordedAt: now,
      );
      expect(record.profitMargin, equals(50.0));
    });

    test('should return 0 margin when import price is 0', () {
      final record = PriceRecord(
        id: 'pr1',
        productId: 'p1',
        importPrice: 0,
        exportPrice: 150000,
        recordedAt: now,
      );
      expect(record.profitMargin, equals(0));
    });
  });

  group('Warehouse', () {
    test('should create with optional fields', () {
      final warehouse = Warehouse(
        id: 'kho_1',
        name: 'Kho chính',
        createdAt: now,
        updatedAt: now,
      );
      expect(warehouse.address, isNull);
      expect(warehouse.area, isNull);
      expect(warehouse.capacity, isNull);
      expect(warehouse.isActive, isTrue);
    });
  });

  group('Checklist', () {
    test('should create with items', () {
      final checklist = Checklist(
        date: '20260410',
        completedBy: 'user@example.com',
        completedAt: now,
        isPassed: true,
        items: const [
          ChecklistItem(label: 'Bình chữa cháy', isChecked: true),
          ChecklistItem(label: 'Lối thoát hiểm', isChecked: true),
        ],
      );
      expect(checklist.items.length, equals(2));
      expect(checklist.isPassed, isTrue);
    });

    test('ChecklistItem should default isChecked to false', () {
      const item = ChecklistItem(label: 'Test');
      expect(item.isChecked, isFalse);
      expect(item.note, isNull);
    });
  });

  group('AppUser', () {
    test('should create with required fields', () {
      const user = AppUser(uid: 'u1', email: 'test@example.com');
      expect(user.uid, equals('u1'));
      expect(user.displayName, isNull);
    });

    test('should support equality', () {
      const u1 = AppUser(uid: 'u1', email: 'test@example.com');
      const u2 = AppUser(uid: 'u1', email: 'test@example.com');
      expect(u1, equals(u2));
    });
  });

  group('InventorySnapshot', () {
    test('hasDiscrepancy should return true for has_discrepancy status', () {
      final snapshot = InventorySnapshot(
        id: 's1',
        date: now,
        createdBy: 'user@example.com',
        status: 'has_discrepancy',
      );
      expect(snapshot.hasDiscrepancy, isTrue);
    });

    test('hasDiscrepancy should return false for completed status', () {
      final snapshot = InventorySnapshot(
        id: 's1',
        date: now,
        createdBy: 'user@example.com',
        status: 'completed',
      );
      expect(snapshot.hasDiscrepancy, isFalse);
    });
  });

  group('ReconciliationItem', () {
    test('should calculate difference and match status', () {
      const item = ReconciliationItem(
        productId: 'p1',
        productName: 'Test',
        warehouseLocation: 'kho_1',
        systemQuantity: 100,
        actualQuantity: 95,
        difference: -5,
        isMatched: false,
      );
      expect(item.difference, equals(-5));
      expect(item.isMatched, isFalse);
    });
  });
}
