import 'package:flutter/material.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Name and Client ID
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${client.firstName} ${client.lastName}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Client ID: $cid',
              style: TextStyle(
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