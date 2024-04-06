import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/models/post.dart';
import 'package:posts/widgets/toast.dart';
import 'package:xid/xid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;
  File? _selectedImage;
  bool _imageIsFullWidth = true;
  String _postText = "";

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _handleImageWidth() {
    setState(() {
      _imageIsFullWidth = !_imageIsFullWidth;
    });
  }

  void _handleCreatePost() async {
    try {
      print("loading");
      final String postId = Xid().toString();
      String postPhotoUrl = "";

      if (_selectedImage != null) {
        final Reference photoRef = storage.ref(postId);
        await photoRef
            .putFile(
          _selectedImage!,
        )
            .catchError((error) {
          print(error);
        });

        postPhotoUrl = await photoRef.getDownloadURL();
      }

      Post createdPost = Post(
        postId: postId,
        postText: _postText,
        postImage: postPhotoUrl,
        postOwnerId: _auth.currentUser!.uid,
        postTime: Timestamp.now(),
        likeCount: 0,
        postComments: [],
      );

      await _db
          .collection("posts")
          .doc(postId)
          .set(createdPost.toJson())
          .then((value) {
        Toast(
          toastType: ToastType.success,
          toastText: "Post sent",
        );

        Navigator.pop(context);
      }).catchError((error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          Toast(
            toastType: ToastType.descructive,
            toastText: "Something went wrong",
          ),
        );
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        Toast(
          toastType: ToastType.descructive,
          toastText: "Something went wrong",
        ),
      );
    } finally {
      print("completed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kWhite,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: kLines,
            height: 1,
          ),
        ),
        actions: [
          Visibility(
            visible: _postText.isNotEmpty || _selectedImage != null,
            child: GestureDetector(
              onTap: () {
                _handleCreatePost();
              },
              child: Container(
                alignment: Alignment.center,
                height: 32,
                width: 64,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Post",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: kWhite,
                    wordSpacing: 1.2,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    maxLines: null,
                    autofocus: true,
                    cursorColor: kPrimary,
                    maxLength: 280,
                    onChanged: (value) {
                      setState(() {
                        _postText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Type here",
                      contentPadding: EdgeInsets.all(0),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _selectedImage != null,
                    child: GestureDetector(
                      onTap: () {
                        _handleImageWidth();
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: kLines),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 300,
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: _imageIsFullWidth
                                    ? BoxFit.cover
                                    : BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _openImagePicker();
                      },
                      child: SvgPicture.asset(
                        "images/image.svg",
                        semanticsLabel: "image",
                        width: 18,
                        height: 18,
                      ),
                    ),
                    Text(
                      "${_postText.length} / 280",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
