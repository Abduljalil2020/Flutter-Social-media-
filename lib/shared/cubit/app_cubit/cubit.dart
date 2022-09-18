import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_social/shared/cubit/app_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/social_user_model.dart';
import '../../components/constants.dart';
import '../../network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  bool isDark = true;

  void changeAppMode({bool? fromShared})
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark = !isDark;
      CasheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }


}
