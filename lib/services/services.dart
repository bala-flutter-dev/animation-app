import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:newjobportalapp/models/model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<JobModel>> fetchJob() async {
    var response = await http
        .get(Uri.parse("http://106.51.2.102:5280/samplewebapi1/jobid"));
    var jobResult = <JobModel>[];
    if (response.statusCode == 200) {
      var jobsJson = json.decode(response.body);
      for (var job in jobsJson) {
        jobResult.add(JobModel.fromJson(job));
        print(jobResult);
      }
    }
    return jobResult;
  }

  Future<List<JobModel>> fetchSampleData() async {
    String url = "http://106.51.2.102:5280/samplewebapi1/allSampleData";
    var response = await http.get(Uri.parse(url));
    var displayResult = <JobModel>[];
    if (response.statusCode == 200) {
      var datasJson = json.decode(response.body);
      for (var dataJson in datasJson) {
        displayResult.add(JobModel.fromJson(dataJson));
        print(displayResult);
      }
    }
    return displayResult;
  }

  // Future<List<JobModel>> postJob(String jobId, String sId, String cId,
  //     String collectionDate, String name, String location) async {
  //   var response = await http.get(
  //     Uri.parse(
  //         "http://192.168.43.254:45455/postJobList?jobId=$jobId&sId=$sId&cId=$cId&collectionDate=$collectionDate&name=$name&location=$location"),
  //   );
  //   var jobResult = <JobModel>[];
  //   if (response.statusCode == 200) {
  //     var jobsJson = json.decode(response.body);
  //     for (var job in jobsJson) {
  //       jobResult.add(JobModel.fromJson(job));
  //       print(jobResult);
  //     }
  //   } else {
  //     print("Server error");
  //   }
  //   return jobResult;
  // }

  Future<void> createJob(String id, String sId, String cId,
      String collectionDate, String name, String location) async {
    var response = await http.get(Uri.parse(
        "http://106.51.2.102:5280/samplewebapi1/postJobList?id=$id&sId=$sId&cId=$cId&collectionDate=$collectionDate&name=$name&location=$location"));
    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        "Data saved",
      );
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
