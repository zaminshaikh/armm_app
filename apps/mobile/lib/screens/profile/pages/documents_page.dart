<<<<<<< HEAD
// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore, prefer_expression_function_bodies, unused_catch_clause, empty_catches

import 'dart:io';
import 'package:armm_app/database/models/client_model.dart';
import 'package:armm_app/screens/profile/utils/PDFPreview.dart';
import 'package:armm_app/screens/profile/utils/downloadmethod.dart';
import 'package:armm_app/utils/app_bar.dart';
import 'package:armm_app/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart'; // Added for CupertinoSearchTextField
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DocumentsPageState createState() => _DocumentsPageState();
}

class PDF {
  final Reference file;
  final String cid;

  PDF(this.file, this.cid);
}

class _DocumentsPageState extends State<DocumentsPage> {
  Client? client;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> allFiles = [];
  List<Reference> pdfFiles = [];
  List<Reference> filteredPdfFiles = [];
  List<PDF> pdfFilesConnectedUsers = [];
  List<PDF> filteredPdfFilesConnectedUsers = [];
  bool isSortAscending = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newClient = Provider.of<Client?>(context);
    if (newClient != client) {
      client = newClient;
      print('didChangeDependencies: Client is $client');
      if (client != null) {
        _initializeDocuments();
      } else {
        print('didChangeDependencies: Client is still null');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (client == null) {
      return const CircularProgressIndicator();
    }
  
    return buildDocumentsPage();
  }
  
  Future<void> shareFile(context, clientId, documentName) async {
    try {
      // Call downloadFile to get the filePath
      String filePath = await downloadFile(context, clientId, documentName);
  
      // Check if the filePath is not empty
      if (filePath.isNotEmpty) {
        // Check if the filePath is a file
        File file = File(filePath);
        if (await file.exists()) {
          // Use Share.shareFiles to share the file
          await Share.shareXFiles([XFile(filePath)]);
        } else {
          print('File does not exist.');
        }
      } else {
        print('File path is empty.');
      }
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
  
  Future<void> _initializeDocuments() async {
    await showDocumentsSection();
  }
  
  Future<void> showDocumentsSection() async {
    print('Showing documents section...');
    // Update the state to indicate that the 'documents' button is selected
    setState(() {
      print('Documents button selected.');
    });
  
    // List the PDF files available
    await listPDFFiles();
  
    // List the PDF files for connected users
    await listPDFFilesConnectedUsers();
  
    // Combine and print both lists of PDF files
    printCombinedPdfFiles();
    print('Documents section shown.');
  }
  
  Future<void> listPDFFiles() async {
    print('Listing PDF files for the current user...');
    // Get the user's folder identifier
    final String userFolder = client!.cid;
    print('User folder: $userFolder');
  
    // List all files in the user's document folder
    final ListResult result = await storage.ref('${Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION')}/$userFolder').listAll();
    print('Files listed in user folder.');
  
    // Filter the list to include only PDF files
    final List<Reference> userPdfFiles = result.items.where((ref) => ref.name.endsWith('.pdf')).toList();
    print('Filtered PDF files: ${userPdfFiles.map((file) => file.name).toList()}');
  
    // Update the state with the list of PDF files
    if (mounted) {
      setState(() {
        pdfFiles = userPdfFiles;
        filteredPdfFiles = userPdfFiles;
        allFiles.addAll(userPdfFiles);
        print('State updated with user PDF files.');
      });
    }
  
    // Print the names of the PDF files for debugging purposes
    print('User PDF files: ${pdfFiles.map((file) => file.name).toList()}');
  }
  
  Future<void> listPDFFilesConnectedUsers() async {
    print('Listing PDF files for connected users...');
    // Initialize a list to hold all PDF files from connected users
    List<PDF> allConnectedFiles = [];
  
    // Iterate over each connected user's folder
    for (String folder in client!.connectedUsers!.whereType<Client>().map((client) => client.cid)) {
      print('Listing files in connected user folder: $folder');
      // List all files in the connected user's document folder
      final ListResult result = await storage.ref('${Config.get('FIRESTORE_ACTIVE_USERS_COLLECTION')}/$folder').listAll();
      print('Files listed in connected user folder.');
  
      // Filter the list to include only PDF files
      final List<Reference> pdfFilesInFolder = result.items.where((ref) => ref.name.endsWith('.pdf')).toList();
      print('Filtered PDF files in connected user folder: ${pdfFilesInFolder.map((file) => file.name).toList()}');
  
      // Convert List<Reference> to List<PDF> with the connected user's folder identifier
      final List<PDF> pdfFilesWithCid = pdfFilesInFolder.map((file) => PDF(file, folder)).toList();
      print('Converted PDF files with CID.');
  
      // Add the PDF files to the list of all connected files
      allConnectedFiles.addAll(pdfFilesWithCid);
      print('Added PDF files to all connected files.');
    }
  
    // Update the state with the list of PDF files from connected users
    if (mounted) {
      setState(() {
        // Use a Set to keep track of already added files
        final existingFiles = pdfFilesConnectedUsers.map((pdfFileWithCid) => pdfFileWithCid.file.name).toSet();
        print('Existing files: $existingFiles');
  
        // Add only the new files that are not already in the list
        final newFiles = allConnectedFiles.where((pdfFileWithCid) => !existingFiles.contains(pdfFileWithCid.file.name)).toList();
        print('New files to add: ${newFiles.map((file) => file.file.name).toList()}');
  
        pdfFilesConnectedUsers.addAll(newFiles);
        filteredPdfFilesConnectedUsers = pdfFilesConnectedUsers;
        allFiles.addAll(newFiles.map((pdf) => pdf.file));
        print('State updated with connected users PDF files.');
  
        // Add filteredPdfFilesConnectedUsers to filteredPdfFiles if not empty
        if (filteredPdfFilesConnectedUsers.isNotEmpty) {
          filteredPdfFiles.addAll(filteredPdfFilesConnectedUsers.map((pdf) => pdf.file));
          print('Added filteredPdfFilesConnectedUsers to filteredPdfFiles.');
        }
      });
    }
    print('Connected users PDF files listed.');
  }

  void printCombinedPdfFiles() {
    // Combine the lists of PDF files from the current user and connected users
    final combinedPdfFiles = allFiles.map((file) => file.name).toList();
  
    // Print the combined list of PDF files
    print('Combined PDF files: $combinedPdfFiles');
  }
  
  Future<Map<String, dynamic>> getFileMetadata(Reference file) async {
    print('Getting metadata for file: ${file.name}');
    // Get the metadata for the given file
    final FullMetadata metadata = await file.getMetadata();
    print('Metadata retrieved for file: ${file.name}');
  
    // Return a map containing the file name and the date it was added
    return {
      'name': file.name,
      'dateAdded': metadata.timeCreated,
    };
  }
  
  void _filterPdfFiles(String query) {
    print('Filtering PDF files with query: $query');
    // Update the state with the filtered list of PDF files based on the query
    setState(() {
      filteredPdfFiles = allFiles.where((file) => file.name.toLowerCase().contains(query.toLowerCase())).toList();
      print('Filtered PDF files: ${filteredPdfFiles.map((file) => file.name).toList()}');
    });
  }
  
  void _sortPdfFiles(bool ascending) async {
    print('Sorting PDF files in ${ascending ? 'ascending' : 'descending'} order...');
    // Initialize a list to hold the metadata for each PDF file
    List<Map<String, dynamic>> pdfFilesWithMetadata = [];
  
    // Fetch metadata for each PDF file in the filtered list
    for (var file in filteredPdfFiles) {
      final metadata = await getFileMetadata(file);
      pdfFilesWithMetadata.add(metadata);
      print('Metadata added for file: ${file.name}');
    }
  
    // Sort the list of metadata based on the date added
    pdfFilesWithMetadata.sort((a, b) {
      final dateA = a['dateAdded'] as DateTime?;
      final dateB = b['dateAdded'] as DateTime?;
      if (dateA == null || dateB == null) return 0;
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    print('PDF files sorted.');
  
    // Update the state with the sorted list of PDF files
    setState(() {
      filteredPdfFiles = pdfFilesWithMetadata.map((e) => allFiles.firstWhere((file) => file.name == e['name'])).toList();
      isSortAscending = ascending;
      print('State updated with sorted PDF files.');
    });
  }

  Scaffold buildDocumentsPage() {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Documents',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchAndSortBar(context),
            _documents(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndSortBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoSearchTextField(
              onChanged: (query) {
                _filterPdfFiles(query);
              },
              onSubmitted: (query) {
                _filterPdfFiles(query);
              },
              placeholder: 'Search PDF files',
              style: const TextStyle(
                color: Colors.black,
                
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          _buildSortButton(context),
        ],
      ),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSortOptions(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SvgPicture.asset(
          'assets/icons/sort.svg',
          color: const Color(0xFF2B41B8),
          width: 35.0,
          height: 35.0,
        ),
      ),
    );
  }


  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    SizedBox(width: 8.0),
                    Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: !isSortAscending ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8.0),
                        Text(
                          'New to Old',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _sortPdfFiles(false);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSortAscending ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8.0),
                        Text(
                          'Old to New',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _sortPdfFiles(true);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        );
      },
    );
  }

