import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/auth/data/request/login_request.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_provider.dart';
import '../../../../core/error/error_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../../../generated/l10n.dart';
import '../../data/response/login_response.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginInitial> {
  LoginCubit() : super(LoginInitial.initial());

  Future<void> login() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final pair = await _loginApi();

    if (pair.first == null) {
      emit(state.copyWith(statuses: CubitStatuses.error, error: pair.second));
      showErrorFromApi(state);
    } else {
      await AppProvider.login(response: pair.first!);
      emit(state.copyWith(statuses: CubitStatuses.done, result: pair.first));
    }
  }

  Future<Pair<LoginResponse?, String?>> _loginApi() async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: PostUrl.loginUrl,
      hostName: 'ims-be.coretech-mena.com',
      body: state.mRequest.toJson(),
    );

    if (response.statusCode.success) {
      final pair = Pair(LoginResponse.fromJson(response.jsonBody), null);

      return pair;
    } else {
      final error = response.getPairError as Pair<LoginResponse?, String?>;

      return error;
    }
  }

  set setPhone(String? phone) => state.mRequest.email = phone;

  set setPassword(String? password) => state.mRequest.password = password;

  String? get validatePhone {
    if (state.mRequest.email.isBlank) {
      return '${S().email} - ${S().phoneNumber}'
          ' ${S().is_required}';
    }
    return null;
  }

  String? get validatePassword {
    if (state.mRequest.password.isBlank) {
      return '${S().password} ${S().is_required}';
    }
    return null;
  }
}
