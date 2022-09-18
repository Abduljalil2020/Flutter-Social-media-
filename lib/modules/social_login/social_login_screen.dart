// import 'package:conditional_builder/conditional_builder.dart';
// import 'package:connect_social/modules/social_register/social_register_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../layout/social_layout.dart';
// import '../../shared/components/components.dart';
// import '../../shared/cubit/login_cubit/cubit.dart';
// import '../../shared/cubit/login_cubit/states.dart';
// import '../../shared/cubit/social_cubit/cubit.dart';
// import '../../shared/network/local/cache_helper.dart';
//
// class SocialLoginScreen extends StatelessWidget {
//   var formKey = GlobalKey<FormState>();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => SocialLoginCubit(),
//       child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
//         listener: (context, state) {
//           if (state is SocialLoginErrorState) {
//             showToast(
//               text: state.error,
//               state: ToastStates.ERROR,
//             );
//           }
//           if(state is SocialLoginSuccessState)
//           {
//             CasheHelper.saveData(
//               key: 'uId',
//               value: state.uId,
//             ).then((value)
//             {
//               navigateAndFinish(
//                 context,
//                 SocialLayout(),
//               );
//             });
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             appBar: AppBar(),
//             body: Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'LOGIN',
//                           style: Theme.of(context).textTheme.headline4?.copyWith(
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           'Login now to communicate with friends',
//                           style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                             color: Colors.grey,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 30.0,
//                         ),
//                         defaultFormField(
//                           controller: emailController,
//                           type: TextInputType.emailAddress,
//                           validate: (String value) {
//                             if (value.isEmpty) {
//                               return 'please enter your email address';
//                             }
//                           },
//                           label: 'Email Address',
//                           prefix: Icons.email_outlined,
//                         ),
//                         SizedBox(
//                           height: 15.0,
//                         ),
//                         defaultFormField(
//                           controller: passwordController,
//                           type: TextInputType.visiblePassword,
//                           suffix: SocialLoginCubit.get(context).suffix,
//                           onSubmit: (value) {
//                             if (formKey.currentState!.validate()) {
//                               SocialLoginCubit.get(context).userLogin(
//                                 email: emailController.text,
//                                 password: passwordController.text,
//                               );
//                             }
//                           },
//                           isPassword: SocialLoginCubit.get(context).isPassword,
//                           suffixPressed: () {
//                             SocialLoginCubit.get(context)
//                                 .changePasswordVisibility();
//                           },
//                           validate: (String value) {
//                             if (value.isEmpty) {
//                               return 'password is too short';
//                             }
//                           },
//                           label: 'Password',
//                           prefix: Icons.lock_outline,
//                         ),
//                         SizedBox(
//                           height: 30.0,
//                         ),
//                         ConditionalBuilder(
//                           condition: state is! SocialLoginLoadingState,
//                           builder: (context) => defaultButton(
//                             function: () {
//                               if (formKey.currentState!.validate()) {
//                                 SocialLoginCubit.get(context).userLogin(
//                                   email: emailController.text,
//                                   password: passwordController.text,
//                                 );
//                                 SocialCubit.get(context).getUserData();
//                               }
//                             },
//                             text: 'login',
//                             isUpperCase: true,
//                           ),
//                           fallback: (context) =>
//                               Center(child: CircularProgressIndicator()),
//                         ),
//                         SizedBox(
//                           height: 15.0,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Don\'t have an account?',
//                             ),
//                             defaultTextButton(
//                               function: () {
//                                 navigateTo(
//                                   context,
//                                   SocialRegisterScreen(),
//                                 );
//                               },
//                               text: 'register',
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/social_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/login_cubit/cubit.dart';
import '../../shared/cubit/login_cubit/states.dart';
import '../../shared/cubit/social_cubit/cubit.dart';
import '../../shared/network/local/cache_helper.dart';
import '../social_register/social_register_screen.dart';

class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    var emailcontroller = TextEditingController();
    var passwordcontroller = TextEditingController();
    var formkey = GlobalKey<FormState>();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => SocialCubit()),
          BlocProvider(create: (BuildContext context) => SocialLoginCubit()),
        ],
        child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
          listener: (context, state) {
            if (state is SocialLoginErrorState) {
              showToast(
                  text: state.error.toString(),
                  state: ToastStates.ERROR,
                 );
            }
            if (state is SocialLoginSuccessState) {
              CasheHelper.saveData(
                key: 'uId',
                value: state.uId,
              );
              navigateTo(context, SocialLayout());
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOGIN ',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.teal),
                            // TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Welcome to Social App ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('email'),
                          SizedBox(
                            height: 5,
                          ),
                          defaultFormField(
                            controller: emailcontroller,
                            validate: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'must be entered';
                              } else
                                return null;
                            },
                            type: TextInputType.emailAddress,
                            prefix: Icons.email_outlined,
                            label: 'EMAIL ADRESS',
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Password'),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                            suffixPressed: () {
                              SocialLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            onSubmit: (value) {
                              if (formkey.currentState?.validate() != null) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text);
                              }
                            },
                            controller: passwordcontroller,
                            validate: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'must be entered';
                              } else
                                return null;
                            },
                            type: TextInputType.text,
                            prefix: Icons.password,
                            isPassword: SocialLoginCubit.get(context).isPassword,
                            label: 'PASSWORD',
                            suffix: SocialLoginCubit.get(context).suffix,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          state is SocialLoginLoadingState
                              ? Center(child: CircularProgressIndicator())
                              : defaultButton(radius: 30,width: 350,
                            function: () {
                              if (formkey.currentState?.validate() !=
                                  null) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text);
                                // SocialCubit.get(context).getUserData();
                                //  SocialCubit.get(context).getUsers();

                              }
                            },
                            text: 'login',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(
                                      context,
                                      SocialRegisterScreen(),
                                    );
                                  },
                                  child: Text('Sign up ')),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
