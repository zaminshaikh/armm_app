import 'package:armm_app/database/models/activity_model.dart';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/activity/components/activity_app_bar.dart';
import 'package:armm_app/screens/activity/components/activity_details_modal.dart';
import 'package:armm_app/screens/activity/components/activity_list_item.dart';
import 'package:armm_app/screens/activity/components/filter_modal.dart';
import 'package:armm_app/screens/activity/components/no_activities_body.dart';
import 'package:armm_app/screens/activity/components/sort_modal.dart';
import 'package:armm_app/screens/activity/utils/filter_activities.dart';
import 'package:armm_app/screens/activity/utils/sort_activities.dart';
import 'package:armm_app/utils/bottom_nav.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';
import 'package:armm_app/components/custom_progress_indicator.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedIndex = 2;
  Client? client;
  List<Activity> activities = [];
  List<String> allRecipients = [];
  List<String> allClients = [];

  bool _allSelected = true;

  // Initialize filters and sort order
  SortOrder _order = SortOrder.newToOld;
  List<String> _typeFilter = ['income', 'profit', 'deposit', 'withdrawal'];
  List<String> _recipientsFilter = [];
  List<String> _clientsFilter = [];
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime(1900),
    end: DateTime.now().add(const Duration(days: 30)),
  );

  // Date formatter for day headers
  final DateFormat dayHeaderFormat = DateFormat('MMMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _validateAuth();
    _clientsFilter = [];

    // Initialize recipients filter after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _recipientsFilter = List.from(allRecipients);
      });
    });
  }

  /// Validates if the user is authenticated; if not, redirects to the login page.
  Future<void> _validateAuth() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null && mounted) {
      log('ActivityPage: User is not logged in');
      await Navigator.pushReplacementNamed(context, '/login');
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const CustomProgressIndicator(
        color: Color(0xFF2B41B8), // ARMM Blue color
      );
    }

    // Retrieve activities and recipients
    _retrieveActivitiesAndRecipients();

    // Filter and sort activities
    filterActivities(activities, _typeFilter, _recipientsFilter, _clientsFilter,
        selectedDates);
    sortActivities(activities, _order);

    List<Widget> listChildren = [];
    listChildren.add(const SizedBox(height: 10));
    listChildren.add(_buildParentNameButtons());
    // Build each list item using _buildListContent
    final int childCount = activities.isEmpty ? 2 : activities.length + 1;
    for (int index = 0; index < childCount; index++) {
      final widgetItem = _buildListContent(context, index);
      if (widgetItem != null) {
        listChildren.add(widgetItem);
      }
    }
    listChildren.add(const SizedBox(height: 150));

    return Scaffold(
      appBar: ActivityAppBar(
        client: client!,
        onFilterPressed: () => _showFilterModal(context),
        onSortPressed: () => _showSortModal(context),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: listChildren,
      ),
      bottomNavigationBar: BottomNavBar(
        currentItem: NavigationItem.activity,
      ),
    );
  }

  /// Retrieves activities and recipients from the client and connected users.
  void _retrieveActivitiesAndRecipients() {
    activities = List.from(client?.activities ?? []);
    allRecipients = List.from(client?.recipients ?? []);

    if (client?.connectedUsers != null && client!.connectedUsers!.isNotEmpty) {
      final connectedUserActivities = client!.connectedUsers!
          .where((user) => user != null)
          .expand((user) => user!.activities ?? [].cast<Activity>());
      final connectedUserRecipients = client!.connectedUsers!
          .where((user) => user != null)
          .expand((user) => user!.recipients ?? [].cast<String>());
      activities.addAll(connectedUserActivities);
      allRecipients.addAll(connectedUserRecipients);
    }
    allClients = activities
        // map each activity to its parentName (some could be null or empty)
        .map((activity) => activity.parentName ?? '')
        // filter out empty parent names
        .where((parentName) => parentName.isNotEmpty)
        // convert to a set to get only unique values
        .toSet()
        // convert back to a list
        .toList();
  }

  /// Builds the content of the list based on the index.
  Widget? _buildListContent(BuildContext context, int index) {
    // With the filter/sort row removed from the list (it's now in the AppBar)
    if (activities.isEmpty && index == 0) {
      return buildNoActivityMessage();
    } else {
      int activityIndex = activities.isEmpty ? index - 1 : index;
      if (activityIndex < 0 || activityIndex >= activities.length) {
        return null;
      }
      final activity = activities[activityIndex];
      return _buildActivity(activity);
    }
  }



  /// Builds a horizontal scrollable row of buttons for each parent name.
  Widget _buildParentNameButtons() {
    if (allClients.length == 1) {
      return const SizedBox(height: 0);
    }
  
    // Define ARMM Blue color (update the hex value as needed)
    const Color armmBlue = Color(0xFF2B41B8);
  
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // "All" Button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                icon: SvgPicture.asset(
                  'assets/icons/group.svg',
                  colorFilter: ColorFilter.mode(
                    _allSelected ? Colors.white : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 24,
                  width: 24,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _allSelected ? armmBlue : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: _allSelected ? armmBlue : Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0,
                ).copyWith(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                label: Text(
                  'All',
                  style: TextStyle(
                    color: _allSelected ? Colors.white : Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _allSelected = true;
                    _clientsFilter.clear();
                  });
                },
              ),
            ),
            // Individual Parent Buttons
            ...allClients.map((parentName) {
              bool isSelected = _clientsFilter.contains(parentName);

              final rowChildren = <Widget>[
                if (isSelected)
                  SvgPicture.asset(
                    'assets/icons/profile.svg',
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : Colors.grey,
                      BlendMode.srcIn,
                    ),
                    height: 18,
                    width: 18,
                  )
                else
                  SvgPicture.asset(
                    'assets/icons/profile_hollow.svg',
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : Colors.grey,
                      BlendMode.srcIn,
                    ),
                    height: 18,
                    width: 18,
                  ),
                const SizedBox(width: 12),
                Text(
                  parentName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 15),
                  SvgPicture.asset(
                    'assets/icons/x.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    height: 20,
                    width: 20,
                  ),
                ],
              ];
  
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? armmBlue : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? armmBlue : Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                  ).copyWith(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        _clientsFilter.remove(parentName);
                        if (_clientsFilter.isEmpty) {
                          _allSelected = true;
                        }
                      } else {
                        _clientsFilter.add(parentName);
                        if (_clientsFilter.length == allClients.length) {
                          _allSelected = true;
                          _clientsFilter.clear();
                        } else {
                          _allSelected = false;
                        }
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: rowChildren,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }


  /// Builds an individual activity item.
  Widget _buildActivity(Activity activity,) => Container(
    child: ActivityListItem(
      activity: activity,
      onTap: () => _showActivityDetailsModal(context, activity),
    ),
  );

  /// Shows the activity details modal.
  void _showActivityDetailsModal(BuildContext context, Activity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          ActivityDetailsModal(activity: activity),
    );
  }

  /// Shows the filter modal.
  void _showFilterModal(BuildContext context) {
    var allTypes = ['income', 'profit', 'deposit', 'withdrawal'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityFilterModal(
        typeFilter: _typeFilter,
        allTypes: allTypes, 
        recipientsFilter: _recipientsFilter,
        allRecipients: allRecipients,
        clientsFilter: _allSelected ? List.from(allClients) : List.from(_clientsFilter),
        allClients: allClients,
        selectedDates: selectedDates,
        onApply: (
          List<String> typeFilter,
          List<String> recipientsFilter,
          List<String> parentsFilter,
          DateTimeRange updatedDates,
        ) {
          setState(() {
            _typeFilter = typeFilter;
            _recipientsFilter = recipientsFilter;
            selectedDates = updatedDates;

            if (parentsFilter.length == allClients.length) {
              _allSelected = true;
              _clientsFilter.clear();
            } else {
              _clientsFilter = parentsFilter;
              _allSelected = _clientsFilter.isEmpty;
            }
          });
          // Re-apply filtering as needed.
          filterActivities(activities, _typeFilter, _recipientsFilter, _clientsFilter, selectedDates);
        },
      ),
    );
  }

  /// Shows the sort modal.
  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivitySortModal(
        currentOrder: _order,
        onSelect: (order) {
          setState(() {
            _order = order as SortOrder;
            sortActivities(activities, _order);
          });
        },
      ),
    );
  }
}