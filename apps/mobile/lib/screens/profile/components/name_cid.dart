import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:armm_app/database/models/client_model.dart';

class NameAndCID extends StatelessWidget {
  const NameAndCID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client?>(context);
=======
import 'package:armm_app/client_model.dart';

class NameAndCID extends StatelessWidget {
  final Client client;
  final String cid;

  const NameAndCID({
    Key? key,
    required this.client,
    required this.cid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Name and Client ID
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
<<<<<<< HEAD
              "${client?.firstName} ${client?.lastName}",
=======
              "${client.firstName} ${client.lastName}",
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
<<<<<<< HEAD
              'Client ID: ${client?.cid}',
              style: const TextStyle(
=======
              'Client ID: $cid',
              style: TextStyle(
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}