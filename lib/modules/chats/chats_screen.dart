import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect_social/modules/chats/chat_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/social_user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/social_cubit/cubit.dart';
import '../../shared/cubit/social_cubit/states.dart';

class ChatsScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(context,SocialCubit.get(context).users[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChatItem(context,SocialUserModel model) => InkWell(
    onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailsScreen(userModel: model),
        ),
      );


    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}',
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}