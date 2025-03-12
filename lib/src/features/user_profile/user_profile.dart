import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:project_pjam_2023/src/shared/components/allowed_clinician_card.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../shared/components/drawer.dart';
import '../../shared/configs/constants.dart';
import '../../shared/dtos/user_dto.dart';
import '../../shared/services/auth_service.dart';
import 'user_profile_provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().fetchProfile();
      if (AuthService().getUserRole() == rolePatient) {
        context.read<UserProfileProvider>().fetchAllClinicians();
        context.read<UserProfileProvider>().fetchAllowedClinicians();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Consumer<UserProfileProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (userProvider.user == null) {
              return const Center(
                child: Text("No data found"),
              );
            } else {
              return buildProfileDetails();
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileDetails() {
    UserProfileProvider userProfileProvider =
        context.read<UserProfileProvider>();
    ProfileDTO? profileDTO = userProfileProvider.user;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RandomAvatar(
            profileDTO!.name + profileDTO.email,
            height: 50,
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Name: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: profileDTO.name,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Email: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: profileDTO.email,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Role: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: profileDTO.roleDescription == 'user'
                      ? 'Patient'
                      : 'Clinician',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Created at: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat("MMM dd, y HH:mm")
                      .format(profileDTO.createdAt),
                ),
              ],
            ),
          ),
          if (AuthService().getUserRole() == rolePatient)
            buildAllowCliniciansSection(),
        ],
      ),
    );
  }

  Widget buildAllowCliniciansSection() {
    UserProfileProvider userProfileProvider =
        context.read<UserProfileProvider>();

    List<ClinicianDTO> allClinicians = userProfileProvider.clinicians;
    List<ClinicianDTO> allowedClinicians =
        userProfileProvider.allowedClinicians;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 32,
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 24, color: Colors.black),
            children: [
              TextSpan(
                text: "Allow Clinicians",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        TypeAheadField(
          builder: (context, controller, focusNode) => TextField(
            controller: controller,
            focusNode: focusNode,
            // autofocus: true,
            decoration: const InputDecoration(
              hintText: "Select clinicians",
            ),
          ),
          onSelected: (ClinicianDTO item) {
            setState(() {
                userProfileProvider.addOrRemoveAllowedClinician(item);
            });
          },
          suggestionsCallback: (String search) {
            return allClinicians
                .where((clinician) =>
                    clinician.name.toLowerCase().contains(search.toLowerCase()))
                .toList();
          },
          itemBuilder: (BuildContext context, value) {
            bool isSelected =
                allowedClinicians.any((clinician) => clinician.id == value.id);
            return ListTile(
              title: Text(value.name),
              trailing: isSelected ? const Icon(Icons.check) : null,
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            userProfileProvider.submitAllowedClinicians();
          },
          child: const Text('Update'),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userProfileProvider.allowedClinicians.length,
          itemBuilder: (context, index) {
            final item = userProfileProvider.allowedClinicians[index];
            return AllowedClinicianCard(
              clinician: item,
              onDelete: () => userProfileProvider.addOrRemoveAllowedClinician(item),
            );
          },
        )
      ],
    );
  }
}
