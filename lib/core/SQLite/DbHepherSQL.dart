// ignore_for_file: unused_local_variable, file_names, non_constant_identifier_names

import 'package:ecm_application/Model/Project/ECMTool/ECM_Checklist_Model.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSChackListModel.dart';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _databaseVersion = 1;

//Checklist Create table
class DBSQL {
  static const _databaseName = "SQLDbsss.db3";
  final table = 'SQL_tbl';
  final id = "id";
  final checkListId = "checkListId";
  final subProcessId = "subProcessId";
  final processId = "processId";
  final description = "description";
  final seqNo = "seqNo";
  final inputType = "inputType";
  final inputText = "inputText";
  final value = "value";
  final subProcessName = "subProcessName";
  final processName = "processName";
  final approvedStatus = "approvedStatus";
  final workedBy = "workedBy";
  final workedOn = "workedOn";
  final approvedBy = "approvedBy";
  final approvedOn = "approvedOn";
  final tempDT = "tempDT";
  final remark = "remark";
  final approvalRemark = "approvalRemark";
  final isMultiValue = "isMultiValue";
  final subChakQty = "subChakQty";
  final deviceType = "deviceType";
  final downlink = "downlink";
  final macAddress = "macAddress";
  final subscribeTopicName = "subscribeTopicName";
  final parameterName = "parameterName";
  final comment = "comment";
  final coordinate = "coordinate";
  final dataType = "dataType";
  final source = "source";
  final deviceId = "deviceId";
  final conString = "conString";
  final userId = "userId";
  final siteTeamEngineer = "siteTeamEngineer";
  final imageByteArray = "imageByteArray";
  final image = "image";
  final issaved = "issaved";
  final issiteTeamEngineer = "issiteTeamEngineer";
  DBSQL._privateConstructor();
  static final DBSQL instance = DBSQL._privateConstructor();

