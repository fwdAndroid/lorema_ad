import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lorema_ad/datasource/user_data_source.dart';
import 'package:lorema_ad/models/user_models.dart';
import 'package:lorema_ad/screens/auth.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  TextEditingController controller = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Image.asset("asset/logo.png"),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isShowUser = true;
                  });
                },
                icon: Icon(Icons.search))
          ],
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: TextFormField(
            controller: controller,
            decoration: InputDecoration(label: Text('Search By Name')),
            onFieldSubmitted: (_) {
              setState(() {
                isShowUser = true;
              });
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 670,
              child: isShowUser
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("name",
                              isGreaterThanOrEqualTo: controller.text)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        }

                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return Container(
                          height: 400,
                          child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  var data = snapshot.data!.docs[index];

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => BusinessView(
                                  //           data: data,
                                  //         )));
                                },
                                title: Text(
                                  documents[index]['name'],
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  documents[index]['email'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: _buildDataGrid(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  late UserMaangerDataSource employeeDataSource;
  List<UserModels> employeeData = [];

  final getDataFromFireStore =
      FirebaseFirestore.instance.collection('users').snapshots();
  Widget _buildDataGrid() {
    return StreamBuilder(
      stream: getDataFromFireStore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.hexagonDots(
                  color: Colors.blue, size: 200));
        }
        if (snapshot.hasData) {
          if (employeeData.isNotEmpty) {
            getDataGridRowFromDataBase(DocumentChange<Object?> data) {
              return DataGridRow(cells: [
                DataGridCell<String>(
                    columnName: 'name', value: data.doc['name']),
                DataGridCell<String>(
                    columnName: 'email', value: data.doc['email']),
                DataGridCell<String>(
                    columnName: 'phoneNumber', value: data.doc['phoneNumber']),
                DataGridCell<String>(columnName: 'uid', value: data.doc['uid']),
                DataGridCell<String>(
                    columnName: 'photoURL', value: data.doc['photoURL']),
              ]);
            }

            for (var data in snapshot.data!.docChanges) {
              if (data.type == DocumentChangeType.modified) {
                if (data.oldIndex == data.newIndex) {
                  employeeDataSource.dataGridRows[data.oldIndex] =
                      getDataGridRowFromDataBase(data);
                }
                employeeDataSource.updateDataGridSource();
              } else if (data.type == DocumentChangeType.added) {
                employeeDataSource.dataGridRows
                    .add(getDataGridRowFromDataBase(data));
                employeeDataSource.updateDataGridSource();
              } else if (data.type == DocumentChangeType.removed) {
                employeeDataSource.dataGridRows.removeAt(data.oldIndex);
                employeeDataSource.updateDataGridSource();
              }
            }
          } else {
            for (var data in snapshot.data!.docs) {
              employeeData.add(UserModels(
                uid: data['uid'],
                phoneNumber: data['phoneNumber'],
                photoURL: data['photoURL'],
                name: data['name'],
                email: data['email'],
              ));
            }
            employeeDataSource = UserMaangerDataSource(employeeData);
          }

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SfDataGrid(
              allowFiltering: true,
              allowSorting: true,
              allowSwiping: true,
              source: employeeDataSource,
              columns: getColumnsBusiness,
              columnWidthMode: ColumnWidthMode.fill,
              onCellTap: (details) {
                if (details.rowColumnIndex.rowIndex != 0) {
                  final DataGridRow row = employeeDataSource
                      .effectiveRows[details.rowColumnIndex.rowIndex - 1];
                  int index = employeeDataSource.dataGridRows.indexOf(row);
                  var data = snapshot.data!.docs[index];
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('User Detail'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    NetworkImage(data['photoURL'].toString()),
                              ),
                              Text(
                                  'Would you like to delete the user profile?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Approve'),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(data['uid'])
                                  .delete();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => LoginScreens()));
                            },
                          ),
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => BusinessView(data: data)));
                }
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
