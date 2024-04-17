import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/profile_details.dart';
import 'package:posts/screens/user_profile_screen.dart';
import 'package:posts/widgets/profile_avatar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _db = FirebaseFirestore.instance;
  final List<ProfileDetails> _allProfiles = [];
  List<ProfileDetails> _searchedProfiles = [];
  final TextEditingController _searchText = TextEditingController();

  void _getProfiles() async {
    final querySnapshot = await _db.collection("users").get();
    for (var docSnapshot in querySnapshot.docs) {
      final profileData = ProfileDetails.fromFirestore(
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>);

      ProfileDetails profile = ProfileDetails(
        email: profileData.email,
        name: profileData.name,
        profilePhoto: profileData.profilePhoto,
        uid: profileData.uid,
      );
      _allProfiles.add(profile);
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kWhite,
        title: SearchInput(
          controller: _searchText,
          enabled: true,
          onChanged: (value) {
            if (value.isNotEmpty) {
              final searchRes = _allProfiles
                  .where((eachProfile) => eachProfile.name
                      .toLowerCase()
                      .contains(value.toLowerCase().trim()))
                  .toList();
              setState(() {
                _searchedProfiles = searchRes;
              });
            } else {
              setState(() {
                _searchedProfiles = [];
              });
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: kLines,
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: _searchedProfiles.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            userId: _searchedProfiles[index].uid,
                          ),
                        ),
                      );
                    },
                    child: ProfileAvatar(
                      profileDetails: _searchedProfiles[index],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: _searchedProfiles.length,
              )
            : (_searchText.text.isNotEmpty && _searchedProfiles.isEmpty)
                ? Center(child: Text("No results for ${_searchText.text}"))
                : const Text(""),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final void Function(String)? onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      enabled: enabled,
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: kWhite,
        hintText: "Search for a profile",
        hintStyle: TextStyle(fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
