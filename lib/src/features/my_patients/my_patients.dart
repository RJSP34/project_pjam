import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/components/drawer.dart';
import '../../shared/components/patients_card.dart';
import 'my_patients_provider.dart';

class MyPatients extends StatefulWidget {
  const MyPatients({super.key});

  @override
  State<MyPatients> createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyPatientsProvider>().fetchPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Patients"),
      ),
      drawer: MyDrawer(),
      body: Consumer<MyPatientsProvider>(
        builder: (context, myPatientsProvider, child) {
          if (myPatientsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (myPatientsProvider.patients.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          } else {
            return ListView.builder(
              itemCount: myPatientsProvider.patients.length,
              itemBuilder: (context, index) {
                final item = myPatientsProvider.patients[index];
                return PatientsCard(
                  patientID: item.patientId,
                  clinicianID: item.clinicianId,
                  patientName: item.patientName,
                  patientEmail: item.patientEmail,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<MyPatientsProvider>(context, listen: false)
              .fetchPatients();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
