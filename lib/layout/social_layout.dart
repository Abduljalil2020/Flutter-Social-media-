import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/new_post/new_post_screen.dart';
import '../shared/components/components.dart';
import '../shared/cubit/social_cubit/cubit.dart';
import '../shared/cubit/social_cubit/states.dart';
import '../shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(
            context,
            NewPostScreen(),
          );
        }
      },
      builder: (context, state)
      {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          // appBar : defaultAppBar(
          //     context: context,
          //   title: Text(
          //     cubit.titles[cubit.currentIndex],
          //   ),
          //
          //
          //
          // ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: ()
              {
                // Navigator.pop(context);
              },
              icon: Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
            title: Text(
              cubit.titles[cubit.currentIndex],

            ),
              actions: [
                IconButton(
                  icon: Icon(
                    IconBroken.Notification,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    IconBroken.Search,
                  ),
                  onPressed: () {},
                ),
              ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Paper_Upload,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Location,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
