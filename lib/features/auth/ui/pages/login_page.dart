import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/app_bar/app_bar_widget.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
import 'package:livekit_manager/features/auth/bloc/logged_user_cubit/logged_user_cubit.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';

import '../../../staff_record/bloc/staff_details_cubit/staff_details_cubit.dart';
import '../../bloc/login_cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginCubit get loginCubit => context.read<LoginCubit>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginCubit.setPhone = 'rakan.alassta@gmail.com';
    loginCubit.setPassword = 'P@ssw0rd2025';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginInitial>(
          listenWhen: (p, c) => c.done,
          listener: (context, state) {
            context.read<StaffDetailsCubit>().getData();
            context.goNamed(RouteName.sessions);
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0).r,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                20.0.verticalSpace,
                ImageMultiType(
                  url: Assets.iconsSyrianV,
                  height: 150.0.r,
                ),

                40.0.verticalSpace,
                Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        MyTextFormWidget(
                          autofillHints: const [AutofillHints.username, AutofillHints.email],
                          validator: (p0) => p0.validateEmpty,
                          titleLabel: S.of(context).email,
                          hint: S.of(context).email,
                          initialValue: loginCubit.state.mRequest.email,
                          keyBordType: TextInputType.emailAddress,
                          onChanged: (val) => loginCubit.setPhone = val,
                        ),

                        15.0.verticalSpace,
                        // if (loginCubit.validatePhone != null) 15.0.verticalSpace,
                        MyTextFormWidget(
                          autofillHints: const [AutofillHints.password],
                          validator: (p0) => p0.validateEmpty,
                          titleLabel: S.of(context).password,
                          hint: S.of(context).password,
                          obscureText: true,
                          initialValue: loginCubit.state.mRequest.password,
                          onChanged: (val) => loginCubit.setPassword = val,
                        ),
                      ],
                    ),
                  ),
                ),
                40.0.verticalSpace,
                BlocBuilder<LoggedUserCubit, LoggedUserInitial>(
                  builder: (context, lState) {
                    return BlocBuilder<LoginCubit, LoginInitial>(
                      builder: (_, state) {
                        return MyButton(
                          loading: state.loading || lState.loading,
                          text: S.of(context).login,
                          onTap: () {
                            if (!_formKey.currentState!.validate()) {
                              setState(() {});
                              return;
                            }
                            TextInput.finishAutofillContext();
                            loginCubit.login();
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
