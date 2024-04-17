import 'package:flutter/material.dart';
import 'package:posts/models/profile_details.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profileDetails});

  final ProfileDetails profileDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                profileDetails.profilePhoto,
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(profileDetails.name)
          ],
        ),
      ),
    );
  }
}
