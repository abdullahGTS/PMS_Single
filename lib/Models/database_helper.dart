// ignore_for_file: depend_on_referenced_packages, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_brace_in_string_interps

import 'dart:async'; // Ensure this is imported for async methods
import 'dart:ffi';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

import 'transactiontable.dart'; // To use groupBy
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'possystem.db');

    return await openDatabase(
      path,
      version: 2, // Increment to version 2
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE fuel_sale (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fdCTimeStamp TEXT,
          type TEXT,
          deviceID TEXT,
          pumpNo TEXT,
          nozzleNo TEXT,
          transactionSeqNo TEXT,
          fusionSaleId TEXT,
          state TEXT,
          releaseToken TEXT,
          completionReason TEXT,
          fuelMode TEXT,
          productNo TEXT,
          amount TEXT,
          volume TEXT,
          unitPrice TEXT,
          volumeProduct1 TEXT,
          volumeProduct2 TEXT,
          productNo1 TEXT,
          productUM TEXT,
          productName TEXT,
          blendRatio TEXT,
          TipsValue TEXT,
          Isupolade TEXT,
          Isuuidgenerate TEXT,
          statusvoid TEXT,
          payment_type TEXT,
          Isportal TEXT,
          Stannumber TEXT,
          taxRequestID INTEGER,
          voucherNo INTEGER,
          ecrRef TEXT,
          batchNo INTEGER,
          shift_id INTEGER,
          FOREIGN KEY (shift_id) REFERENCES shifts (id) ON DELETE CASCADE ON UPDATE CASCADE

        )
      ''');
        // Create shifts table
        await db.execute('''
        CREATE TABLE shifts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          startshift TEXT,
          endshift TEXT,
          supervisor TEXT,
          totalamount REAL,
          totalmoney REAL,
          totaltips REAL,
          transnum INTEGER,
          status TEXT,
          Isportal TEXT,
          supervisor_id INTEGER,
          shift_num TEXT

        )
        ''');
        await db.execute('''
        CREATE TABLE PosAuth (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          andriod_id TEXT, 
          pos_serial TEXT,
          client_id TEXT,
          secret_key TEXT,
          status_code TEXT,
          access_token TEXT,
          status TEXT 
        )
        ''');
        await db.execute('''
        CREATE TABLE PosReceipt (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          req_id TEXT, 
          status_code TEXT,
          status TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the TipsValue column
          await db.execute('ALTER TABLE fuel_sale ADD COLUMN TipsValue TEXT');
        }
      },
    );
  }

  Future<void> insertFuelSale(Map<String, dynamic> fuelSaleData) async {
    final db = await database;
    await db.insert('fuel_sale', fuelSaleData);
  }

  Future<void> insertPosReceipt(Map<String, dynamic> PosReceipt) async {
    final db = await database;
    await db.insert('PosReceipt', PosReceipt);
  }

  Future<void> insertPosAuth(Map<String, dynamic> PosAuth) async {
    final db = await database;
    await db.insert('PosAuth', PosAuth);
  }

  Future<int> insertShift(Map<String, dynamic> shiftData) async {
    print('shiftData===>${shiftData}');
    final db = await _initDatabase();
    final result = await db.query(
      'shifts',
      columns: ['status'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      if (result.first['status'] != 'opened') {
        return await db.insert('shifts', shiftData);
      } else {
        return -1;
      }
    } else {
      return await db.insert('shifts', shiftData);
    }
  }

  Future<void> fetchAndPrintAllData() async {
    final db = await database; // Access the singleton database
    final List<Map<String, dynamic>> data =
        await db.query('fuel_sale'); // Fetch data from fuel_sale table

    // Print all rows to the console
    data.forEach((row) {
      print("datadatabas${row}");
    });
  }

  Future<int> getRowCount() async {
    final db = await database; // Access the singleton database
    final result = await db.rawQuery('SELECT COUNT(*) FROM fuel_sale');

    // The result will be a list with a single map, retrieve the count value
    print("result${result}");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getTotalAmount(int shiftId) async {
    final db = await database; // Access the singleton database
    try {
      final result = await db.rawQuery(
        'SELECT SUM(amount) as totalAmount FROM fuel_sale WHERE shift_id = ?',
        [shiftId],
      );

      // Safely retrieve the total amount
      double total = 0.0;
      if (result.isNotEmpty && result.first['totalAmount'] != null) {
        total = (result.first['totalAmount'] as num).toDouble();
      }

      print("Total Amount for shift $shiftId: $total");
      return total;
    } catch (e) {
      print("Error calculating total amount for shift $shiftId: $e");
      return 0.0;
    }
  }

  Future<double> getTotalTipsAmount(int shiftId) async {
    final db = await database; // Access the singleton database
    try {
      final result = await db.rawQuery(
        'SELECT SUM(CAST(TipsValue AS REAL)) as totalTipsAmount FROM fuel_sale WHERE shift_id = ?',
        [shiftId],
      );

      // Safely retrieve the total tips amount
      double total = 0.0;
      if (result.isNotEmpty && result.first['totalTipsAmount'] != null) {
        total = (result.first['totalTipsAmount'] as num).toDouble();
      }

      print("Total Tips for shift $shiftId: $total");
      return total;
    } catch (e) {
      print("Error calculating total tips for shift $shiftId: $e");
      return 0.0;
    }
  }

  Future<double> getTotalTipsAndAmount(int shiftId) async {
    final db = await database; // Access the singleton database
    try {
      final result = await db.rawQuery(
        'SELECT SUM(CAST(TipsValue AS REAL) + CAST(amount AS REAL)) as totalCombined FROM fuel_sale WHERE shift_id = ?',
        [shiftId],
      );

      // Safely retrieve the total combined amount
      double total = 0.0;
      if (result.isNotEmpty && result.first['totalCombined'] != null) {
        total = (result.first['totalCombined'] as num).toDouble();
      }

      print("Total Tips and Amount for shift $shiftId: $total");
      return total;
    } catch (e) {
      print("Error calculating total tips and amount for shift $shiftId: $e");
      return 0.0;
    }
  }

  Future<int> updateFuelSale(Map<String, dynamic> fuelSaleMap) async {
    final db = await database; // Use the singleton database
    return await db.update(
      'fuel_sale', // Correct table name
      fuelSaleMap, // The map containing the updated FuelSale data
      where: 'id = ?', // Assuming you are using an ID to find the record
      whereArgs: [fuelSaleMap['id']], // The ID to match
    );
  }

  Future<void> updateIsuuidgenerate(String id, String isuuidgenerate) async {
    final db = await database;

    try {
      await db.update(
        'fuel_sale',
        {'Isuuidgenerate': isuuidgenerate},
        where: 'taxRequestID = ?',
        whereArgs: [id],
      );
      print("Isuuidgenerate updated for ID $id to $isuuidgenerate");
    } catch (e) {
      print('Error updating Isuuidgenerate for ID $id: $e');
    }
  }

  Future<void> updateIsupolade(String id, String isuploaded) async {
    final db = await database;
    await db.update(
      'fuel_sale',
      {'Isupolade': isuploaded},
      where: 'transactionSeqNo = ?',
      whereArgs: [id],
    );
    print("isuploaded updated for ID $id to $isuploaded");
  }

  Future<List<Map<String, dynamic>>> getUnprocessedTransactions() async {
    final db = await database;
    return await db.query(
      'fuel_sale',
      where: 'Isuuidgenerate = ?',
      whereArgs: ['false'],
    );
  }

  Future<void> processTransactions() async {
    final transactions = await getUnprocessedTransactions();
    for (final transaction in transactions) {
      final transactionSeqNo = transaction['transactionSeqNo'];
      // Perform your API calls and update database accordingly.
      await updateIsuuidgenerate(transactionSeqNo, 'true');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllData() async {
    final db = await database; // Access the singleton database
    final List<Map<String, dynamic>> data =
        await db.query('fuel_sale'); // Fetch data from fuel_sale table

    // Print all rows to the console (optional for debugging)
    data.forEach((row) {
      print("datadatabas: $row");
    });

    return data; // Return the fetched data
  }
  // Add other database methods as needed

  // DatabaseHelper: Update the 'Stannumber' field in the 'fuel_sale' table
  Future<void> updateStannumber(
      String transactionSeqNo, String Stannumber) async {
    final db = await database;

    print("Updating Stannumber in database...");
    print("TransactionSeqNo: $transactionSeqNo, Stannumber: $Stannumber");

    await db.update(
      'fuel_sale',
      {'Stannumber': Stannumber}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print(
        "Stannumber updated for transactionSeqNo $transactionSeqNo to $Stannumber");
  }

  // DatabaseHelper: Update the 'Stannumber' field in the 'fuel_sale' table
  Future<void> updateECRRef(String transactionSeqNo, String ecrRef) async {
    final db = await database;

    print("Updating Stannumber in database...");
    print("TransactionSeqNo: $transactionSeqNo, Stannumber: $ecrRef");

    await db.update(
      'fuel_sale',
      {'ecrRef': ecrRef}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print(
        "Stannumber updated for transactionSeqNo $transactionSeqNo to $ecrRef");
  }

  // DatabaseHelper: Update the 'Stannumber' field in the 'fuel_sale' table
  Future<void> updateVoucherNo(String transactionSeqNo, int voucherNo) async {
    final db = await database;

    print("Updating voucherNo in database...");
    print("TransactionSeqNo: $transactionSeqNo, voucherNo: $voucherNo");

    await db.update(
      'fuel_sale',
      {'voucherNo': voucherNo}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print(
        "voucherNo updated for transactionSeqNo $transactionSeqNo to $voucherNo");
  }

  // DatabaseHelper: Update the 'Stannumber' field in the 'fuel_sale' table
  Future<void> updateBatchNo(String transactionSeqNo, int batchNo) async {
    final db = await database;

    print("Updating Stannumber in database...");
    print("TransactionSeqNo: $transactionSeqNo, batchNo: $batchNo");

    await db.update(
      'fuel_sale',
      {'batchNo': batchNo}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print("batchNo updated for transactionSeqNo $transactionSeqNo to $batchNo");
  }

  Future<void> updateStatusvoid(String transactionSeqNo, String status) async {
    final db = await database;

    print("Updating statusvoid in database...");
    print("statusvoid: $transactionSeqNo, statusvoid: $status");

    await db.update(
      'fuel_sale',
      {'statusvoid': status}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print(
        "statusvoid updated for transactionSeqNo $transactionSeqNo to $status");
  }

  Future<void> updatePaymentType(String transactionSeqNo, String status) async {
    final db = await database;

    print("Updating statusvoid in database...");
    print("statusvoid: $transactionSeqNo, statusvoid: $status");

    await db.update(
      'fuel_sale',
      {'payment_type': status}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print(
        "payment_type updated for transactionSeqNo $transactionSeqNo to $status");
  }

  Future<void> updateIsPortal(String transactionSeqNo, String status) async {
    final db = await database;

    print("Updating statusvoid in database...");
    print("statusvoid: $transactionSeqNo, statusvoid: $status");

    await db.update(
      'fuel_sale',
      {'Isportal': status}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print("Isportal updated for transactionSeqNo $transactionSeqNo to $status");
  }

  Future<List<Map<String, dynamic>>> groupTransactionsByPump(
      int shiftId) async {
    final db = await database; // Access the singleton database
    final List<Map<String, dynamic>> data = await db.query(
      'fuel_sale', // Replace with your table name
      where: 'shift_id = ?', // Filter by shift_id
      whereArgs: [shiftId], // Pass the shiftId as an argument
    );

    // Group the data by pumpNo
    var groupedData = groupBy(
      data, // Already a List<Map<String, dynamic>>
      (tx) => tx['nozzleNo'] as String, // Group by pumpNo (now as string)
    );

    // Transform grouped data to include summary details
    List<Map<String, dynamic>> transformedData = [];
    groupedData.forEach((pumpNo, transactions) {
      // Calculate the total amount and total tips for the current pumpNo
      final totalAmount = transactions.fold<double>(
        0,
        (sum, tx) {
          // Safely convert 'amount' to double
          double amount = (tx['amount'] is String)
              ? double.tryParse(tx['amount'] as String) ?? 0.0
              : (tx['amount'] as num?)?.toDouble() ?? 0.0;

          return sum + amount;
        },
      );

      final totalTips = transactions.fold<double>(
        0,
        (sum, tx) {
          // Safely convert 'TipsValue' to double
          double tips = (tx['TipsValue'] is String)
              ? double.tryParse(tx['TipsValue'] as String) ?? 0.0
              : (tx['TipsValue'] as num?)?.toDouble() ?? 0.0;

          return sum + tips;
        },
      );

      // Create a new map for each group and add it to the list
      transformedData.add({
        'pumpNo': pumpNo,
        'transactionCount': transactions.length,
        'totalAmount': totalAmount,
        'totalTips': totalTips, // Include totalTips in the result
        'transactions': transactions, // Store the original transactions as well
      });
    });

    return transformedData; // Return the transformed grouped data
  }

  Future<void> updateShiftData(
      int id, double totalamount, double totalmoney, double totaltips) async {
    final db = await database;

    // Query the current value of 'transnum'
    final result = await db.query(
      'shifts',
      columns: ['totalamount', 'totalmoney', 'totaltips', 'transnum'],
      where: 'id = ?',
      whereArgs: [id],
    );

    double currentTotalamount =
        result.isNotEmpty ? result.first['totalamount'] as double : 0.0;
    double currentTotalmoney =
        result.isNotEmpty ? result.first['totalmoney'] as double : 0.0;
    double currentTotaltips =
        result.isNotEmpty ? result.first['totaltips'] as double : 0.0;
    int currentTransnum =
        result.isNotEmpty ? result.first['transnum'] as int : 0;

    // Increment the transnum by 1
    double updatedTotalamount = currentTotalamount + totalamount;
    double updatedTotalmoney = currentTotalmoney + totalmoney;
    double updatedTotaltips = currentTotaltips + totaltips;
    int updatedTransnum = currentTransnum + 1;

    print(
        "totalamount: $totalamount, totalmoney: $totalmoney, totaltips: $totaltips, transnum: $updatedTransnum");

    await db.update(
      'shifts',
      {
        'totalamount': updatedTotalamount,
        'totalmoney': updatedTotalmoney,
        'totaltips': updatedTotaltips,
        'transnum': updatedTransnum,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    print(
        "Shift updated for ID $id with transnum incremented to $updatedTransnum");
  }

  Future<void> updatestatusshift(
      int shift_num, String status, String endshift) async {
    final db = await database;

    print("Updating statusvoid in database...");
    print("id: $shift_num, statusvoid: $status");

    await db.update(
      'shifts',
      {
        'status': status,
        'endshift': endshift
      }, // Update the 'Stannumber' column
      where:
          'shift_num = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        shift_num
      ], // The transactionSeqNo used for matching the transaction
    );

    print("status updated for status $shift_num to $status");
  }

  Future<Map<String, dynamic>> getTransactionSummary(int shift_id) async {
    final db = await database; // Access the singleton database
    final result = await db.rawQuery(
        'SELECT transnum, totalmoney, totaltips, totalamount  FROM shifts where id=${shift_id}');

    // The result will be a list with a single map, retrieve the values
    if (result.isNotEmpty) {
      return {
        'transnum': result.first['transnum'],
        'totalmoney': result.first['totalmoney'],
        'totaltips': result.first['totaltips'],
        'totalamount': result.first['totalamount']
      };
    }
    return {
      'transnum': 0,
      'totalmoney': 0.0,
      'totaltips': 0.0,
      'totalamount': 0.0
    }; // Default values if no records
  }

  Future<List<Map<String, dynamic>>> getAllShiftsData() async {
    final db = await database; // Access the singleton database
    final result = await db.query('shifts'); // Retrieve all rows from the table

    // Print the result for debugging
    print("Shifts data: $result");

    return result; // Return the list of maps
  }

  Future<List<Map<String, dynamic>>> getLastWeekShifts() async {
    final db = await database; // Access the database

    // Calculate the date range for the last 7 days
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    // Format dates to YYYY-MM-DD
    final oneWeekAgoString = DateFormat('yyyy-MM-dd').format(oneWeekAgo);
    final todayString = DateFormat('yyyy-MM-dd').format(now);

    // Query the database for shifts within the last 7 days
    final result = await db.query(
      'shifts',
      where: '? <= endshift <= ?',
      whereArgs: [oneWeekAgoString, todayString],
    );

    // Debugging: Print the query result
    print("Last week's shifts data: $result");

    return result; // Return the result
  }

  Future<void> updateIsPortalShift(
    int id,
    String status,
  ) async {
    final db = await database;

    print("Updating statusvoid in database...");

    await db.update(
      'shifts',
      {
        'Isportal': status,
      }, // Update the 'Stannumber' column
      where:
          'id = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [id], // The transactionSeqNo used for matching the transaction
    );

    print("Isportal updated for transactionSeqNo $id to $status");
  }

  Future<void> updateShiftNum(
    int id,
    int shiftNum,
  ) async {
    final db = await database;

    print("Updating statusvoid in database...");

    await db.update(
      'shifts',
      {
        'shift_num': shiftNum,
      }, // Update the 'Stannumber' column
      where:
          'id = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [id], // The transactionSeqNo used for matching the transaction
    );

    print("Isportal updated for transactionSeqNo $id to $shiftNum");
  }

  Future<Map<String, dynamic>?> lastShift() async {
    final db = await database;

    try {
      final result = await db.query(
        'shifts',
        columns: [
          'id',
          'startshift',
          'endshift',
          'supervisor',
          'totalamount',
          'totalmoney',
          'totaltips',
          'transnum',
          'status',
          'Isportal',
          'supervisor_id',
          'shift_num'
        ],
        orderBy: 'id DESC',
        limit: 1, // Get only the last shift
      );
      print("result.first${result.first}");
      return result.first;
    } catch (e) {
      print("Error retrieving the last shift: $e");
      return null; // Return null on error
    }
  }

  Future<List<Shifts>> getAllShiftsDataReport() async {
    final db = await database; // Access the singleton database
    final result = await db.query('shifts'); // Retrieve all rows from the table

    // Convert each row into a Shifts object
    List<Shifts> shiftsList = result.map((row) => Shifts.fromMap(row)).toList();

    // Debugging
    print("Shifts data: $shiftsList");

    return shiftsList; // Return the list of Shifts objects
  }

  Future<void> updateIstaxreq(String transactionSeqNo, int taxRequestID) async {
    final db = await database;

    print("Updating statusvoid in database...");

    await db.update(
      'fuel_sale',
      {'taxRequestID': taxRequestID}, // Update the 'Stannumber' column
      where:
          'transactionSeqNo = ?', // Find the record by transactionSeqNo (which corresponds to 'stan')
      whereArgs: [
        transactionSeqNo
      ], // The transactionSeqNo used for matching the transaction
    );

    print(
        "taxRequestID updated for transactionSeqNo $transactionSeqNo to $taxRequestID");
  }

  Future<List<Map<String, dynamic>>> getFuelSalesWithUuidNotGenerated() async {
    // Get the database instance
    final db = await database;

    // Query to get all rows where Isuuidgenerate is false
    final result = await db.query(
      'fuel_sale', // Table name
      where: 'Isuuidgenerate = ?', // Condition
      whereArgs: ['False'], // Argument for the condition
    );
    print("resultresultresult${result}");

    return result; // Returns the list of maps (rows)
  }

  Future<List<Map<String, dynamic>>> fetchDataByShift(int shift) async {
    final db =
        await database; // Replace with your database initialization logic
    try {
      final List<Map<String, dynamic>> transactions = await db.query(
        'fuel_sale', // Replace with your actual table name
        where: 'shift_id = ?',
        whereArgs: [shift],
      );
      return transactions;
    } catch (e) {
      print("Error fetching data by shift: $e");
      return [];
    }
  }
}
