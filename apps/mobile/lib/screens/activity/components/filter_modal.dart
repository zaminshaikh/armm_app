<<<<<<< HEAD
=======
// activity_filter_modal.dart

>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';

/// A modal widget for filtering activities.
class ActivityFilterModal extends StatefulWidget {
<<<<<<< HEAD
  /// The currently selected type filters.
  final List<String> typeFilter;
  /// The complete list of type options.
  final List<String> allTypes;
=======
  final List<String> typeFilter;
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
  final List<String> recipientsFilter;
  final List<String> allRecipients;

  // NEW: for Parent Name filter
  final List<String> clientsFilter;
  final List<String> allClients;

  final DateTimeRange selectedDates;

<<<<<<< HEAD
  /// Updated: onApply now must return clientsFilter as well
=======
  // Updated: onApply now must return clientsFilter as well
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
  final Function(
    List<String> typeFilter,
    List<String> recipientsFilter,
    List<String> clientsFilter,
    DateTimeRange selectedDates,
  ) onApply;

  const ActivityFilterModal({
    Key? key,
    required this.typeFilter,
<<<<<<< HEAD
    required this.allTypes,
    required this.recipientsFilter,
    required this.allRecipients,
    // NEW:
    required this.clientsFilter,
    required this.allClients,
=======
    required this.recipientsFilter,
    required this.allRecipients,

    // NEW
    required this.clientsFilter,
    required this.allClients,

>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
    required this.selectedDates,
    required this.onApply,
  }) : super(key: key);

  @override
  _ActivityFilterModalState createState() => _ActivityFilterModalState();
}

class _ActivityFilterModalState extends State<ActivityFilterModal> {
<<<<<<< HEAD
  // Use a separate state variable for the currently selected types.
  late List<String> _selectedTypes;
  late List<String> _recipientsFilter;
  late List<String> _clientsFilter;
  late DateTimeRange _selectedDates;

  // This flag is used for handling the "All" logic in clients filter.
  bool _allSelected = false;
=======
  late List<String> _typeFilter;
  late List<String> _recipientsFilter;

  // NEW
  late List<String> _clientsFilter;

  late DateTimeRange _selectedDates;
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _selectedTypes = List.from(widget.typeFilter);
    _recipientsFilter = List.from(widget.recipientsFilter);
    // Initialize clientsFilter with allClients if no clients are pre-selected.
=======
    _typeFilter = List.from(widget.typeFilter);
    _recipientsFilter = List.from(widget.recipientsFilter);
    // Initialize clientsFilter with allclients if 'All' is selected
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
    _clientsFilter = widget.clientsFilter.isEmpty
        ? List.from(widget.allClients)
        : List.from(widget.clientsFilter);
    _selectedDates = widget.selectedDates;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
              builder: (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Icon(Icons.remove, color: Colors.transparent),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Text(
                          'Filter Activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
<<<<<<< HEAD
=======
                            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: controller,
                        children: [
                          _buildTimePeriodFilter(),
<<<<<<< HEAD
                          // Use the complete list of types (widget.allTypes) here.
                          _buildFilter('Type', widget.allTypes, _selectedTypes),
                          _buildFilter('Recipients', widget.allRecipients, _recipientsFilter),
                          _buildFilter('Clients', widget.allClients, _clientsFilter),
=======
                          _buildFilter(
                            'Type',
                            widget.typeFilter,
                            _typeFilter,
                          ),
                          _buildFilter(
                            'Recipients',
                            widget.allRecipients,
                            _recipientsFilter,
                          ),
                          // NEW: Parent Name Filter Section
                          _buildFilter(
                            'Clients',
                            widget.allClients,
                            _clientsFilter,
                          ),
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                        ],
                      ),
                    ),
                    _buildFilterApplyClearButtons(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  /// Builds the time period filter option.
  Widget _buildTimePeriodFilter() => ListTile(
        title: GestureDetector(
          onTap: () async {
            final DateTimeRange? dateTimeRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(3000),
              builder: (BuildContext context, Widget? child) => Theme(
                data: Theme.of(context).copyWith(
                  scaffoldBackgroundColor: Colors.black,
                  colorScheme: ColorScheme.dark().copyWith(
                    brightness: Brightness.dark,
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    secondary: Colors.black,
                    onSecondary: Colors.black,
                    secondaryContainer: Colors.black,
                    onSecondaryContainer: Colors.black,
                    secondaryFixed: Colors.black,
                    secondaryFixedDim: Colors.black,
                  ),
                ),
                child: child!,
              ),
            );
            if (dateTimeRange != null) {
              setState(() {
                _selectedDates = dateTimeRange;
              });
            }
          },
          child: Container(
            color: Colors.transparent,
            child: const Text(
              'By Time Period',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
<<<<<<< HEAD
=======
                fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
              ),
            ),
          ),
        ),
      );

