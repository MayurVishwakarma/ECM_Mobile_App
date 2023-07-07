// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../Model/Project/Disnet_Model.dart';
import '../../../Widget/ExpandableTiles.dart';
import 'Search.dart';
import 'Self_Diagnostic_Onsite.dart';

class Disnet_Tool extends StatefulWidget {
  const Disnet_Tool({super.key});

  @override
  State<Disnet_Tool> createState() => _Disnet_ToolState();
}

class _Disnet_ToolState extends State<Disnet_Tool> {
  @override
  void initState() {
    super.initState();
    populateLists();
  }

  // List<SelfDiagnostic>? vm;
  List<SelfDiagnostic>? issueList;
  TextEditingController _searchController = TextEditingController();
  final List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Disnet"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white24),
          child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            controller: _searchController,
                            onTap: () => showSearch(
                                context: context,
                                delegate: ItemSearchDelegate()),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              suffixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTile(
                            title: Text(
                              "Communication Issue",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  fontSize: 18),
                            ),
                            body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Self_Diagnostic(
                                                issue: commList
                                                    .elementAt(index)
                                                    .issue
                                                    .toString(),
                                                desc: commList
                                                    .elementAt(index)
                                                    .desc
                                                    .toString(),
                                                hoSupportId: commList
                                                    .elementAt(index)
                                                    .hoSupportId,
                                              )),
                                      (Route<dynamic> route) => true,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 201, 216, 223)),
                                      child: ListTile(
                                        title: Text(
                                          commList
                                              .elementAt(index)
                                              .issue
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 16
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTile(
                            title: Text(
                              "System Issue",
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  fontSize: 18),
                            ),
                            body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: sysList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Self_Diagnostic(
                                                issue: sysList
                                                    .elementAt(index)
                                                    .issue
                                                    .toString(),
                                                desc: sysList
                                                    .elementAt(index)
                                                    .desc
                                                    .toString(),
                                                hoSupportId: sysList
                                                    .elementAt(index)
                                                    .hoSupportId,
                                              )),
                                      (Route<dynamic> route) => true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 201, 216, 223)),
                                      // color: Color.fromARGB(255, 84, 206, 77),
                                      child: ListTile(
                                        title: Text(
                                          sysList
                                              .elementAt(index)
                                              .issue
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 16
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTile(
                            title: Text(
                              "Process Issue",
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  fontSize: 18),
                            ),
                            body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: procList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Self_Diagnostic(
                                                issue: procList
                                                    .elementAt(index)
                                                    .issue
                                                    .toString(),
                                                desc: procList
                                                    .elementAt(index)
                                                    .desc
                                                    .toString(),
                                                hoSupportId: procList
                                                    .elementAt(index)
                                                    .hoSupportId,
                                              )),
                                      (Route<dynamic> route) => true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 201, 216, 223)),
                                      // color: Color.fromARGB(255, 84, 206, 77),
                                      child: ListTile(
                                        title: Text(
                                          procList
                                              .elementAt(index)
                                              .issue
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 16
                                              // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTile(
                            title: Text(
                              "Operation Issue",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                            body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: opList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Self_Diagnostic(
                                                issue: opList
                                                    .elementAt(index)
                                                    .issue
                                                    .toString(),
                                                desc: opList
                                                    .elementAt(index)
                                                    .desc
                                                    .toString(),
                                                hoSupportId: opList
                                                    .elementAt(index)
                                                    .hoSupportId,
                                              )),
                                      (Route<dynamic> route) => true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 201, 216, 223)),
                                      // color: Color.fromARGB(255, 84, 206, 77),
                                      child: ListTile(
                                        title: Text(
                                          opList
                                              .elementAt(index)
                                              .issue
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 16
                                              // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTile(
                            title: Text(
                              "Irrigation Schedule Issue",
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Lato'),
                            ),
                            body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: irriList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Self_Diagnostic(
                                                issue: irriList
                                                    .elementAt(index)
                                                    .issue
                                                    .toString(),
                                                desc: irriList
                                                    .elementAt(index)
                                                    .desc
                                                    .toString(),
                                                hoSupportId: irriList
                                                    .elementAt(index)
                                                    .hoSupportId,
                                              )),
                                      (Route<dynamic> route) => true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 201, 216, 223)),
                                      child: ListTile(
                                        title: Text(
                                          irriList
                                              .elementAt(index)
                                              .issue
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 16
                                              //  fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpandableTile(
                            title: Text(
                              "Hardware Issue",
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  fontSize: 18),
                            ),
                            body: ListView.builder(
                              shrinkWrap: true,
                              itemCount: hardList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Self_Diagnostic(
                                                issue: hardList
                                                    .elementAt(index)
                                                    .issue
                                                    .toString(),
                                                desc: hardList
                                                    .elementAt(index)
                                                    .desc
                                                    .toString(),
                                                hoSupportId: hardList
                                                    .elementAt(index)
                                                    .hoSupportId,
                                              )),
                                      (Route<dynamic> route) => true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 201, 216, 223)),
                                      child: ListTile(
                                        title: Text(
                                          hardList
                                              .elementAt(index)
                                              .issue
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 16
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ));
  }

  var commList;
  var sysList;
  var procList;
  var opList;
  var irriList;
  var hardList;

  
  void populateLists() async {
    // if (commList == null)
    commList = vm.where((x) => x.category == 'Communication Issue').toList();
    // var commList;
    // commList.forEach((item) => commList.add(item));
    sysList = vm.where((x) => x.category == 'System Issue').toList();
    // sysList.forEach((item) => sysList.add(item));
    procList = vm.where((x) => x.category == 'Process Issue').toList();
    // procList.forEach((item) => procList.add(item));
    opList = vm.where((x) => x.category == 'Operational Issue').toList();
    // opList.forEach((item) => opList.add(item));
    irriList =
        vm.where((x) => x.category == 'Irrigation Schedule Issue').toList();
    // irriList.forEach((item) => irriList.add(item));
    hardList = vm.where((x) => x.category == 'Hardware Issue').toList();
    // hardList.forEach((item) => hardList.add(item));
    //category
// commcat = commList.where((x) => x.category == commList.).toList();
    setState(() {
      commList;
      sysList;
      procList;
      opList;
      irriList;
      hardList;
    });
  }

  List<SelfDiagnostic> vm = [
    SelfDiagnostic(
      issue: "Node Communication fail",
      desc:
          "Check antenna, solar, battery and OMS box physically damaged. Repair faulty items will start communicating.",
      category: "Communication Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "Single controller communication fail",
      desc:
          "Check for the items such as solar, battery, antenna and OMS box physically damaged. Main reason to lose communication is due to power is off or antenna direction is disturbed or damaged.",
      category: "Communication Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "Group of controllers communication problem",
      desc:
          "Check status of LORA gateway and its GSM status, if issues is not solved contact HO Team",
      category: "Communication Issue",
      hoSupportId: [1],
    ),
    SelfDiagnostic(
      issue: "Group of LORA nodes communication fail or LORA gateway fault",
      desc:
          "Main reason to fail LORA gateway is its power failed, antenna is damaged or GSM signal is lost, if issues is not solved contact HO Team",
      category: "Communication Issue",
      hoSupportId: [1],
    ),
    SelfDiagnostic(
      issue: "Fault in LORA Module or LORA gateway",
      desc: "Replace faulty LORA node, if issues is not solved contact HO Team",
      category: "Communication Issue",
      hoSupportId: [1],
    ),
    SelfDiagnostic(
      issue: "All nodes not responding or server fail",
      desc: "Contact HO TEAM ",
      category: "Communication Issue",
      hoSupportId: [2],
    ),
    //system issue
    SelfDiagnostic(
      issue: "WEB SCADA not working",
      desc: "Contact HO TEAM ",
      category: "System Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "Mobile App not working",
      desc: "Contact HO TEAM ",
      category: "System Issue",
      hoSupportId: [3],
    ),
    SelfDiagnostic(
      issue: "To configure new node (OMS or AMS or BPT)",
      desc: "Contact HO TEAM to configure new node ",
      category: "System Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Device ID update after controller changed",
      desc: "Contact HO TEAM to update device ID",
      category: "System Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue:
          "In case of AMS, if Analog input is switched to second input ex: AI1 to AI2",
      desc: "Contact HO TEAM to configure  AMS ",
      category: "System Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Valves changing after interrogation command from WEB SCADA",
      desc: "Contact HO TEAM ",
      category: "System Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "OMS Mode not changing from WEB SCADA",
      desc: "Contact HO TEAM ",
      category: "System Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "ROMS Mode not changing from WEB SCADA",
      desc: "Contact HO TEAM ",
      category: "System Issue",
      hoSupportId: [2],
    ),

    // process issue
    SelfDiagnostic(
      issue: "Last response date and time mismatch observed",
      desc: "Contact HO TEAM",
      category: "Process Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "Showing 0 mtr pressure at inlet or outlet",
      desc:
          "Clean filter, check inlet tubing, check both PT and OMS Board AI points",
      category: "Process Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Showing 100 mtr pressure at inlet or outlet",
      desc:
          "Clean filter, check inlet tubing, check both PT and OMS Board AI points",
      category: "Process Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Showing Low Flow or High Flow or No Flow or Flow Out of Range",
      desc:
          "Clean filter, check inlet tubing, check both PT, check valve position and OMS Board AI points",
      category: "Process Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Latch based solenoids not operating",
      desc: "Clean filter and solenoid base and try to operate",
      category: "Process Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Low Pressure or High Pressure at OMS",
      desc:
          "Clean filter, check inlet tubing, check both PT and OMS Board AI points",
      category: "Process Issue",
      hoSupportId: [4, 5],
    ),
    //operational issue
    SelfDiagnostic(
      issue:
          "Outlet Pressure is higher than Inlet Pressure or filter is chocked",
      desc:
          "Clean filter, check inlet tubing, check both PT and OMS Board AI points",
      category: "Operational Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Flow control mode is not operating",
      desc: "Contact HO TEAM",
      category: "Operational Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue:
          "For OMS default operating mode of PFCMD shall be 'flow control' mode and ROMS shall be in AUTO mode",
      desc:
          "Try to change PFCMD mode to flow control and ROMS mode to AUTO mode from WEB SCADA",
      category: "Operational Issue",
      hoSupportId: [2],
    ),
    //irrigation
    SelfDiagnostic(
      issue: "Irrigation start or stop command is not operating from WEB SCADA",
      desc: "Contact HO TEAM",
      category: "Irrigation Schedule Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "Group Irrigation schedule downloading",
      desc: "Contact HO TEAM",
      category: "Irrigation Schedule Issue",
      hoSupportId: [2],
    ),
    SelfDiagnostic(
      issue: "Irrigation Schedule not operating as per set program",
      desc: "Contact HO TEAM",
      category: "Irrigation Schedule Issue",
      hoSupportId: [2],
    ),
    // hardware issue
    SelfDiagnostic(
      issue: "PFCMD Valve Faulty",
      desc: "Open PFCMD, clean it and refix the faulty part if any",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue:
          "Main controller PCB or solar charger PCB or ROMS PCB found faulty or burnt",
      desc: "Replace faulty PCB and contact HO Team to configure",
      category: "Hardware Issue",
      hoSupportId: [4, 5],
    ),
    SelfDiagnostic(
      issue: "Solar panel or solar cable faulty",
      desc:
          "Replace damaged solar panel. Check solar voltage at charger end. Check cable continuity or replace with new solar cable",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue:
          "Battery faulty or not charging (below 11.2V) or overcharging (above 16.8V)",
      desc:
          "Replace damaged battery. Nominal voltage will be 14.8V and battery range 11.2V to 16.8V",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue: "Pressure Transmitter faulty",
      desc: "Replace damaged PT and recalibrate with proper range",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue: "Position sensor faulty",
      desc: "Replace damaged Position sensor and recalibrate with proper range",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue: "Door switch faulty",
      desc:
          "Check wires are disconnected. If the switch is damaged, replace it",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue: "OMS controller box got damaged",
      desc: "OMS box is damaged, replace it with a new box",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue: "Antenna damage or direction shifted",
      desc:
          "Replace damaged Antenna. Change antenna direction towards its Gateway direction",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
    SelfDiagnostic(
      issue: "On/off valve faulty",
      desc: "Open ON/OFF Valve, clean it and refix the faulty part if any",
      category: "Hardware Issue",
      hoSupportId: [6],
    ),
  ];
}