  // This is the Statements and Documents section
  Padding _documents() => Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (filteredPdfFiles.isEmpty && filteredPdfFilesConnectedUsers.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'There are no documents available.',
                    style: TextStyle(
                      color: Colors.black,
                      
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            else ...[
              if (filteredPdfFiles.isNotEmpty)
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredPdfFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FutureBuilder<Map<String, dynamic>>(
                                      future: getFileMetadata(filteredPdfFiles[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return ListTile(
                                            title: Text(
                                              filteredPdfFiles[index].name,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                
                                              ),
                                            ),
                                            subtitle: const Text('Loading...'),
                                          );
                                        } else if (snapshot.hasError) {
                                          return ListTile(
                                            title: Text(
                                              filteredPdfFiles[index].name,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                
                                              ),
                                            ),
                                            subtitle: const Text('Error loading metadata'),
                                          );
                                        } else {
                                          final metadata = snapshot.data!;
                                          final dateAdded = metadata['dateAdded'] as DateTime?;
                                          return ListTile(
                                            splashColor: Colors.transparent,
                                            title: Text(
                                              filteredPdfFiles[index].name,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                
                                              ),
                                            ),
                                            subtitle: Text(
                                              dateAdded != null
                                                  ? 'Added on: ${DateFormat('MMMM dd, yyyy').format(dateAdded.toLocal())}'
                                                  : 'Date not available',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                
                                              ),
                                            ),
                                            onTap: () async {
                                              await downloadFile(context, client!.cid, filteredPdfFiles[index].name);
                                              String filePath = await downloadFile(context, client!.cid, filteredPdfFiles[index].name);
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PDFScreen(filePath),
                                                ),
                                              );
                                            },
                                            trailing: IconButton(
                                              icon: SvgPicture.asset(
                                                'assets/icons/download.svg',
                                                width: 30,
                                                height: 30,
                                                color: Colors.grey
                                              ),
                                              onPressed: () {
                                                shareFile(context, client!.cid, filteredPdfFiles[index].name);
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ]

          ],
        ),
      );

  // This is the app bar 
  SliverAppBar _buildAppBar(context) => SliverAppBar(
        backgroundColor: const Color.fromARGB(255, 30, 41, 59),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        expandedHeight: 0,
        snap: false,
        floating: true,
        pinned: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 60.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documents',
                  style: TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
=======
import 'package:flutter/material.dart';
import 'package:armm_app/utils/app_bar.dart';

class DocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Documents',
        implyLeading: true,
        showNotificationButton: false,
      ),
      body: Center(
        child: Text('Documents Page'),
      ),
    );
  }
}
>>>>>>> 74eb99f (Made Dummy Sub-Pages For the Profile Page)
