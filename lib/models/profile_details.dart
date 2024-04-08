class ProfileDetails {
  factory ProfileDetails.fromMap(Map<String, dynamic> profileData) {
    return ProfileDetails(
      email: profileData["email"],
      name: profileData["name"],
      profilePhoto: profileData["email"],

    );
  }
  ProfileDetails({required this.email, required this.name, required this.profilePhoto});

  final String name;
  final String email;
  final String profilePhoto;
}