  // static late Database _database;
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, final version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT, 
     $processId  INTEGER ,
     $subProcessId INTEGER ,
     $checkListId INTEGER,
     $description  TEXT,
     $seqNo INTEGER ,
     $inputType  TEXT,
     $inputText TEXT,
     $value TEXT,
     $subProcessName TEXT,
     $processName TEXT ,
     $approvedStatus INTEGER,
     $workedBy INTEGER,
     $workedOn TEXT,
     $approvedBy INTEGER,
     $approvedOn TEXT,
     $tempDT TEXT,
     $remark TEXT,
     $approvalRemark TEXT,
     $isMultiValue INTEGER,
     $subChakQty INTEGER,
     $deviceType TEXT,
     $downlink TEXT,
     $macAddress TEXT,
     $subscribeTopicName TEXT,
     $parameterName TEXT,
     $comment TEXT,
     $coordinate TEXT,
     $dataType TEXT,
     $source TEXT,
     $deviceId INTEGER,
     $conString TEXT,
     $userId INTEGER,
     $siteTeamEngineer TEXT,
     $imageByteArray TEXT,
     $issaved TEXT,
     $image BLOB,
     $issiteTeamEngineer bool
       )
    ''');
    print("database table created");
  }

//insert data
  void insert(Map<String, dynamic> value) async {
    Database db = await instance.database;
    //await _database!.delete("SQL_tbl");
    print("insert data");
    await db.insert(table, value);
    //checkTable(_database!, table);
  }

  void SQLUpdatedata(ECM_Checklist_Model value) async {
    final db = await database;
    await db.update(
      table,
      value.toJson(),
      where: 'checkListId = ? and deviceId= ?',
      whereArgs: [value.checkListId, value.deviceId],
    );
  }

  Future DeleteCheckList(ECM_Checklist_Model value) async {
    final db = await database;
    await db.delete(
      table,
      where: 'checkListId = ? and deviceId= ? and subProcessId=?',
      whereArgs: [value.checkListId, value.deviceId, value.subProcessId],
    );
  }

  //fatch data from ams oms lora and rms
  Future<List<ECM_Checklist_Model>> fatchdataSQLNew() async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table");
    print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // image: maps[i]['image'],
          // : maps[i]['approvedOn'],

          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  //for procee and subprocess
  Future<List<ECM_Checklist_Model>> fatchdataSQLAll(
      int deviceId, int processId) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

//fatch data
  Future<List<ECM_Checklist_Model>> fatchdataSQLbydid(
      int deviceId, int processId) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          // image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> fatchdataSQL(
      int deviceId, int processId, String deviceType) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId AND deviceType='$deviceType'");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          // image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> fatchdataSQLfatch(
      int deviceId, int processId, String processname) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId AND processName='$processname'");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          // image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> fatchdataSQLProcess(int deviceId,
      int processId, String deviceType, String selectprocess) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId AND source='$deviceType' AND processName='$selectprocess'");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          // image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> fatchdataSQCommon(int deviceId) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where deviceId=$deviceId");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          // image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

//image list fatch
  Future<List<ECM_Checklist_Model>> fatchdataSQLImage(
      int deviceId, int processId) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId AND inputType='image'");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          //image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> getdatabyId(
      int deviceId, int processId, String source) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId AND source=$source");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],

          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> getdataby(
      int deviceId, int processId) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceId=$deviceId AND processId=$processId");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          // image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  //fatch data
  Future<List<ECM_Checklist_Model>> fatchdataSQL1(String Source) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where source=$Source ");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],

          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

  Future<List<ECM_Checklist_Model>> fatchdataSQLbyDeviceId(int deviceId) async {
    // checkTable(_database!, table);
    // Get a reference to the database.
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where deviceId=$deviceId");
    print(maps);
    return List.generate(maps.length, (i) {
      return ECM_Checklist_Model(
          processId: maps[i]['processId'],
          approvalRemark: maps[i]['approvalRemark'],
          subProcessId: maps[i]['subProcessId'],
          description: maps[i]['description'],
          subProcessName: maps[i]['subProcessName'],
          checkListId: maps[i]['checkListId'],
          value: maps[i]['value'],
          approvedStatus: maps[i]['approvedStatus'],
          remark: maps[i]['remark'],
          source: maps[i]['source'],
          deviceId: maps[i]['deviceId'],
          conString: maps[i]['conString'],
          userId: maps[i]['userId'],
          workedBy: maps[i]['workedBy'],
          workedOn: maps[i]['workedOn'],
          approvedBy: maps[i]['approvedBy'],
          approvedOn: maps[i]['approvedOn'],
          seqNo: maps[i]['seqNo'],
          inputText: maps[i]['inputText'],
          inputType: maps[i]['inputType'],
          tempDT: maps[i]['tempDT'],
          isMultiValue: maps[i]['isMultiValue'],
          subChakQty: maps[i]['subChakQty'],
          deviceType: maps[i]['deviceType'],
          downlink: maps[i]['downlink'],
          macAddress: maps[i]['macAddress'],
          subscribeTopicName: maps[i]['subscribeTopicName'],
          parameterName: maps[i]['parameterName'],
          comment: maps[i]['comment'],
          coordinate: maps[i]['coordinate'],
          dataType: maps[i]['dataType'],
          imageByteArray: maps[i]['imageByteArray'],
          processName: maps[i]['processName'],
          issaved: maps[i]['issaved'],
          // : maps[i]['approvedOn'],
          //image: maps[i]['image'],
          siteTeamEngineer: maps[i]['siteTeamEngineer']);
    });
  }

//delete data

  Future deleteCheckListData(
    int deviceId,
    int processId,
  ) async {
    // String query = 'DELETE FROM SQL_tbl WHERE deviceId = 1760 AND processId = 5';
    await _database!.delete("SQL_tbl",
        where: 'deviceId=$deviceId AND processId=$processId');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

//Pms list create table
class ListViewModel {
  static const _databaseName = "PMS.db3";
  final table = 'New_tbl';
  final id = "id";
  final omsId = 'omsId';
  final chakNo = "chakNo";
  final amsId = "amsId";
  final amsNo = "amsNo";
  final rmsId = "rmsId";
  final rmsNo = "rmsNo";
  final isChecking = "isChecking";
  final gateWayId = "gateWayId";
  final gatewayNo = "gatewayNo";
  final gatewayName = "gatewayName";
  final process1 = "process1";
  final process2 = "process2";
  final process3 = "process3";
  final process4 = "process4";
  final process5 = "process5";
  final process6 = "process6";
  final areaName = "areaName";
  final description = "description";
  final mechanical = "mechanical";
  final erection = "erection";
  final dryCommissioning = "dryCommissioning";
  final wetCommissioning = "wetCommissioning";
  final autoDryCommissioning = "autoDryCommissioning";
  final autoWetCommissioning = "autoWetCommissioning";
  final trenching = "trenching";
  final pipeInatallation = "pipeInatallation";
  final chainage = "chainage";
  final coordinates = "coordinates";
  final networkType = "networkType";
  final deviceType = "deviceType";
  final deviceId = "deviceId";
  final deviceNo = "deviceNo";
  final deviceName = "deviceName";
  final projectName = "projectName";

  ListViewModel._privateConstructor();
  static final ListViewModel instance = ListViewModel._privateConstructor();

  // static late Database _database;
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, final version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
     $omsId  INTEGER ,
     $chakNo TEXT ,
     $amsId INTEGER ,
     $amsNo  TEXT,
     $rmsId INTEGER ,
     $rmsNo  TEXT,
     $isChecking INTEGER,
     $gateWayId INTEGER ,
     $gatewayNo TEXT,
     $gatewayName TEXT ,
     $process1 TEXT,
     $process2 TEXT,
     $process3 TEXT,
     $process4 TTEXT,
     $process5 TEXT,
     $process6 TEXT,
     $areaName TEXT,
     $description TEXT,
     $mechanical TEXT,
     $erection TEXT,
     $dryCommissioning TEXT,
     $wetCommissioning TEXT,
     $autoDryCommissioning TEXT,
     $autoWetCommissioning TEXT,
     $trenching TEXT,
     $pipeInatallation TEXT,
     $chainage INTEGER,
     $coordinates TEXT,
     $networkType TEXT,
     $deviceType TEXT,
     $deviceId INTEGER ,
     $deviceNo TEXT,
     $deviceName TEXT,
     $projectName TEXT
       )
    ''');
    print("database table created");
  }

