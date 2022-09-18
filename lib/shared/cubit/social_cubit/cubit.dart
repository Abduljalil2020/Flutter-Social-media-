
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_social/shared/cubit/social_cubit/states.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/message_model.dart';
import '../../../model/post_model.dart';
import '../../../model/social_user_model.dart';
import '../../../model/user_model.dart';
import '../../../modules/chats/chats_screen.dart';
import '../../../modules/feeds/feeds_screen.dart';
import '../../../modules/new_post/new_post_screen.dart';
import '../../../modules/settings/settings_screen.dart';
import '../../../modules/users/users_screen.dart';
import '../../components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {

  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
     SocialUserModel? userModel;
  // void getUserData()  {
  //   emit(SocialGetUserLoadingState());
  //      FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uId)
  //       .get()
  //       .then((value) {
  //     userModel =    SocialUserModel.fromJson(value.data());
  //     print(value.data());
  //     print("the uid is $uId" );
  //     emit(SocialGetUserSuccessState());
  //   })
  //       .catchError((error) {
  //     print(error.toString());
  //     emit(SocialGetUserErrorState(error.toString()));
  //   });
  // }
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }
  int currentIndex = 0;
  List<Widget> screens =
  [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles =
  [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index==1){
      getUsers();
    }
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }


  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    if (pickedFile != null) {
      final profileImagetemp = File(pickedFile.path);
      profileImage = profileImagetemp;
      emit(SocialProfileImagePickedSuccessState());
    }
    else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

//cover image
  File? coverImage;

  // var picker = ImagePicker(); we dont need it again
  Future<void> getCoverImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    if (pickedFile != null) {
      final coverImagetemp = File(pickedFile.path);
      coverImage = coverImagetemp;
      emit(SocialCoverImagePickedSuccessState());
    }
    else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }
  void uploadProfileImage
      (
  {
  required String name,
    required String phone,
    required String email,
    required String bio,
}
      ) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance.ref().child(
        'users/${Uri
            .file(profileImage!.path)
            .pathSegments
            .last
        }'
    )
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImagePickedSuccessState());
        print(value);
       updateUser(
           name: name,
           phone: phone,
           email: email,
           bio: bio,
           image: value,
       );
      }).catchError((error) {
        emit(SocialUploadProfileImagePickedErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImagePickedErrorState());
    });
  }


  void uploadCoverImage({
    required String name,
    required String phone,
    required String email,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance.ref().child(
        'users/${Uri
            .file(coverImage!.path)
            .pathSegments
            .last
        }'
    )
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
       // emit(SocialUploadCoverImagePickedSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          email: email,
          bio: bio,
          cover: value,
        );      }).catchError((error) {
        emit(SocialUploadCoverImagePickedErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImagePickedErrorState());
    });
  }

  void updateUser
      ({
    String? name,
    String? phone,
    String? email,
    String? bio,
    String? cover,
    String? image,

  })
  {
    emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name??userModel?.name,
      email: email??userModel?.email,
      phone: phone??userModel?.phone,
      bio: bio??userModel?.bio,
      cover: cover??userModel?.cover,
      image: image??userModel?.image,
      isEmailVerified: userModel?.isEmailVerified,
      uId: userModel?.uId,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    })
        .catchError(
            (error) {
          emit(SocialUserUpdateErrorState());
        }
    );

    // if(profileImage!=null)
    // {
    //  // uploadProfileImage();
    // }
    // else if(coverImage!=null){
    //  // uploadCoverImage();
    // }
    // else{
    // }

  }


  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      print(pickedFile.path);

      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadpostImage({
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(datetime: dateTime, text: text, postimage: value);
      }).catchError((error) {
        print(error.toString());
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String datetime,
    required String text,
    String? postimage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: datetime,
      text: text,
      postImage: postimage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

    void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }
    List <PostModel>posts = [];
  List <String>postsId = [];
  List <int> likes = [];

  // void getPosts()
  // {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .get()
  //       .then((value)
  //   {
  //     value.docs.forEach((element)
  //     {
  //       posts.add(PostModel.fromJson(element.data()));
  //     });
  //
  //     emit(SocialGetPostSuccessState());
  //   })
  //       .catchError((error){
  //     emit(SocialGetPostErrorState(error.toString()));
  //   });
  // }
  void getPosts()
  {
    FirebaseFirestore.instance.collection('posts').get().then((value)
    {
      value.docs.forEach((element)
      {
        element.reference
            .collection('likes')
            .get()
            .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostSuccessState());
        })
            .catchError((error){});
      });

      //emit(SocialGetPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }


    List<SocialUserModel> users = [];

    // void getUsers()
    // {
    //   if(users.length==0)
    //   FirebaseFirestore.instance.collection('users').get().then((value)
    //   {
    //     value.docs.forEach((element)
    //     {
    //       if(element.data()['uId'] == userModel!.uId ) {
    //         users.add(SocialUserModel.fromJson(element.data()));
    //       }
    //     });
    //
    //     emit(SocialAllUsersSuccessState());
    //   }).catchError((error) {
    //     print(error.toString());
    //     emit(SocialAllUsersErrorState(error.toString()));
    //   });
    // }
  void getUsers() {
    users = [];
    emit(SocialAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != uId)
          users.add(SocialUserModel.fromJson(element.data()));
        emit(SocialAllUsersSuccessState());
      });
    }).catchError((error) {
      emit(SocialAllUsersErrorState(error.toString()));
    });
  }
  List<MessageModel> messages = [];
  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

  }

 // List<MessageModel> messages = [];

  void getMessages({
   required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
         messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }
  }
