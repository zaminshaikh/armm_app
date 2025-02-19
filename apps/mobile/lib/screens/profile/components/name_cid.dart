import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======
import 'package:provider/provider.dart';
import 'package:armm_app/database/models/client_model.dart';
>>>>>>> 1a0bccc (Made Custom Activity App Bar)

class NameAndCID extends StatelessWidget {
  const NameAndCID({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
=======
    final client = Provider.of<Client?>(context);
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Name and Client ID
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
<<<<<<< HEAD
<<<<<<< HEAD
              "${client?.firstName} ${client?.lastName}",
=======
              "${client.firstName} ${client.lastName}",
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
=======
              "${client?.firstName} ${client?.lastName}",
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
<<<<<<< HEAD
<<<<<<< HEAD
              'Client ID: ${client?.cid}',
              style: const TextStyle(
=======
              'Client ID: $cid',
              style: TextStyle(
>>>>>>> 8938814 (Changed File Structure of the Profile Page and its Components)
=======
              'Client ID: ${client?.cid}',
              style: const TextStyle(
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
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