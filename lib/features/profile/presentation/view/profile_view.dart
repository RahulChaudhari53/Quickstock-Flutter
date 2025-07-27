import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:quickstock/core/common/profile/detail_card.dart';
import 'package:quickstock/core/common/profile/profile_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<StatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? editMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),

      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        
      ],
      ),
    );
  }

  // main profile card for image and name
  Widget buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: Image.network(
                  "https://ui-avatars.com/api/?name=John+Doe&background=374151&color=fff&size=128",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      print("Edit Image tapped");
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        LucideIcons.edit2,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe", // Replace with dynamic data
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "john.doe@example.com", // Replace with dynamic data
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // personal information card
  Widget buildPersonalInfoCard() {
    return ProfileCard(
      title: "Personal Information",
      child:
          editMode == 'name'
              ? buildNameEditForm() // Show form if editMode is 'name'
              : DetailRow(
                // Otherwise, show the detail row
                label: "Full Name",
                value: "John Doe",
                onEditClick: () {
                  setState(() {
                    editMode = 'name';
                  });
                },
              ),
    );
  }

  // form to edit name shown conditionally
  Widget buildNameEditForm() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Save")),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  editMode = null;
                });
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }

  // contact details card
  Widget buildContactDetailsCard() {
    const String primaryPhone = "123-456-7890";
    const String? secondaryPhone = null;
    return ProfileCard(
      title: "Contact Details",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Email Section ---
          // add an edit form for it
          // later using the same `editMode == 'email'` logic.
          DetailRow(
            label: "Email Address",
            value: "john.doe@example.com",
            onEditClick: () {
              print("Edit email clicked");
            },
          ),
          const Divider(height: 30.0),

          // --- Phone Numbers Section ---
          const Text(
            "Phone Numbers",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Primary Phone Display
          Row(
            children: [
              Text(primaryPhone, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Chip(
                label: const Text("Primary"),
                labelStyle: const TextStyle(fontSize: 10),
                backgroundColor: Colors.grey.shade200,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Secondary Phone Display (Conditional)
          if (secondaryPhone != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(secondaryPhone, style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(
                    LucideIcons.trash2,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    // Logic to delete secondary phone
                    print("Delete secondary phone");
                  },
                  splashRadius: 20,
                ),
              ],
            ),

          // Conditional "Add Phone" button OR the edit form
          if (secondaryPhone == null && editMode != 'phone')
            TextButton.icon(
              icon: const Icon(LucideIcons.plusCircle, size: 18),
              label: const Text("Add secondary phone"),
              onPressed: () {
                setState(() {
                  editMode = 'phone';
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
            )
          else if (editMode == 'phone')
            buildPhoneEditForm(),
        ],
      ),
    );
  }

  Widget buildPhoneEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'New Phone Number',
            hintText: 'Enter 10 digits',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // Add phone logic here
                print("Adding phone...");
                setState(() {
                  editMode = null;
                });
              },
              child: const Text("Add"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  editMode = null;
                });
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }

  // security card
  Widget buildSecurityCard() {
    return ProfileCard(
      title: "Security",
      child: DetailRow(
        label: "Password",
        value: "••••••••",
        onEditClick: () {
          // would set _editMode to 'password' here
        },
      ),
    );
  }

  // danger zone for deactivating account
  Widget buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Danger Zone",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Deactivating your account is a permanent action and cannot be undone.",
            style: TextStyle(color: Colors.red.shade700),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onPressed: () {},
              child: const Text("Deactivate Account"),
            ),
          ),
        ],
      ),
    );
  }
}