//insert data
  Future insert(Map<String, dynamic> value) async {
    Database db = await instance.database;
    // await _database!.delete("New_tbl");
    await db.insert(table, value);
    print("insert data");
  }

  //update  data
  void NewUpdatedata(PMSListViewModel value) async {
    final db = await database;
    await db.update(
      table,
      value.toJson(),
      where: 'omsId= ?',
      whereArgs: [value.omsId],
    );
    // checkTable(_database!, table);
  }

//fatch data
  Future<List<PMSListViewModel>> fatchdataPMSViewData() async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table");
    print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

// fatching list by projectname
  Future<List<PMSListViewModel>> fatchdataPMSViewList(
      String projectName, String deviceType) async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where projectName='$projectName' AND deviceType='$deviceType'");
    // print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

//for oms
  Future<List<PMSListViewModel>> fatchdataPMSView11oms(int omsId) async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where omsId=$omsId");
    // print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

//for amsid
  Future<List<PMSListViewModel>> fatchdataPMSView11Ams(int amsId) async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where amsId=$amsId");
    print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

// for getway
  Future<List<PMSListViewModel>> fatchdataPMSView11getway(
      int getwaymsId) async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where gateWayId=$getwaymsId");
    print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

// for rms
  Future<List<PMSListViewModel>> fatchdataPMSView11rms(int rmsId) async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table where rmsId=$rmsId");
    print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

//for common
  Future<List<PMSListViewModel>> fatchcommonlist(
      String source, String projectname) async {
    final db = await database;
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where deviceType='$source' AND projectName='$projectname'");
    print(maps);
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSListViewModel(
          omsId: maps[i]['omsId'],
          amsNo: maps[i]['amsNo'],
          gateWayId: maps[i]['gateWayId'],
          gatewayName: maps[i]['gatewayName'],
          gatewayNo: maps[i]['gatewayNo'],
          rmsId: maps[i]['rmsId'],
          rmsNo: maps[i]['rmsNo'],
          areaName: maps[i]['areaName'],
          deviceId: maps[i]['deviceId'],
          deviceName: maps[i]['deviceName'],
          deviceNo: maps[i]['deviceNo'],
          deviceType: maps[i]['deviceType'],
          networkType: maps[i]['networkType'],
          autoDryCommissioning: maps[i]['autoDryCommissioning'],
          autoWetCommissioning: maps[i]['autoWetCommissioning'],
          chainage: maps[i]['chainage'],
          amsId: maps[i]['amsId'],
          chakNo: maps[i]['chakNo'],
          coordinates: maps[i]['coordinates'],
          description: maps[i]['description'],
          isChecking: maps[i]['isChecking'],
          dryCommissioning: maps[i]['dryCommissioning'],
          wetCommissioning: maps[i]['wetCommissioning'],
          erection: maps[i]['erection'],
          pipeInatallation: maps[i]['pipeInatallation'],
          mechanical: maps[i]['mechanical'],
          process1: maps[i]['process1'],
          process2: maps[i]['process2'],
          process3: maps[i]['process3'],
          process4: maps[i]['process4'],
          process5: maps[i]['process5'],
          process6: maps[i]['process6'],
          projectName: maps[i]['projectName'],
          trenching: maps[i]['trenching']);
    });
  }

