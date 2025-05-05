// mark_all_as_read_button.dart
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:flutter/material.dart';

class MarkAllAsReadButton extends StatelessWidget {
  final Client client;
  final VoidCallback onRefresh;

  const MarkAllAsReadButton({
    super.key,
    required this.client,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Only show button if there are unread notifications
    bool hasUnreadNotifications = (client.numNotifsUnread ?? 0) > 0;
    if (!hasUnreadNotifications) {
      return Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                // Blue border
                side: const BorderSide(
                  color: Color(0xFF1C32A4),
                  width: 2,
                ),
                // Make it pill-shaped
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              onPressed: () async {
                await DatabaseService.withCID(client.uid, client.cid)
                    .markAllNotificationsAsRead();
                onRefresh();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Mark All as Read',
                      style: TextStyle(
                        color: Color(0xFF1C32A4),
                        fontFamily: 'Titillium Web',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: Color(0xFF1C32A4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}