<<<<<<< HEAD
=======





>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
  /// Builds a filter section with checkboxes.
  Widget _buildFilter(
    String title,
    List<String> items,
    List<String> filterList,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
<<<<<<< HEAD
=======
              fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
            ),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          children: items
              .map(
                (item) => _buildCheckbox(
                  toTitleCase(item),
                  item,
                  filterList,
                ),
              )
              .toList(),
        ),
      );

  /// Builds an individual checkbox for the filter.
  Widget _buildCheckbox(
    String title,
    String filterKey,
    List<String> filterList,
  ) {
    bool isChecked = filterList.contains(filterKey);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => CheckboxListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
<<<<<<< HEAD
=======
            fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
          ),
        ),
        activeColor: Colors.black,
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
            if (isChecked) {
<<<<<<< HEAD
              // Special case: if filterKey is 'profit', also ensure 'income' is added.
              if (filterKey == 'profit' && !filterList.contains('income')) {
                filterList.add('income');
=======
              // Special case if filterKey is 'profit'
              if (filterKey == 'profit') {
                if (!filterList.contains('income')) {
                  filterList.add('income');
                }
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
              }
              if (!filterList.contains(filterKey)) {
                filterList.add(filterKey);
              }
            } else {
              if (filterKey == 'profit') {
                filterList.remove('income');
              }
              filterList.remove(filterKey);
            }

<<<<<<< HEAD
            // Update _allSelected if all clients are selected or none.
=======
            // Update _allSelected if all clients are selected or none
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
            if (widget.allClients.length == filterList.length) {
              _allSelected = true;
              _clientsFilter = [];
            } else if (filterList.isEmpty) {
              _allSelected = true;
              _clientsFilter = List.from(widget.allClients);
            } else {
              _allSelected = false;
            }
          });
        },
      ),
    );
  }

  /// Builds the apply and clear buttons for the filter modal.
  Widget _buildFilterApplyClearButtons() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
<<<<<<< HEAD
                  ),
                ),
                onPressed: () {
=======
                    fontFamily: 'Titillium Web',
                  ),
                ),
                onPressed: () {
                  // If all clients are selected, clear _clientsFilter to indicate "All" is selected
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                  if (_clientsFilter.length == widget.allClients.length) {
                    _clientsFilter.clear();
                  }
                  Navigator.pop(context);
                  widget.onApply(
<<<<<<< HEAD
                    _selectedTypes,
                    _recipientsFilter,
                    _clientsFilter,
=======
                    _typeFilter,
                    _recipientsFilter,
                    _clientsFilter,  // NEW
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                    _selectedDates,
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.close, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
<<<<<<< HEAD
=======
                        fontFamily: 'Titillium Web',
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
<<<<<<< HEAD
                // Reset selected filters to default (all available options).
                _selectedTypes = List.from(widget.allTypes);
                _recipientsFilter = List.from(widget.allRecipients);
                _clientsFilter = List.from(widget.allClients);
                _allSelected = true;
=======
                // Reset everything to defaults
                _typeFilter = ['income', 'profit', 'deposit', 'withdrawal'];
                _recipientsFilter = List.from(widget.allRecipients);

                // NEW: reset the clients filter to all
                _clientsFilter = List.from(widget.allClients);
                _allSelected = true;

>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                _selectedDates = DateTimeRange(
                  start: DateTime(1900),
                  end: DateTime.now().add(const Duration(days: 30)),
                );
              });
              Navigator.pop(context);
              widget.onApply(
<<<<<<< HEAD
                _selectedTypes,
                _recipientsFilter,
                _clientsFilter,
=======
                _typeFilter,
                _recipientsFilter,
                _clientsFilter, 
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
                _selectedDates,
              );
            },
          ),
        ],
      );
<<<<<<< HEAD
=======

  bool _allSelected = false; // Add this state variable
>>>>>>> 6e77a0f (Migrated all Activity Page Helpers)
}