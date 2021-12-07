import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/model.dart';

class DatabaseHelper {
  DatabaseHelper();
  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  //set path for db
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print('db location :$documentsDirectory.path');
    String path = join(documentsDirectory.path, 'job.db');
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  //create a database
  Future onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE jobTable(id TEXT, sId TEXT, cId TEXT ,collectionDate TEXT, name TEXT, location TEXT)''');
  }

  Future<List<JobModel>> getJobDetails() async {
    Database db = await instance.database;
    var job = await db.query('jobTable', orderBy: 'sId');
    List<JobModel> jobList =
        job.isNotEmpty ? job.map((val) => JobModel.fromJson(val)).toList() : [];
    return jobList;
  }

  // insert data
  Future<int> addJob(JobModel jobModel) async {
    Database db = await instance.database;
    return await db.insert('jobTable', jobModel.toMap());
  }

  //delete data
  Future<int> deleteJob() async {
    Database db = await instance.database;
    return await db.delete('jobTable');
  }

  Future<List<JobModel>> getJobList() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> jobMaps = await db.query("jobTable");
    //print("data $jobMaps");
    return List.generate(
        jobMaps.length,
        (index) => JobModel(
            id: jobMaps[index]['id'],
            sId: jobMaps[index]['sId'],
            cId: jobMaps[index]['cId'],
            collectionDate: jobMaps[index]['collectionDate'],
            name: jobMaps[index]['name'],
            location: jobMaps[index]['location']));
  }

  Future<List<JobModel>> previousData(String sampleId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> sampleIdList =
        await db.rawQuery('SELECT * FROM jobTable WHERE sId = $sampleId');
    print(sampleIdList);
    return List.generate(
        sampleIdList.length,
        (index) => JobModel(
            id: sampleIdList[index]['id'],
            sId: sampleIdList[index]['sId'],
            cId: sampleIdList[index]['cId'],
            collectionDate: sampleIdList[index]['collectionDate'],
            name: sampleIdList[index]['name'],
            location: sampleIdList[index]['location']));
  }

  // Future<int> updateData(JobModel jobModel) async {
  //   Database db = await instance.database;
  //   final int count = await db.rawUpdate(
  //       'UPDATE jobTable SET id = ?, sId = ?, cId = ?, collectionDate = ?, name = ?, location = ? WHERE sId = ? ',
  //       [
  //         jobModel.id,
  //         jobModel.sId,
  //         jobModel.cId,
  //         jobModel.collectionDate,
  //         jobModel.name,
  //         jobModel.location
  //       ]);
  //   return count;
  // }
  Future updateData(String sampleId, JobModel jobModel) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> sampleIdList =
        await db.rawQuery('SELECT * FROM jobTable WHERE sId = $sampleId');
    if (sampleIdList.isNotEmpty) {
      final int count = await db.rawUpdate(
          'UPDATE jobTable SET id = ?, sId = ?, cId = ?, collectionDate = ?, name = ?, location = ? WHERE sId = $sampleId ',
          [
            jobModel.id,
            jobModel.sId,
            jobModel.cId,
            jobModel.collectionDate,
            jobModel.name,
            jobModel.location
          ]);
      return count;
    } else {
      return null;
    }
  }
}



  // Future<int> updateData(JobModel jobModel) async {
  //   Database db = await instance.database;
  //   return await db.update(
  //       "jobTable", jobModel.toMap(),
  //       where: jobModel.sId='?',
  //       whereArgs: [jobModel.sId]
  //     );
  // }