//
//delete data
  Future deleteListDataoms(int deviceId) async {
    // String query = 'DELETE FROM SQL_tbl WHERE deviceId = 1760 AND processId = 5';
    await _database!.delete("New_tbl", where: 'omsId=$deviceId ');
    // return true;
  }

  Future deleteListDataams(int deviceId) async {
    // String query = 'DELETE FROM SQL_tbl WHERE deviceId = 1760 AND processId = 5';
    await _database!.delete("New_tbl", where: 'amsId=$deviceId ');
  }

  Future deleteListDatarms(int deviceId) async {
    // String query = 'DELETE FROM SQL_tbl WHERE deviceId = 1760 AND processId = 5';
    await _database!.delete("New_tbl", where: 'rmsId=$deviceId ');
  }

  Future deleteListDatagetway(int deviceId) async {
    // String query = 'DELETE FROM SQL_tbl WHERE deviceId = 1760 AND processId = 5';
    await _database!.delete("New_tbl", where: 'gateWayId=$deviceId ');
  }

  void deleteTable() async {
    await _database!.delete('SQL_tbl');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

//process list create table
class ListModel {
  static const _databaseName = "PMSlist.db3";
  final table = 'pmslist_tbl';
  final id = "id";
  final checkListId = 'checkListId';
  final subProcessId = "subProcessId";
  final processId = "processId";
  final description = "description";
  final seqNo = "seqNo";
  final inputType = "inputType";
  final inputText = "inputText";
  final value = "value";
  final subProcessName = "subProcessName";
  final processName = "processName";
  final approvedStatus = "approvedStatus";
  final workedBy = "workedBy";
  final workedOn = "workedOn";
  final approvedBy = "approvedBy";
  final approvedOn = "approvedOn";
  final tempDT = "tempDT";
  final remark = "remark";
  final approvalRemark = "approvalRemark";
  final imageByteArray = "imageByteArray";
  final isMultiValue = "isMultiValue";
  final subChakQty = "subChakQty";
  final deviceType = "deviceType";
  final downlink = "downlink";
  final macAddress = "macAddress";
  final subscribeTopicName = "subscribeTopicName";
  final parameterName = "parameterName";
  final comment = "comment";
  final dataType = "dataType";
  final source = "source";
  final deviceId = "deviceId";
  final conString = "conString";
  final userId = "userId";
  final siteTeamEngineer = "siteTeamEngineer";

  ListModel._privateConstructor();
  static final ListModel instance = ListModel._privateConstructor();

  // static late Database _database;
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, final version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
     $checkListId  INTEGER ,
     $subProcessId INTEGER ,
     $processId INTEGER,
     $description TEXT,
     $seqNo  TEXT,
     $inputType TEXT ,
     $inputText  TEXT,
     $value INTEGER,
     $subProcessName TEXT,
     $processName TEXT,
     $approvedStatus INTEGER ,
     $workedBy INTEGER,
     $workedOn TEXT,
     $approvedBy INTEGER,
     $approvedOn TTEXT,
     $tempDT TEXT,
     $remark TEXT,
     $approvalRemark,
     $imageByteArray TEXT,
     $isMultiValue TEXT,
     $subChakQty TEXT,
     $deviceType TEXT,
     $downlink TEXT,
     $macAddress TEXT,
     $subscribeTopicName TEXT,
     $parameterName TEXT,
     $comment TEXT,
     $dataType TEXT,
     $source TEXT,
     $deviceId INTEGER,
     $conString TEXT,
     $userId INTEGER,
     $siteTeamEngineer INTEGER
       )
    ''');
    print("database table created");
  }

//insert data
  Future insert(Map<String, dynamic> value) async {
    Database db = await instance.database;
    await _database!.delete("pmslist_tbl");
    await db.insert(table, value);
    print("insert data");
  }

  //update  data
  void NewUpdatedata(PMSChaklistModel value) async {
    // checkTable(_database!, table);
    final db = await database; // Update the given data.
    await db.update(
      table,
      value.toJson(),
      where: 'checkListId = ?',
      whereArgs: [value.checkListId],
    );
    // checkTable(_database!, table);
  }

//fatch data
  Future<List<PMSChaklistModel>> fatchdataPMSListData() async {
    final db = await database;
    var processName = 'ALL PROCESS';
    // Query the table for all The FarmerResponse.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table where processName not like '%All Process%' ");
    // Convert the List<Map<String, dynamic> finalo a List<FarmerResponse>.
    return List.generate(maps.length, (i) {
      return PMSChaklistModel(
        processName: maps[i]['processName'],
        processId: maps[i]['processId'],
        checkListId: maps[i]['checkListId'],
        description: maps[i]['description'],
      );
    });
  }

//delete data

  void deleteTable() async {
    await _database!.delete('SQL_tbl');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
