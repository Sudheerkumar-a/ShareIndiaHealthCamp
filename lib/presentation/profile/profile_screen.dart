import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/domain/entities/user_credentials_entity.dart';
import 'package:shareindia_health_camp/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';

import '../../injection_container.dart';

class ProfileScreen extends BaseScreenWidget {
  ProfileScreen({super.key});
  final UserBloc _userBloc = sl<UserBloc>();
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final user = UserCredentialsEntity.details(context).user;
    final inputData = {};
    final formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => _userBloc,
      child: Padding(
        padding: EdgeInsets.all(resources.dimen.dp20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resources.string.userProfile,
                style: context.textFontWeight700.onFontSize(
                  resources.fontSize.dp14,
                ),
              ),
              SizedBox(height: resources.dimen.dp20),
              // FutureBuilder(
              //     future: _userBloc.getUserData({
              //       'userName': UserCredentialsEntity.details().username
              //     }),
              //     builder: (context, snapShot) {
              //       final userEntity = snapShot.data;
              //       return
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp15,
                  horizontal: resources.dimen.dp20,
                ),
                color: resources.color.colorWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: '${resources.string.fullName}\n',
                                    style: context.textFontWeight400.onFontSize(
                                      resources.fontSize.dp10,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: user?.name ?? '',
                                        style: context.textFontWeight600
                                            .onFontSize(
                                              resources.fontSize.dp12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: resources.dimen.dp15),
                                Text.rich(
                                  TextSpan(
                                    text: 'Role\n',
                                    style: context.textFontWeight400.onFontSize(
                                      resources.fontSize.dp10,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            UserCredentialsEntity.details(
                                                      context,
                                                    ).user?.isAdmin ==
                                                    1
                                                ? 'APSACS'
                                                : UserCredentialsEntity.details(
                                                      context,
                                                    ).user?.isAdmin ==
                                                    2
                                                ? 'Facility'
                                                : 'DISHA',
                                        style: context.textFontWeight600
                                            .onFontSize(
                                              resources.fontSize.dp12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Expanded(
                          //     flex: 1,
                          //     child: Container(
                          //       margin:
                          //           EdgeInsets.all(resources.dimen.dp5),
                          //       decoration: BackgroundBoxDecoration(
                          //         boxColor: resources
                          //             .color.sideBarItemUnselected,
                          //       ).circularBox,
                          //     ))
                        ],
                      ),
                    ),
                    SizedBox(height: resources.dimen.dp15),
                    Text(
                      "Email",
                      style: context.textFontWeight400.onFontSize(
                        resources.fontSize.dp10,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: context.textFontWeight600.onFontSize(
                        resources.fontSize.dp12,
                      ),
                    ),
                    SizedBox(height: resources.dimen.dp15),
                    Text(
                      'District',
                      style: context.textFontWeight400.onFontSize(
                        resources.fontSize.dp10,
                      ),
                    ),
                    Text(
                      districts
                              .where(
                                (e) =>
                                    ((e['id'] == user?.district) ||
                                        (e['name'] == user?.district)),
                              )
                              .firstOrNull?['name'] ??
                          '',
                      style: context.textFontWeight600.onFontSize(
                        resources.fontSize.dp12,
                      ),
                    ),
                    SizedBox(height: resources.dimen.dp15),
                    if ((user?.mandalId ?? 0) != 0) ...[
                      Text(
                        'Mandal',
                        style: context.textFontWeight400.onFontSize(
                          resources.fontSize.dp10,
                        ),
                      ),
                      Text(
                        mandals
                                .where((e) => e.id == user?.mandalId)
                                .firstOrNull
                                ?.name ??
                            '',
                        style: context.textFontWeight600.onFontSize(
                          resources.fontSize.dp12,
                        ),
                      ),
                      SizedBox(height: resources.dimen.dp15),
                    ],
                    Text(
                      'Password',
                      style: context.textFontWeight400.onFontSize(
                        resources.fontSize.dp10,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: '•••••••   ',
                        style: context.textFontWeight600.onFontSize(
                          resources.fontSize.dp12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Change Password',
                            style: context.textFontWeight600
                                .onFontSize(resources.fontSize.dp12)
                                .onColor(resources.color.viewBgColor)
                                .copyWith(decoration: TextDecoration.underline),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    if (true) {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: resources.dimen.dp20,
                                              bottom:
                                                  MediaQuery.of(
                                                    context,
                                                  ).viewInsets.bottom +
                                                  resources.dimen.dp10,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Form(
                                                key: formKey,
                                                child: Column(
                                                  children: [
                                                    (FormEntity()
                                                          ..type = 'text'
                                                          ..label = 'Password'
                                                          ..placeholder =
                                                              'Password'
                                                          ..validation =
                                                              (FormValidationEntity()
                                                                ..isRequired =
                                                                    true
                                                                ..minLength = 8)
                                                          ..messages =
                                                              (FormMessageEntity()
                                                                ..requiredText =
                                                                    'Please Enter Password'
                                                                ..minLength =
                                                                    'Password should be 8 chracters')
                                                          ..horizontalSpace = 20
                                                          ..onDatachnage = (
                                                            data,
                                                          ) {
                                                            inputData['password'] =
                                                                data;
                                                          })
                                                        .getWidget(context),
                                                    (FormEntity()
                                                          ..type = 'text'
                                                          ..label =
                                                              'Confirm Password'
                                                          ..placeholder =
                                                              'Confirm Password'
                                                          ..horizontalSpace = 20
                                                          ..onDatachnage = (
                                                            data,
                                                          ) {
                                                            inputData['confirm_password'] =
                                                                data;
                                                          })
                                                        .getWidget(context),
                                                    (FormEntity()
                                                          ..type = 'button'
                                                          ..label = 'Change'
                                                          ..inputFieldData = {
                                                            'alignment':
                                                                Alignment
                                                                    .topCenter,
                                                          }
                                                          ..horizontalSpace = 20
                                                          ..onDatachnage = (
                                                            data,
                                                          ) async {
                                                            if (formKey
                                                                    .currentState
                                                                    ?.validate() ==
                                                                true) {
                                                              if (inputData['confirm_password'] !=
                                                                  inputData['password']) {
                                                                Dialogs.showInfoDialog(
                                                                  context,
                                                                  PopupType
                                                                      .fail,
                                                                  'Confirm password not matched',
                                                                );
                                                                return;
                                                              }
                                                              Dialogs.loader(
                                                                context,
                                                              );
                                                              final response = await _userBloc
                                                                  .changePassword({
                                                                    'password':
                                                                        inputData['password'],
                                                                    'confirm_password':
                                                                        inputData['confirm_password'],
                                                                  });
                                                              if (!context
                                                                  .mounted) {
                                                                return;
                                                              }
                                                              Dialogs.dismiss(
                                                                context,
                                                              );
                                                              if (response
                                                                  is OnApiResponse) {
                                                                Dialogs.showInfoDialog(
                                                                  context,
                                                                  PopupType
                                                                      .success,
                                                                  'Password has been changed',
                                                                ).then((value) {
                                                                  if (context
                                                                      .mounted) {
                                                                    logout(
                                                                      context,
                                                                    );
                                                                  }
                                                                });
                                                              } else if (response
                                                                  is OnLoginApiError) {
                                                                Dialogs.showInfoDialog(
                                                                  context,
                                                                  PopupType
                                                                      .fail,
                                                                  response
                                                                      .message,
                                                                );
                                                              }
                                                            }
                                                          })
                                                        .getWidget(context),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      return;
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //})
            ],
          ),
        ),
      ),
    );
  }
}
