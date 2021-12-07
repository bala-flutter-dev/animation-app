import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjobportalapp/database/db_provider.dart';
import 'package:newjobportalapp/services/services.dart';
import 'package:http/http.dart ' as http;
import 'post_job.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //sqflite instance
  var dbHelper = DatabaseHelper();

  // api class instance
  ApiServices apiServices = ApiServices();

  // list for api
  List jobIds = [];
  Future<String> fetchJobIds() async {
    var response = await http.get(
        Uri.parse("http://106.51.2.102:5280/samplewebapi1/showJobList"),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      setState(() {
        jobIds = jsonDecode(response.body);
      });
    }
    return "Success";
  }

  List sampleIds = [];
  Future<String> fetchsampleId() async {
    var response = await http.get(
        Uri.parse("http://106.51.2.102:5280/samplewebapi1/allSampleData"),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      setState(() {
        sampleIds = jsonDecode(response.body);
      });
    }
    return "Success";
  }

  @override
  void initState() {
    fetchJobIds();
    fetchsampleId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Job portal"),
          ),
          body: RefreshIndicator(
            onRefresh: fetchsampleId,
            child: ListView.builder(
                itemCount: jobIds.length,
                itemBuilder: (BuildContext context, int index) {
                  return RefreshIndicator(
                    onRefresh: fetchJobIds,
                    child: ExpansionTile(
                      leading: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                (context),
                                MaterialPageRoute(
                                    builder: (context) => PostJob(
                                          index: index,
                                          jobIds: jobIds,
                                        )));
                          },
                          child: const Icon(Icons.add)),
                      title: Text(
                          "Job ID : " + jobIds[index]["jbId"].toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: sampleIds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Text(
                                      "Sample Id : " + sampleIds[index]["sId"],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )));
                          },
                        )
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
