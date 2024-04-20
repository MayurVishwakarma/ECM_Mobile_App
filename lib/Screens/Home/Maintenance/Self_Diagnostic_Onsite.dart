// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, camel_case_types, use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/Project/HOSupportTeam.dart';

class Self_Diagnostic extends StatefulWidget {
  String? issue;
  String? desc;
  List<int>? hoSupportId;

  Self_Diagnostic({
    this.issue,
    this.desc,
    this.hoSupportId,
  });

  @override
  State<Self_Diagnostic> createState() => _Self_DiagnosticState();
}

class _Self_DiagnosticState extends State<Self_Diagnostic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self Diagnostic Onsite"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.issue!,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Cinzel',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.desc!,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 80),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () async {
                        connect(widget.hoSupportId!);
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(25.0),
                                width: 320,
                                height: 190,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${filteredContacts.first.Name!}',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () {
                                        _launchCaller(
                                            filteredContacts.first.Mobile!);
                                        Navigator.of(context).pop();
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Call: ',
                                            ),
                                            TextSpan(
                                              text: filteredContacts
                                                  .first.Mobile!,
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.indigo.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () {
                                        _launchEmail(
                                            filteredContacts.first.Email!);
                                        Navigator.of(context).pop();
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Email: ',
                                            ),
                                            TextSpan(
                                              text:
                                                  filteredContacts.first.Email!,
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.indigo.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'For additional help, ',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'click here',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                // Add onTap logic here
                              ),
                              TextSpan(
                                text: ' to get in touch with a specialist',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

List<HOSupportTeam> filteredContacts = [];
  void connect(List<int> hoSupportId) async {
    if (hoSupportId.length == 2) {
      filteredContacts = supportTeam
          .where((x) => x.Id == hoSupportId[0] || x.Id == hoSupportId[1])
          .toList();
    } else {
      filteredContacts =
          supportTeam.where((x) => x.Id == hoSupportId[0]).toList();
    }
    setState(() {
      filteredContacts;
      supportTeam;
    });
  }

  void _launchCaller(String contect) async {
    Uri call = Uri(scheme: 'tel', path: contect);

    if (await launchUrl(call)) {
      await launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  var emailAddress =
      'example@example.com'; // Replace with your desired email address

  void _launchEmail(String? Email) async {
    Uri mail = Uri(scheme: 'mailto', path: Email, query: "");
    if (await launchUrl(mail)) {
      await launchUrl(mail);
    } else {
      throw 'Could not launch $mail';
    }
  }

  List<HOSupportTeam> supportTeam = [
    HOSupportTeam(
      Id: 1,
      Name: 'Bhawesh Purani',
      Mobile: '7020149001',
      Email: 'bhavesh@saisanket.in',
    ),
    HOSupportTeam(
      Id: 2,
      Name: 'Rishi Rathod',
      Mobile: '9892209601',
      Email: 'rishi.rathod@gulfautomation.com',
    ),
    HOSupportTeam(
      Id: 3,
      Name: 'Snehal Mithabavkar',
      Mobile: '8169924467',
      Email: 'snehal.m@saisanket.in',
    ),
    // HOSupportTeam(
    //   Id: 4,
    //   Name: 'Bhakti Kothekar',
    //   Mobile: '8308202571',
    //   Email: 'bhakti.kothekar@saisanket.in',
    // ),
    HOSupportTeam(
      Id: 4,
      Name: 'Nitin Naykwadi',
      Mobile: '9623281858',
      Email: 'nitinnkwd14@gmail.com',
    ),
    HOSupportTeam(
      Id: 5,
      Name: 'Mandar Dhanawde(Nimrani)',
      Mobile: '7387646323',
      Email: 'mandar@saisanket.in',
    ),
  ];
}
