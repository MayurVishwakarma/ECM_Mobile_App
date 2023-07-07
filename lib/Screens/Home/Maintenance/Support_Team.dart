// import 'package:flutter/material.dart';

// import '../../../Model/Project/HOSupportTeam.dart';

// class PopupHOSupport extends StatelessWidget {
//   List<int>? contect;

//   PopupHOSupport({
//     this.contect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // var supportTeam = supportTeam;

//     List<HOSupportTeam> filteredContacts = [];
//     if (contact.length == 2) {
//       filteredContacts = supportTeam
//           .where((x) => x.Id == contact[0] || x.Id == contact[1])
//           .toList();
//     } else {
//       filteredContacts = supportTeam.where((x) => x.Id == contact[0]).toList();
//     }

//     return Scaffold(
//       body: ListView.builder(
//         itemCount: filteredContacts.length,
//         itemBuilder: (context, index) {
//           var contact = filteredContacts[index];
//           return ListTile(
//             title: Text(contact.Name!),
//             subtitle: Text(contact.Mobile!),
//           );
//         },
//       ),
//     );
//   }

//   List<HOSupportTeam> supportTeam = [
//     HOSupportTeam(
//       Id: 1,
//       Name: 'Bhawesh Purani',
//       Mobile: '7020149001',
//       Email: 'bhavesh@saisanket.in',
//     ),
//     HOSupportTeam(
//       Id: 2,
//       Name: 'Rishi Rathod',
//       Mobile: '9892209601',
//       Email: 'rishi.rathod@gulfautomation.com',
//     ),
//     HOSupportTeam(
//       Id: 3,
//       Name: 'Snehal Mithabavkar',
//       Mobile: '8169924467',
//       Email: 'snehal.m@saisanket.in',
//     ),
//     HOSupportTeam(
//       Id: 4,
//       Name: 'Bhakti Kothekar',
//       Mobile: '8308202571',
//       Email: 'bhakti.kothekar@saisanket.in',
//     ),
//     HOSupportTeam(
//       Id: 5,
//       Name: 'Nitin Naykwadi',
//       Mobile: '9623281858',
//       Email: 'nitinnkwd14@gmail.com',
//     ),
//     HOSupportTeam(
//       Id: 6,
//       Name: 'Mandar Dhanawde(Nimrani)',
//       Mobile: '7387646323',
//       Email: 'mandar@saisanket.in',
//     ),
//   ];
// }
