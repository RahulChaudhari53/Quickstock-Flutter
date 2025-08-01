import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickstock/app/constant/api_endpoints.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_event.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity user;

  const ProfileHeader({super.key, required this.user});

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final viewModel = context.read<ProfileViewModel>();

    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (!context.mounted) return;

    if (!cameraStatus.isGranted && !galleryStatus.isGranted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Camera and Photo permissions are required to change profile picture.',
          ),
        ),
      );
      return;
    }

    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Select Image Source'),
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: const EdgeInsets.symmetric(vertical: 24.0),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceButton(
                  dialogContext,
                  Icons.camera_alt_outlined,
                  'Camera',
                  ImageSource.camera,
                ),
                _buildSourceButton(
                  dialogContext,
                  Icons.photo_library_outlined,
                  'Gallery',
                  ImageSource.gallery,
                ),
              ],
            ),
          ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1024,
    );

    if (pickedFile == null) return;

    if (!context.mounted) return;

    final imageFile = File(pickedFile.path);
    viewModel.add(ProfileImageUpdateEvent(image: imageFile));
  }

  Widget _buildSourceButton(
    BuildContext context,
    IconData icon,
    String label,
    ImageSource source,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context, source),
          iconSize: 50,
        ),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
        user.profileImage != null
            ? '${ApiEndpoints.serverAddress}/${user.profileImage!.replaceAll('\\', '/')}'
            : null;

    final placeholder =
        'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=059669&color=fff&size=128';

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: theme.dividerColor,
                // The key is important to force a redraw when the URL changes after an upload.
                // The errorBuilder handles cases where the network image fails to load.
                backgroundImage: NetworkImage(imageUrl ?? placeholder),
                onBackgroundImageError: (_, __) {
                  print("Failed to load profile image from: $imageUrl");
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: theme.colorScheme.primary,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => _pickAndUploadImage(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(user.fullName, style: theme.textTheme.displaySmall),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
