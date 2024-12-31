// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Model/Project/Ecm-History/EcmHistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcmHistoryScreen extends StatefulWidget {
  final PMSListViewModel nodeDetails;
  final String? source;

  const EcmHistoryScreen({required this.nodeDetails, this.source, super.key});

  @override
  State<EcmHistoryScreen> createState() => _EcmHistoryScreenState();
}

class _EcmHistoryScreenState extends State<EcmHistoryScreen> {
  PMSListViewModel? nodeData;
  List<EcmHistoryModel> ecmHistoty = [];
  @override
  void initState() {
    nodeData = widget.nodeDetails;
    firstLoad();
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(loadMore);
    super.dispose();
  }

  String getNodeName(String? source) {
    try {
      switch (source) {
        case 'OMS':
          return nodeData!.chakNo!;
        case 'AMS':
          return nodeData!.amsNo;
        case 'RMS':
          return nodeData!.rmsNo;
        case 'LORA':
          return nodeData!.gatewayName;
        default:
          return '-';
      }
    } catch (ex) {
      return 'NA';
    }
  }

  int getDeviceId(String? source) {
    try {
      switch (source?.toUpperCase()) {
        case 'OMS':
          return nodeData!.omsId!;
        case 'AMS':
          return nodeData!.amsId!;
        case 'RMS':
          return nodeData!.rmsId!;
        case 'LORA':
          return nodeData!.gateWayId!;
        default:
          return 0;
      }
    } catch (ex) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${getNodeName(widget.source?.toUpperCase())} History Report'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
                controller: _controller,
                interactive: true,
                thickness: 10,
                radius: const Radius.circular(15),
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _isFirstLoadRunning
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ecmHistoty.length,
                            itemBuilder: (context, index) {
                              EcmHistoryModel data = ecmHistoty[index];
                              return NodeHistoryWidget(
                                data: data,
                                deviceType: widget.source!,
                              );
                            },
                          ),
                          const SizedBox(height: 150),
                          // when the _loadMore function is running
                          if (_isLoadMoreRunning == true) Container(),
                          // Center(
                          //   child: CircularProgressIndicator(),
                          // ),

                          // When nothing else to load
                          if (_hasNextPage == false) Container(),
                        ]),
                )),
          )
        ],
      ),
    );
  }

  int _page = 0;
  final int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  // This function will be called when the app launches (see the initState function)
  void firstLoad() async {
    setState(() {
      _page = 0;
      _isFirstLoadRunning = true;
      _hasNextPage = true;
      _isFirstLoadRunning = false;
      _isLoadMoreRunning = false;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? conString = preferences.getString('ConString');

      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/PMS/GetEcmHistory?deviceId=${getDeviceId(widget.source)}&startdate=01-01-1900&enddate=01-01-1900&pageindex=0&pagesize=10&source=${widget.source}&conString=$conString'));
      print(
          'http://wmsservices.seprojects.in/api/PMS/GetEcmHistory?deviceId=${getDeviceId(widget.source)}&startdate=01-01-1900&enddate=01-01-1900&pageindex=0&pagesize=10&source=${widget.source}&conString=$conString');

      var json = jsonDecode(res.body);
      List<EcmHistoryModel> fetchedData = <EcmHistoryModel>[];
      json.forEach((e) => fetchedData.add(EcmHistoryModel.fromJson(e)));
      ecmHistoty = [];
      if (fetchedData.isNotEmpty) {
        setState(() {
          ecmHistoty.addAll(fetchedData);
        });
      }
    } catch (err) {}

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
        _page += 1; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        //int? userid = preferences.getInt('userid');
        String? conString = preferences.getString('ConString');
        //String? project = preferences.getString('project');

        final res = await http.get(Uri.parse(
            'http://wmsservices.seprojects.in/api/PMS/GetEcmHistory?deviceId=${getDeviceId(widget.source)}&startdate=01-01-1900&enddate=01-01-1900&pageindex=${_page}&pagesize=${_limit}&source=${widget.source}&conString=$conString'));

        var json = jsonDecode(res.body);
        List<EcmHistoryModel> fetchedData = <EcmHistoryModel>[];
        json.forEach((e) => fetchedData.add(EcmHistoryModel.fromJson(e)));
        if (fetchedData.isNotEmpty) {
          setState(() {
            ecmHistoty.addAll(fetchedData);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }
}

class NodeHistoryWidget extends StatelessWidget {
  const NodeHistoryWidget(
      {super.key, required this.data, required this.deviceType});

  final EcmHistoryModel data;
  final String deviceType;

  getprocessstatus(String pro, int proStatus) {
    String imagepath = 'assets/images/pending.png';
    try {
      if (pro.toLowerCase().contains('auto')) {
        if (proStatus == 1) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      } else if (pro.toLowerCase().contains('dry comm')) {
        if (proStatus == 1) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      } else {
        if (proStatus == 1) {
          imagepath = 'assets/images/Partially.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 4) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      }
    } catch (ex, _) {
      imagepath = 'assets/images/notcompletted.png';
    }
    return imagepath;
  }

  String getApprovestatus(String pro, int proStatus) {
    String imagepath = 'Pending';
    try {
      if (pro.toLowerCase().contains('auto')) {
        if (proStatus == 1) {
          imagepath = 'Completed';
        } else if (proStatus == 2) {
          imagepath = 'Approved';
        } else if (proStatus == 3) {
          imagepath = 'Commented';
        } else {
          imagepath = 'Pending';
        }
      } else if (pro.toLowerCase().contains('dry comm')) {
        if (proStatus == 1) {
          imagepath = 'Completed';
        } else if (proStatus == 2) {
          imagepath = 'Approved';
        } else if (proStatus == 3) {
          imagepath = 'Commented';
        } else {
          imagepath = 'Pending';
        }
      } else {
        if (proStatus == 1) {
          imagepath = 'Partially';
        } else if (proStatus == 2) {
          imagepath = 'Completed';
        } else if (proStatus == 3) {
          imagepath = 'Approved';
        } else if (proStatus == 4) {
          imagepath = 'Commented';
        } else {
          imagepath = 'Pending';
        }
      }
    } catch (ex, _) {
      imagepath = 'Pending';
    }
    return imagepath;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
                blurRadius: 3.5, offset: Offset(1, 0.5), spreadRadius: 0.5)
          ]),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Date: ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(DateFormat('yyyy-MMM-dd').format(data.changedOn!))
            ],
          ),
          Row(
            children: [
              const Text(
                'Process Name : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(data.processName ?? '-')
            ],
          ),
          Row(
            children: [
              const Text(
                'Approve Status : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(getApprovestatus(
                  data.processName ?? '', data.approvedStatus ?? 0))
            ],
          ),
          Row(
            children: [
              const Text(
                'Submitted By : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(data.username ?? '-')
            ],
          ),
          Row(
            children: [
              const Text(
                'Remark : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  (data.remark ?? '-'),
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
