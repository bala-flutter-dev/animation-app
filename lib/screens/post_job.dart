import 'dart:convert';
import 'dart:core';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjobportalapp/models/model.dart';
import 'package:newjobportalapp/screens/homepage.dart';
import 'package:newjobportalapp/services/services.dart';
import 'package:http/http.dart ' as http;
import '../database/db_provider.dart';

class PostJob extends StatefulWidget {
  final List jobIds;
  final int index;
  const PostJob({
    Key? key,
    required this.jobIds,
    required this.index,
  }) : super(key: key);

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  bool backPressed = false;
  String dropdownValue = 'Dart';
  String? selectedDropDownName;

  String myActivity = '';

  ApiServices apiServices = ApiServices();

  var dbHelper = DatabaseHelper();

  TextEditingController sampleController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController collectionDateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dropName = TextEditingController();

  int initialSampleId = 01;

  String sampleIdIncrement() {
    setState(() {
      initialSampleId++;
    });
    return initialSampleId.toString();
  }

  List? nameList;
  Future<List?> _getName() async {
    await http
        .get(Uri.parse("http://106.51.2.102:5280/samplewebapi1/username"))
        .then((response) {
      var data = json.decode(response.body);
      setState(() {
        nameList = data;
      });
    });
    return nameList;
  }

  @override
  void initState() {
    _getName();
    super.initState();
  }

  void updateDropDown() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post New Job"),
        actions: [
          GestureDetector(
              onTap: () {
                dbHelper.getJobList().then((List<JobModel> localData) {
                  if (localData.isNotEmpty) {
                    setState(() {
                      for (int i = 0; i < localData.length; i++) {
                        apiServices.createJob(
                          localData[i].id.toString(),
                          localData[i].sId.toString(),
                          localData[i].cId.toString(),
                          localData[i].collectionDate.toString(),
                          localData[i].name.toString(),
                          localData[i].location.toString(),
                        );
                      }
                    });
                    Navigator.push(
                        (context),
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                    dbHelper.deleteJob();
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saved to Server")));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.save),
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Job Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  initialSampleId <= 9
                      ? "Sample Id : " +
                          widget.jobIds[widget.index]["jbId"] +
                          ".0" +
                          initialSampleId.toString()
                      : "Sample Id : " +
                          widget.jobIds[widget.index]["jbId"] +
                          "." +
                          initialSampleId.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: clientController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Client Id'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'location'),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownFormField(
                  titleText: 'Name',
                  hintText: 'Please choose one',
                  value: myActivity,
                  onSaved: (value) {
                    setState(() {
                      myActivity = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      myActivity = value;
                    });
                  },
                  dataSource: nameList != null ? nameList!.toList() : [],
                  textField: 'username',
                  valueField: 'username',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    initialSampleId > 1
                        ? GestureDetector(
                            onTap: () {
                              // function for showing previous data
                              String decrementSampleId() {
                                int currentSampleId = initialSampleId;
                                currentSampleId--;
                                int reducedSampleId = currentSampleId;
                                String selectedSampleId = initialSampleId <= 9
                                    ? widget.jobIds[widget.index]["jbId"] +
                                        ".0" +
                                        reducedSampleId.toString()
                                    : widget.jobIds[widget.index]["jbId"] +
                                        "." +
                                        reducedSampleId.toString();
                                return selectedSampleId;
                              }

                              dbHelper
                                  .previousData(decrementSampleId())
                                  .then((List<JobModel> previousJobDetail) {
                                setState(() {
                                  clientController.text =
                                      previousJobDetail.first.cId!;
                                  locationController.text =
                                      previousJobDetail.first.location!;
                                  myActivity = previousJobDetail.first.name!;
                                  initialSampleId--;
                                });
                                setState(() {
                                  backPressed = true;
                                });
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 55,
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: const Center(
                                  child: Text(
                                "Back",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              print("Backed");
                              //dbHelper.deleteJob();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 55,
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: const Center(
                                  child: Text(
                                "Back",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        // locally stored
                        if (clientController.text.isNotEmpty &&
                            myActivity.isNotEmpty &&
                            locationController.text.isNotEmpty) {
                          if (backPressed == true) {
                            DatabaseHelper.instance.updateData(
                                initialSampleId <= 9
                                    ? widget.jobIds[widget.index]["jbId"] +
                                        ".0" +
                                        initialSampleId.toString()
                                    : widget.jobIds[widget.index]["jbId"],
                                JobModel(
                                  id: widget.jobIds[widget.index]["uid"]
                                      .toString(),
                                  sId: initialSampleId <= 9
                                      ? widget.jobIds[widget.index]["jbId"] +
                                          ".0" +
                                          initialSampleId.toString()
                                      : widget.jobIds[widget.index]["jbId"],
                                  cId: clientController.text,
                                  collectionDate: DateTime.now().toString(),
                                  name: myActivity,
                                  location: locationController.text,
                                ));
                            sampleIdIncrement();
                            clientController.clear();
                            myActivity = '';
                            locationController.clear();
                          } else {
                            setState(() {
                              DatabaseHelper.instance.addJob(JobModel(
                                id: widget.jobIds[widget.index]["uid"]
                                    .toString(),
                                sId: initialSampleId <= 9
                                    ? widget.jobIds[widget.index]["jbId"] +
                                        ".0" +
                                        initialSampleId.toString()
                                    : widget.jobIds[widget.index]["jbId"],
                                cId: clientController.text,
                                collectionDate: DateTime.now().toString(),
                                name: myActivity,
                                location: locationController.text,
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Saved to SQflite")));
                              sampleIdIncrement();
                              clientController.clear();
                              myActivity = '';
                              locationController.clear();
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Missing Fields")));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10)),
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: const Center(
                            child: Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
