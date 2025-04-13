import 'package:armm_app/auth/auth_utils/auth_textfield.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:armm_app/utils/expansion_filter_tile.dart';
import 'package:armm_app/utils/resources.dart';

/// A modal widget for filtering activities.
class ActivityFilterModal extends StatefulWidget {
  /// The currently selected type filters.
  final List<String> typeFilter;
  /// The complete list of type options.
  final List<String> allTypes;
  final List<String> recipientsFilter;
  final List<String> allRecipients;

  // NEW: for Parent Name filter
  final List<String> clientsFilter;
  final List<String> allClients;

  final DateTimeRange selectedDates;

  /// Updated: onApply now must return clientsFilter as well
  final Function(
    List<String> typeFilter,
    List<String> recipientsFilter,
    List<String> clientsFilter,
    DateTimeRange selectedDates,
  ) onApply;

  const ActivityFilterModal({
    Key? key,
    required this.typeFilter,
    required this.allTypes,
    required this.recipientsFilter,
    required this.allRecipients,
    // NEW:
    required this.clientsFilter,
    required this.allClients,
    required this.selectedDates,
    required this.onApply,
  }) : super(key: key);

  @override
  _ActivityFilterModalState createState() => _ActivityFilterModalState();
}

class _ActivityFilterModalState extends State<ActivityFilterModal> {
  // Use a separate state variable for the currently selected types.
  late List<String> _selectedTypes;
  late List<String> _recipientsFilter;
  late List<String> _clientsFilter;
  late DateTimeRange _selectedDates;

  // This flag is used for handling the "All" logic in clients filter.
  bool _allSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.typeFilter);
    _recipientsFilter = List.from(widget.recipientsFilter);
    // Initialize clientsFilter with allClients if no clients are pre-selected.
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
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Icon(Icons.remove, color: Colors.transparent),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          'Filter Transactions',
                          style: GoogleFonts.inter(
                            color: const Color.fromARGB(200, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: controller,
                        children: [
                          _buildTimePeriodFilter(),
                          // Use the complete list of types (widget.allTypes) here.
                            _buildFilter(
                            title: 'Type',
                            iconPath: 'assets/icons/activities.svg',
                            items: widget.allTypes,
                            filterList: _selectedTypes,
                            buildCheckbox: _buildCheckbox,
                            ),
                            _buildFilter(
                            title: 'Recipients',
                            iconPath: 'assets/icons/profile_hollow.svg',
                            items: widget.allRecipients,
                            filterList: _recipientsFilter,
                            buildCheckbox: _buildCheckbox,
                            ),
                            _buildFilter(
                            title: 'Clients',
                            iconPath: 'assets/icons/group.svg',
                            items: widget.allClients,
                            filterList: _clientsFilter,
                            buildCheckbox: _buildCheckbox,
                            ),
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
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color.fromARGB(255, 77, 77, 77),),
                const SizedBox(width: 10),
                Text(
                  'By Time Period',
                  style: GoogleFonts.inter(
                    color: const Color.fromARGB(255, 77, 77, 77),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );


Widget _buildFilter({
  required String title,
  required String iconPath,
  required List<String> items,
  required List<String> filterList,
  required Widget Function(String, String, List<String>) buildCheckbox,
}) {
  return FilterExpansionTile(
    title: title,
    iconPath: iconPath, // now passing the iconPath directly
    items: items,
    filterList: filterList,
    buildCheckbox: buildCheckbox,
  );
}

/// Helper function to convert e.g. "pending withdrawal" -> "Pending Withdrawal"
String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

  /// Builds an individual checkbox for the filter.
  Widget _buildCheckbox(
    String title,
    String filterKey,
    List<String> filterList,
  ) {
    bool isChecked = filterList.contains(filterKey);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => CheckboxListTile(
        // Move the checkbox to the leading side
        controlAffinity: ListTileControlAffinity.leading,
        
        // Make the checkbox circular with a blue outline
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Adjust the value to control the roundness
        ),
        side: BorderSide(color: AppColors.primary, width: 2.0),

        // Colors when checked
        activeColor: AppColors.primary,  // Fill color of circle
        checkColor: Colors.white,  // Color of the check icon

        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4D4D4D),
          ),
        ),
        
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
            if (isChecked) {
              // Special case: if filterKey is 'profit', also add 'income'
              if (filterKey == 'profit' && !filterList.contains('income')) {
                filterList.add('income');
              }
              filterList.add(filterKey);
            } else {
              if (filterKey == 'profit') {
                filterList.remove('income');
              }
              filterList.remove(filterKey);
            }

            // Update _allSelected if needed
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
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Apply',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_clientsFilter.length == widget.allClients.length) {
                    _clientsFilter.clear();
                  }
                  Navigator.pop(context);
                  widget.onApply(
                    _selectedTypes,
                    _recipientsFilter,
                    _clientsFilter,
                    _selectedDates,
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.close, color: Color.fromARGB(255, 77, 77, 77)),
                    const SizedBox(width: 5),
                    Text(
                      'Clear',
                      style: GoogleFonts.inter(
                        color: const Color.fromARGB(255, 77, 77, 77),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                // Reset selected filters to default (all available options).
                _selectedTypes = List.from(widget.allTypes);
                _recipientsFilter = List.from(widget.allRecipients);
                _clientsFilter = List.from(widget.allClients);
                _allSelected = true;
                _selectedDates = DateTimeRange(
                  start: DateTime(1900),
                  end: DateTime.now().add(const Duration(days: 30)),
                );
              });
              Navigator.pop(context);
              widget.onApply(
                _selectedTypes,
                _recipientsFilter,
                _clientsFilter,
                _selectedDates,
              );
            },
          ),
        ],
      );
}