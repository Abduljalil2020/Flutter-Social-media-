abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates
{
  final String error;

  SocialGetUserErrorState(this.error);
}
//chat get all users
class SocialAllUsersLoadingState extends SocialStates {}

class SocialAllUsersSuccessState extends SocialStates {}

class SocialAllUsersErrorState extends SocialStates
{
  final String error;

  SocialAllUsersErrorState(this.error);
}



class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates {}
class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}
class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImagePickedSuccessState extends SocialStates {}
class SocialUploadProfileImagePickedErrorState extends SocialStates {}

class SocialUploadCoverImagePickedSuccessState extends SocialStates {}
class SocialUploadCoverImagePickedErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}
class SocialUserUpdateErrorState extends SocialStates {}
///posts
class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

//get post
class SocialGetPostLoadingState extends SocialStates {}
class SocialGetPostSuccessState extends SocialStates {

}
class SocialGetPostErrorState extends SocialStates {
  final String error;
  SocialGetPostErrorState(this.error);
}

//like Button
class SocialLikePostSuccessState extends SocialStates {

}
class SocialLikePostErrorState extends SocialStates {
  final String error;
  SocialLikePostErrorState(this.error);
}

//chats
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessagesSuccessState extends SocialStates {}
