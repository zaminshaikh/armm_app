// notification_card.dart
import 'package:armm_app/database/database.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/models/notification_model.dart';
import 'package:armm_app/screens/activity/activity.dart';
import 'package:armm_app/screens/profile/pages/documents_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final Notif notification;
  final Client client;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.client,
  });

  @override
  Widget build(BuildContext context) => _buildNotification(context, notification);

  Widget _buildNotification(BuildContext context, Notif notification) {
    String title;
    switch (notification.type) {
      case 'activity':
        title = 'New Activity';
        break;
      case 'statement':
        title = 'New Statement';
        break;
      default:
        title = 'New Notification';
        break;
    }

    const ARMM_Blue = Color(0xFF1C32A4);

    String timeAgo = timeago.format(notification.time, locale: 'en');

    // Wrap each notification in Dismissible for iOS-style "swipe to delete"
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0, // remove card shadow if you prefer a "flat" iOS look
          color: Colors.transparent, // transparent background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Round edges
            side: BorderSide(color: const Color.fromARGB(123, 158, 158, 158), width: 1), // Adding gray border with 1px width
          ),
          child: Stack(
            children: [
              // Blue dot indicator in the top left corner
              if (!notification.isRead)
                Positioned(
                  top: 18,
                  left: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: ARMM_Blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 12, 16, 8), // Increased left padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700, // Made bolder
                        color: Colors.black, // Explicit black color
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Message
                    Text(
                      notification.message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black, // Explicit black color
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Time ago at the bottom
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        timeAgo,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600, // Grey color for time ago
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Make the entire card tappable
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final targetPage = (notification.type == 'activity')
                          ? const ActivityPage()
                          : const DocumentsPage();

                      // Navigate to relevant page, then mark notification as read
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
                        ),
                      );

                      final notificationCID = notification.parentCID;
                      final myCID = client.cid;

                      DatabaseService db;
                      if (notificationCID == myCID) {
                        db = DatabaseService.withCID(client.uid, client.cid);
                      } else {
                        Client? connectedUser;
                        for (var c in client.connectedUsers ?? []) {
                          if (c != null && c.cid == notificationCID) {
                            connectedUser = c;
                            break;
                          }
                        }

                        if (connectedUser != null) {
                          db = DatabaseService.withCID(connectedUser.uid, connectedUser.cid);
                        } else {
                          db = DatabaseService.withCID(client.uid, client.cid);
                        }
                      }

                      await db.markNotificationAsRead(notification.id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}