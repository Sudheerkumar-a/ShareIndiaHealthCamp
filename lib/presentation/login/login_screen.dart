import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/local/user_data_db.dart';
import 'package:shareindia_health_camp/domain/entities/user_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/presentation/home/user_main_screen.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';

class LoginScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: LoginScreen(),
      ),
      (_) => false,
    );
  }

  LoginScreen({super.key});
  final _userBloc = sl<UserBloc>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final resource = context.resources;
    _emailTextController.text = 'srinu431@gmail.com';
    _passwordTextController.text = 'Works@909';
    return SafeArea(
      child: Scaffold(
        backgroundColor: resource.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is OnLoginLoading) {
                Dialogs.loader(context);
              } else if (state is OnApiResponse) {
                final loginEntity = cast<LoginEntity?>(
                  state.responseEntity.entity,
                );
                userToken = loginEntity?.token ?? '';
                context.userDataDB.put(
                  UserDataDB.userToken,
                  loginEntity?.token,
                );
                context.userDataDB.put(
                  UserDataDB.user,
                  loginEntity?.userEntity?.toJson(),
                );
                UserMainScreen.start(context);
              } else if (state is OnLoginApiError) {
                Dialogs.dismiss(context);
                Dialogs.showInfoDialog(context, PopupType.fail, state.message);
              }
            },
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(resource.dimen.dp20),
                  decoration: BackgroundBoxDecoration().gradientColorBg,
                  child: Text(
                    textAlign: TextAlign.center,
                    'Andhra Pradesh State Health Camp',
                    style: context.textFontWeight600
                        .onFontSize(resource.fontSize.dp16)
                        .onColor(resource.color.colorWhite),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(resource.dimen.dp20),
                        padding: EdgeInsets.all(resource.dimen.dp20),
                        decoration:
                            BackgroundBoxDecoration(
                              boxColor: resource.color.colorWhite,
                              radious: 10,
                            ).roundedCornerBox,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  'Login:',
                                  style: context.textFontWeight600
                                      .onColor(resource.color.viewBgColor)
                                      .onFontSize(resource.fontSize.dp16),
                                ),
                              ),
                              SizedBox(height: resource.dimen.dp20),
                              RightIconTextWidget(
                                labelText: "Email/User Nmae",
                                hintText: "Email/User Nmae",
                                errorMessage: "please enter Email/User Nmae",
                                textController: _emailTextController,
                              ),
                              SizedBox(height: resource.dimen.dp20),
                              RightIconTextWidget(
                                labelText: "Password",
                                hintText: "Password",
                                errorMessage: "please enter password",
                                textController: _passwordTextController,
                              ),
                              SizedBox(height: resource.dimen.dp30),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    _userBloc.validateUser({
                                      'email': _emailTextController.text,
                                      'password': _passwordTextController.text,
                                    }, emitResponse: true);
                                  }
                                },
                                child: ActionButtonWidget(
                                  text: 'Login',
                                  padding: EdgeInsets.symmetric(
                                    horizontal: resource.dimen.dp25,
                                    vertical: resource.dimen.dp7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: resource.dimen.dp30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
