// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:ecm_application/Model/Project/ECMTool/PMSListViewModel.dart';
import 'package:ecm_application/Model/Project/Login/ProjectUserModel.dart';
import 'package:ecm_application/Operations/StatelistOperation.dart';
import 'package:ecm_application/Model/Project/Login/State_list_Model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<ProjectModel>? projectList;
  ProjectModel? selectProject;
  List<ProjectsUserModel>? projectUserList;
  ProjectsUserModel? selectedUser;
  List<PMSListViewModel>? nodeList;
  List<PMSListViewModel>? filteredNodeList;

  bool isLoader = true;
  String conString = '';
  String? selectedDeviceType = 'OMS';
  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> deviceTypes = [];
  String query = '';

  var area = 'All';
  var distibutory = 'ALL';

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await getProjectList();
    setState(() => isLoader = false);
    if (selectProject != null) {
      updateDeviceTypes(selectProject!.eCString ?? '');
      updateConstring();
      await getNodeList();
      await fetchProjectUsers();
      filteredNodeList = nodeList;
    }
  }

  Future<void> onProjectSelected(ProjectModel? value) async {
    setState(() {
      selectProject = value;
      selectedUser = null; // Clear selected user
      filteredNodeList = null; // Clear node list
      projectUserList = null; // Clear user list
      isLoader = true; // Show loader
    });

    if (selectProject != null) {
      updateDeviceTypes(selectProject!.eCString ?? '');
      updateConstring();
      await fetchProjectUsers();
      await getNodeList();
    }
    setState(() {
      isLoader = false; // Hide loader after loading data
    });
  }

  void updateDeviceTypes(String eCString) {
    deviceTypes = [];
    if (eCString[0] == '1') deviceTypes.add('OMS');
    if (eCString[1] == '1') deviceTypes.add('AMS');
    if (eCString[2] == '1') deviceTypes.add('RMS');
    if (eCString[3] == '1') deviceTypes.add('Lora');
    selectedDeviceType = deviceTypes.first;
  }

  Future<void> getProjectList() async {
    // Fetch the list of projects (update to match your API or data source)
    projectList = await getStateAuthority();
    selectProject = projectList?.first;
  }

  Future<void> getNodeList() async {
    nodeList = await getProjectNodeList(selectedDeviceType ?? 'oms', conString);
    setState(() {
      filteredNodeList = nodeList;
    });
  }

  void updateConstring() {
    conString = 'Data Source=${selectProject?.hostIp};'
        'Initial Catalog=${selectProject?.project};'
        'User ID=${selectProject?.userName};'
        'Password=${selectProject?.password};';
  }

  Future<void> fetchProjectUsers() async {
    projectUserList = await getProjetsUsers(conString);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _filterChakNo(String searchQuery) {
    setState(() {
      query = searchQuery.toLowerCase();
      filteredNodeList = nodeList?.where((node) {
        switch (selectedDeviceType) {
          case 'OMS':
            return node.chakNo != null &&
                node.chakNo!.toLowerCase().contains(query);
          case 'AMS':
            return node.amsNo != null &&
                node.amsNo!.toLowerCase().contains(query);
          case 'RMS':
            return node.rmsNo != null &&
                node.rmsNo!.toLowerCase().contains(query);
          case 'Lora':
            return node.gatewayName != null &&
                node.gatewayName!.toLowerCase().contains(query);
          default:
            return node.chakNo != null &&
                node.chakNo!.toLowerCase().contains(query);
        }
        // return node.chakNo != null &&
        //     node.chakNo!.toLowerCase().contains(query);
      }).toList();
    });
  }

  final TextEditingController menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildDropdown<ProjectModel>(
                  label: 'Project',
                  value: selectProject,
                  items: projectList ?? [],
                  onChanged: onProjectSelected,
                  itemText: (item) => item.projectName ?? '',
                ),
                buildDropdown<String>(
                  label: 'Device Type',
                  value: selectedDeviceType,
                  items: deviceTypes,
                  onChanged: (value) {
                    setState(() => selectedDeviceType = value);
                    filteredNodeList!.clear();
                    getNodeList();
                  },
                  itemText: (T) => T,
                ),
              ],
            ),
            SizedBox(
              height: 80,
              child: DropdownMenu<ProjectsUserModel>(
                initialSelection: projectUserList?.first,
                controller: menuController,
                width: MediaQuery.of(context).size.width - 16.0,
                hintText: "Select User",
                requestFocusOnTap: true,
                enableFilter: true,
                label: const Text('Select User'),
                onSelected: (ProjectsUserModel? menu) {
                  selectedUser = menu;
                },
                dropdownMenuEntries: (projectUserList ?? [])
                    .map<DropdownMenuEntry<ProjectsUserModel>>(
                        (ProjectsUserModel menu) {
                  return DropdownMenuEntry<ProjectsUserModel>(
                    value: menu,
                    label: '${menu.name} (${menu.mobileNo?.toString().trim()})',
                  );
                }).toList(),
              ),
              /*DropdownButtonFormField<ProjectsUserModel>(
                  isExpanded: true,
                  isDense: true,
                  decoration: const InputDecoration(
                    labelText: 'Users',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedUser,
                  items: projectUserList?.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                          '${item.name} (${item.mobileNo?.toString().trim()})'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedUser = value),
                )
*/
            ),
            SizedBox(
              height: 80,
              child: TextFormField(
                readOnly: true,
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) => _filterChakNo(value),
                decoration: const InputDecoration(
                  labelText: 'Search by Chak No.',
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  suffixIcon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (isLoader)
              const Center(child: CircularProgressIndicator())
            else
              buildChakList(),
            buildAssignNodesButton(),
          ],
        ),
      ),
    );
  }

  String getNodeName(String deviceType, PMSListViewModel? data) {
    try {
      switch (deviceType) {
        case 'OMS':
          return data!.chakNo!;
        case 'AMS':
          return data!.amsNo!;
        case 'RMS':
          return data!.rmsNo!;
        case 'Lora':
          return data!.gatewayName!;
        default:
          return data!.chakNo!;
      }
    } catch (e) {
      return data!.chakNo!;
    }
  }

  Widget buildChakList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredNodeList?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                getNodeName(selectedDeviceType!, filteredNodeList?[index]) ??
                    '-'),
            subtitle: Text(
                '(${filteredNodeList?[index].areaName ?? '-'} - ${filteredNodeList?[index].description ?? '-'})'),
            trailing: Checkbox(
              value: filteredNodeList?[index].isSelected ?? false,
              onChanged: (value) {
                setState(() {
                  filteredNodeList?[index].isSelected = value;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) itemText,
  }) {
    return SizedBox(
      height: 80,
      width: 200,
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        isDense: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(itemText(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildAssignNodesButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () {
          if (selectedUser == null ||
              selectedDate == null ||
              nodeList?.any((node) => node.isSelected == true) == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Please select a user, date, and at least one node to assign.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          List<PMSListViewModel>? selectedNodes =
              nodeList?.where((node) => node.isSelected == true).toList();
          // String omsIdList =
          //     selectedNodes?.map((node) => node.omsId).join(', ') ?? '';
          String omsIdList = selectedNodes!.map((node) {
            switch (selectedDeviceType) {
              case 'OMS':
                return node.omsId;
              case 'AMS':
                return node.amsId;
              case 'RMS':
                return node.rmsId;
              case 'Lora':
                return node.gateWayId;
              default:
                return node.omsId;
            }
          }).join(', ');
          assignNodes(
              context,
              selectedUser?.userId.toString(),
              selectedDeviceType,
              DateFormat('yyyy-MM-dd').format(selectedDate!),
              omsIdList,
              conString);
        },
        child: const SizedBox(
          height: 50,
          child: Center(
            child: Text(
              "Assign Nodes",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> assignNodes(BuildContext context, String? userId, String? source,
      String? assignDate, String? nodeListId, String? conString) async {
    try {
      final res = await http.get(Uri.parse(
          'http://wmsservices.seprojects.in/api/Project/assignNodes?userid=${userId}&assignDate=${assignDate}&source=${source}&omsList=${nodeListId}&conString=${conString}'));

      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.body);
        // Check the status in JSON response
        if (jsonResponse is List && jsonResponse[0]['Status'] == 'Success') {
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nodes are assigned successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear the selected nodes
          clearSelectedNodes();
        } else {
          // Show error snackbar if status is not success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(jsonResponse['message'] ?? 'Failed to assign nodes.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw Exception('Failed to load API');
      }
    } catch (err) {
      // Show error snackbar in case of exception
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load API'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to clear selected nodes
  void clearSelectedNodes() {
    for (var node in nodeList!) {
      node.isSelected = false;
    }
  }
}
/*
Future<List<ProjectModel>> getStateAuthority() async {
  // Placeholder function to fetch project list (replace with API call)
  return [];
}

Future<List<ProjectsUserModel>> getProjetsUsers(String conString) async {
  // Placeholder function to fetch project users (replace with API call)
  return [];
}

Future<List<PMSListViewModel>> getProjectNodeList(
    String? source, String conString) async {
  // Placeholder function to fetch node list (replace with API call)
  return [];
}
*/