import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubit/social_cubit/cubit.dart';
import '../../shared/cubit/social_cubit/states.dart';
import '../../shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = SocialCubit.get(context).userModel!;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;

           nameController.text  = userModel.name.toString();
           bioController.text   = userModel.bio.toString();
           phoneController.text = userModel.phone.toString();
           emailController.text = userModel.email.toString();


          return Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: 'EditProfile',
              actions: [
                defaultTextButton(
                    function: () {
                      SocialCubit.get(context).uploadProfileImage(
                          name : nameController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                          bio: bioController.text
                      );
                    },
                    text: 'Update'),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(

                  children: [
                    if(state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                    if(state is SocialUserUpdateLoadingState)
                    SizedBox(
                      height: 5.0,
                    ),

                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 190.0,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topCenter,
                                child: Container(
                                  height: 140.0,
                                  width: double.infinity,
                                  child: Image(
                                    image: (coverImage != null)
                                        ? FileImage(File(coverImage.path))
                                            as ImageProvider
                                        : NetworkImage(
                                            '${userModel.cover}',
                                          ),
                                    fit: BoxFit.cover,
                                  ),

                                  //                          decoration: BoxDecoration(
                                  //
                                  //                            borderRadius: BorderRadius.only(
                                  //                                topLeft: Radius.circular(
                                  //                                  4.0,
                                  //                                ),
                                  //                                 topRight: Radius.circular(
                                  //                                  4.0,
                                  //                              ),
                                  //                            ),
                                  //
                                  // image: (coverImage != null) ? FileImage(File(coverImage.path)) as ImageProvider: DecorationImage(
                                  //                              image: NetworkImage(
                                  //                                '${userModel.cover}',
                                  //                              ),
                                  //                              fit: BoxFit.cover,
                                  //                            ) ,
                                  //
                                  //                          ),
                                ),
                              ),
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  CircleAvatar(
                                    radius: 64.0,
                                    backgroundColor:
                                        Theme.of(context).scaffoldBackgroundColor,
                                    child: CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: (profileImage == null)
                                          ? NetworkImage(
                                              '${userModel.image}',
                                            )
                                          : FileImage(profileImage)
                                              as ImageProvider,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context).getProfileImage();
                                    },
                                    icon: CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            SocialCubit.get(context).getCoverImage();
                          },
                          icon: CircleAvatar(
                            radius: 20,
                            child: Icon(
                              IconBroken.Camera,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    if (SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage!=null)
                        Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                               background: Colors.teal,
                               //Color(0xffe0c3de),
                                  function: (){
                                    SocialCubit.get(context).uploadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        bio: bioController.text
                                    );

                                  },
                                  text: 'update profile'
                              ),
                              if(state is SocialUserUpdateLoadingState)
                              SizedBox(height: 5,),
                              if(state is SocialUserUpdateLoadingState)
                                LinearProgressIndicator(),

                            ],
                          ),
                        ),
                        SizedBox(width: 5,),
                        if (SocialCubit.get(context).coverImage!=null)
                          Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                  function: (){

                                    SocialCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        bio: bioController.text
                                    );
                                  },
                                  background: Colors.teal,
                                  text: 'update cover'
                              ),
                              if(state is SocialUserUpdateLoadingState)
                                SizedBox(height: 5,),
                              if(state is SocialUserUpdateLoadingState)
                                LinearProgressIndicator(),

                            ],
                          ),
                        ),


                      ],
                    ),
                    if (SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                      SizedBox(
                      height: 25.0,
                    ),

                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'name must not be empty';
                          }
                        },
                        label: 'Name',
                        prefix: IconBroken.User),
                    SizedBox(
                      height: 25.0,
                    ),
                    defaultFormField(
                        controller: bioController,
                        type: TextInputType.text,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'bio must not be empty';
                          }
                        },
                        label: 'Bio',
                        prefix: IconBroken.Info_Circle
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'email must not be empty';
                          }
                        },
                        label: 'email',
                        prefix: IconBroken.Message
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'phone must not be empty';
                          }
                        },
                        label: 'phone',
                        prefix: IconBroken.Call
                    ),
                    defaultButton(function: (){
                      signOut(context);
                    },
                        text: 'signOut'
                    )





                  ],
                ),
              ),
            ),
          );
        });
  }
}
