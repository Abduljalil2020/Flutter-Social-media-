// import 'package:bloc/bloc.dart';
// import 'package:connect_social/modules/social_login_screen.dart';
// import 'package:connect_social/shared/bloc_observer.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//    // options: DefaultFirebaseOptions.currentPlatform,
//   );
//   BlocOverrides.runZoned(
//           () {
//         runApp(MyApp(
//
//         ));
//       },
//       blocObserver:  MyBlocObserver());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         primarySwatch: Colors.blue,
//       ),
//       home: SocialLoginScreen(),
//     );
//
//   }
//
// }
//
import 'package:bloc/bloc.dart';
import 'package:connect_social/layout/Test.dart';
import 'package:connect_social/shared/bloc_observer.dart';
import 'package:connect_social/shared/components/components.dart';
import 'package:connect_social/shared/components/constants.dart';
import 'package:connect_social/shared/cubit/app_cubit/cubit.dart';
import 'package:connect_social/shared/cubit/app_cubit/states.dart';
import 'package:connect_social/shared/cubit/login_cubit/cubit.dart';
import 'package:connect_social/shared/cubit/social_cubit/cubit.dart';
import 'package:connect_social/shared/network/local/cache_helper.dart';
import 'package:connect_social/shared/network/remote/dio_helper.dart';
import 'package:connect_social/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/social_layout.dart';
import 'model/social_user_model.dart';
import 'modules/social_login/social_login_screen.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());

  showToast(text: 'on background message', state: ToastStates.SUCCESS,);
}

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var token =await FirebaseMessaging.instance.getToken();
  print(token);
     // foreground fcm
    //الابليكيشن مفتوح
  FirebaseMessaging.onMessage.listen((event)
  {

        print( "the data is" + event.data.toString());
        showToast(text: 'on massage', state: ToastStates.SUCCESS);
  });
  //الابليكيشن فى الباك جراوند
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print( "the data is" + event.data.toString());
    showToast(text: 'on massage opened', state: ToastStates.SUCCESS);

  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  DioHelper.init();
  await CasheHelper.init();

  bool isDark = CasheHelper.getData(key: 'isDark');




  Widget widget;

  //bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  //token = CacheHelper.getData(key: 'token');

  uId = CasheHelper.getData(key: 'uId');



  if(uId != null)
  {
    widget = SocialLayout();
  } else
  {
    widget = SocialLoginScreen();
  }
  BlocOverrides.runZoned(
          () {
            runApp(MyApp(
               isDark: isDark,
              startWidget: widget,
            ));
      },
      blocObserver:  MyBlocObserver());


}




class MyApp extends StatelessWidget
{
  // constructor
  // build
  final bool? isDark;
  final Widget? startWidget;


  MyApp({
    this.isDark,
    this.startWidget,

  });

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData()
            ..getPosts()
        ),




        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
           ),
        ),




      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:ThemeMode.light,
            //AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
