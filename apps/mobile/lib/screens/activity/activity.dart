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
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:armm_app/utils/bottom_nav.dart';
=======
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
import 'package:armm_app/utils/bottom_nav.dart';
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
<<<<<<< HEAD
<<<<<<< HEAD
  int _selectedIndex = 2;
=======
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
  int _selectedIndex = 2;
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

<<<<<<< HEAD
=======
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client?>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (client == null) {
<<<<<<< HEAD
<<<<<<< HEAD
      return const Center(child: CircularProgressIndicator());
=======
      return const CircularProgressIndicator();
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
      return const Center(child: CircularProgressIndicator());
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
    }

    // Retrieve activities and recipients
    _retrieveActivitiesAndRecipients();

    // Filter and sort activities
    filterActivities(activities, _typeFilter, _recipientsFilter, _clientsFilter,
        selectedDates);
    sortActivities(activities, _order);

<<<<<<< HEAD
<<<<<<< HEAD
=======
    // Build list children manually (replacing slivers)
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
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

<<<<<<< HEAD
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
=======
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
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
<<<<<<< HEAD
  
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)

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
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  }

  /// Builds the content of the list based on the index.
  Widget? _buildListContent(BuildContext context, int index) {
<<<<<<< HEAD
<<<<<<< HEAD
    // With the filter/sort row removed from the list (it's now in the AppBar)
=======
    // We removed the index == 0 filter/sort row check 
    // because it is now in the AppBar
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
    // With the filter/sort row removed from the list (it's now in the AppBar)
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
    if (activities.isEmpty && index == 0) {
      return buildNoActivityMessage();
    } else {
      int activityIndex = activities.isEmpty ? index - 1 : index;
      if (activityIndex < 0 || activityIndex >= activities.length) {
        return null;
      }
      final activity = activities[activityIndex];
<<<<<<< HEAD
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
=======
      return _buildActivityWithDayHeader(activity, activityIndex);
    }
  }

  /// Builds a horizontal scrollable row of buttons for each parent name.
  Widget _buildParentNameButtons() {
    if (allClients.length == 1) {
      return const SizedBox(height: 0);
    }
<<<<<<< HEAD

<<<<<<< HEAD
    return SliverToBoxAdapter(
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
=======
  
    // Define ARMM Blue color (update the hex value as needed)
    const Color armmBlue = Color(0xFF2B41B8);
  
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
<<<<<<< HEAD
<<<<<<< HEAD
=======
            const SizedBox(width: 20),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
            // "All" Button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                icon: SvgPicture.asset(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
                  'assets/icons/group_people.svg',
=======
                  'assets/icons/sort.svg',
>>>>>>> a440029 (Removed All Font Issues)
=======
                  'assets/icons/filter.svg',
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
=======
                  'assets/icons/group.svg',
                  colorFilter: ColorFilter.mode(
                    _allSelected ? Colors.white : Colors.grey,
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
                    BlendMode.srcIn,
                  ),
                  height: 24,
                  width: 24,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _allSelected ? armmBlue : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: _allSelected ? armmBlue : Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0,
                ),
                label: Text(
                  'All',
                  style: TextStyle(
                    color: _allSelected ? Colors.white : Colors.grey,
                    fontSize: 15,
<<<<<<< HEAD
<<<<<<< HEAD
                    fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                    
>>>>>>> a440029 (Removed All Font Issues)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
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
<<<<<<< HEAD
<<<<<<< HEAD
            // Individual Parent Buttons
            ...allClients.map((parentName) {
              bool isSelected = _clientsFilter.contains(parentName);
  
              final rowChildren = <Widget>[
                SvgPicture.asset(
                  'assets/icons/profile.svg',
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.grey,
=======

=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
            // Individual Parent Buttons
            ...allClients.map((parentName) {
              bool isSelected = _clientsFilter.contains(parentName);
  
              final rowChildren = <Widget>[
                SvgPicture.asset(
                  'assets/icons/profile.svg',
<<<<<<< HEAD
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.grey,
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
                    BlendMode.srcIn,
                  ),
                  height: 18,
                  width: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  parentName,
<<<<<<< HEAD
<<<<<<< HEAD
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
=======
                  style: const TextStyle(
                    color: Colors.white,
=======
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
<<<<<<< HEAD
<<<<<<< HEAD
                    fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                    
>>>>>>> a440029 (Removed All Font Issues)
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 15),
                  SvgPicture.asset(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                    'assets/icons/x.svg',
=======
                    'assets/icons/x_icon.svg',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                    'assets/icons/sort.svg',
>>>>>>> a440029 (Removed All Font Issues)
=======
                    'assets/icons/x.svg',
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
<<<<<<< HEAD
<<<<<<< HEAD
                    height: 20,
                    width: 20,
                  ),
                ],
              ];
  
=======
                    height: 28,
                    width: 28,
                  ),
                ],
              ];

>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                    height: 20,
                    width: 20,
                  ),
                ],
              ];
  
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
                    backgroundColor: isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 17, 24, 39),
=======
                    backgroundColor: isSelected ? Colors.white : const Color.fromARGB(255, 17, 24, 39),
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
=======
                    backgroundColor: isSelected ? armmBlue : Colors.transparent,
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? armmBlue : Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
<<<<<<< HEAD
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
                    elevation: 0,
>>>>>>> 735f99e (Fixed Parent Name Row Buttons)
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

<<<<<<< HEAD

<<<<<<< HEAD
  /// Builds an individual activity item.
  Widget _buildActivity(Activity activity,) => Container(
    child: ActivityListItem(
      activity: activity,
      onTap: () => _showActivityDetailsModal(context, activity),
    ),
  );
=======

  /// Builds an activity item with a day header if necessary.
=======
  /// Builds an activity item without day headers.
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  Widget _buildActivityWithDayHeader(Activity activity, int index) {
    return _buildActivity(activity, true);
  }

  /// Builds an individual activity item.
  Widget _buildActivity(Activity activity, bool showBorder) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color.fromARGB(255, 132, 132, 132),
              width: showBorder ? 1.0 : 0.0,
            ),
          ),
        ),
        child: ActivityListItem(
          activity: activity,
          onTap: () => _showActivityDetailsModal(context, activity),
        ),
      );
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)

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

<<<<<<< HEAD
<<<<<<< HEAD
  /// Shows the filter modal.
  void _showFilterModal(BuildContext context) {
    var allTypes = ['income', 'profit', 'deposit', 'withdrawal'];
=======
  
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
  /// Shows the filter modal.
  void _showFilterModal(BuildContext context) {
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityFilterModal(
        typeFilter: _typeFilter,
<<<<<<< HEAD
        allTypes: allTypes, 
        recipientsFilter: _recipientsFilter,
        allRecipients: allRecipients,
=======
        recipientsFilter: _recipientsFilter,
        allRecipients: allRecipients,
        // Pass allParents if _allSelected is true to reflect all checkboxes as selected
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
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
<<<<<<< HEAD
<<<<<<< HEAD
          // Re-apply filtering as needed.
          filterActivities(activities, _typeFilter, _recipientsFilter, _clientsFilter, selectedDates);
=======
          
=======
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
          // Re-apply filtering as needed
          filterActivities(activities, _typeFilter, _recipientsFilter,
              _clientsFilter, selectedDates);
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
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
<<<<<<< HEAD
<<<<<<< HEAD
}
=======
}
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
=======
}
>>>>>>> 1a0bccc (Made Custom Activity App Bar)
