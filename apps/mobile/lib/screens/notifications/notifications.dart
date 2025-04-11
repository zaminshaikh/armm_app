// ignore_for_file: library_private_types_in_public_api, unused_element, use_build_context_synchronously

import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/database/models/notification_model.dart';
import 'package:armm_app/screens/notifications/components/mark_all_read_button.dart';
import 'package:armm_app/screens/notifications/components/notification_card.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Client? client;  
  List<Notif> notifications = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
  }

  @override
  Widget build(BuildContext context){
    if (client == null) {
      return const Center(
        child: SpinKitFoldingCube(
          color: Color(0xFF1C32A4),
          size: 50.0,
        ),
      );
    }
    notifications = List.from(client!.notifications!);
    if (client!.connectedUsers != null && client!.connectedUsers!.isNotEmpty) {
      final connectedUserNotifications = client!.connectedUsers!
        .where((user) => user != null)
        .expand((user) => user!.notifications ?? [].cast<Notif>());
      notifications.addAll(connectedUserNotifications);
    }
    notifications.sort((a, b) => b.time.compareTo(a.time));
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 150.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                Notif notification = notifications[index];
                return NotificationCard(notification: notification, client: client!);
              },
            ),
      floatingActionButton: MarkAllAsReadButton(client: client!, 
        onRefresh: () { setState(() {}); },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

