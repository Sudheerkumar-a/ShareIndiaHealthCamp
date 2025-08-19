import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/field_entity_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/remote/api_urls.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/domain/entities/user_credentials_entity.dart';
import 'package:shareindia_health_camp/injection_container.dart';
import 'package:shareindia_health_camp/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia_health_camp/presentation/utils/dialogs.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';

class AddFieldAgentScreen extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: AddFieldAgentScreen(),
      ),
    );
  }

  final _userBloc = sl<UserBloc>();
  final _formKey = GlobalKey<FormState>();
  final formFields = List<FormEntity>.empty(growable: true);
  final Map fieldsData = {};
  AddFieldAgentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final resource = context.resources;
    if (formFields.isEmpty) {
      fieldsData['dist_id'] =
          districts
              .where(
                (e) =>
                    e['name']?.toLowerCase() ==
                        UserCredentialsEntity.details(
                          context,
                        ).user?.district?.toLowerCase() ||
                    e['id']?.toLowerCase() ==
                        UserCredentialsEntity.details(
                          context,
                        ).user?.district?.toLowerCase(),
              )
              .firstOrNull?['id'];
      formFields.addAll([
        FormEntity()
          ..name = 'mandal'
          ..labelEn = 'Mandal'
          ..labelTe = 'Mandal'
          ..type = 'collection'
          ..url = mandalListApiUrl
          ..urlInputData = {'dist_id': fieldsData['dist_id']}
          ..validation = (FormValidationEntity()..isRequired = true)
          ..placeholderEn = 'Select Mandal'
          ..onDatachnage = (value) {
            fieldsData['mandal'] = value.id;
          },
        FormEntity()
          ..name = 'name'
          ..labelEn = 'Name'
          ..labelTe = 'Name'
          ..type = 'text'
          ..validation =
              (FormValidationEntity()
                ..isRequired = true
                ..regex = nameRegExp)
          ..messages =
              (FormMessageEntity()
                ..requiredEn = 'Please Enter Name'
                ..requiredTe = 'Please Enter Name'
                ..regexEn = 'Please Enter Valid Name'
                ..regexTe = 'Please Enter Valid Name')
          ..placeholderEn = 'Name'
          ..placeholderTe = 'Name'
          ..onDatachnage = (value) {
            fieldsData['name'] = value;
          },
        FormEntity()
          ..name = 'email_id'
          ..labelEn = 'Email Id'
          ..labelTe = 'Email Id'
          ..type = 'text'
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid Email Id'
                ..regexTe = 'Please Enter Valid Email Id')
          ..validation = (FormValidationEntity()..regex = emailRegExp)
          ..placeholderEn = 'Email Id'
          ..placeholderTe = 'Email Id'
          ..onDatachnage = (value) {
            fieldsData['email'] = value;
          },
        FormEntity()
          ..name = 'contact_number'
          ..labelEn = 'Mobile Number'
          ..labelTe = 'Mobile Number'
          ..type = 'number'
          ..messages =
              (FormMessageEntity()
                ..regexEn = 'Please Enter Valid Mobile Number'
                ..regexTe = 'Please Enter Valid Mobile Number')
          ..validation =
              (FormValidationEntity()
                ..maxLength = 10
                ..regex = numberRegExp)
          ..placeholderEn = 'Mobile Number'
          ..placeholderTe = 'Mobile Number'
          ..onDatachnage = (value) {
            fieldsData['contact_number'] = value;
          },
        FormEntity()
          ..name = 'password'
          ..labelEn = 'Password'
          ..labelTe = 'Password'
          ..type = 'text'
          ..messages = (FormMessageEntity()..regexEn = 'Please Enter Password')
          ..placeholderEn = 'Password'
          ..placeholderTe = 'Password'
          ..onDatachnage = (value) {
            fieldsData['password'] = value;
          },
        FormEntity()
          ..name = 'confirm_password'
          ..labelEn = 'Confirm Password'
          ..labelTe = 'Confirm Password'
          ..type = 'text'
          ..messages =
              (FormMessageEntity()..regexEn = 'Please Enter Confirm Password')
          ..placeholderEn = 'Confirm Password'
          ..placeholderTe = 'Confirm Password'
          ..onDatachnage = (value) {
            fieldsData['conform_password'] = value;
          },
      ]);
    }
    return SafeArea(
      bottom: true,
      child: Scaffold(
        body: BlocProvider(
          create: (context) => _userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is OnLoginLoading) {
                Dialogs.loader(context);
              } else if (state is OnApiResponse) {
                Dialogs.dismiss(context);
                Dialogs.showInfoDialog(
                  context,
                  PopupType.success,
                  "Agent Add Successfully",
                ).then((v) {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                });
              } else if (state is OnLoginApiError) {
                Dialogs.dismiss(context);
                Dialogs.showInfoDialog(
                  context,
                  PopupType.fail,
                  state.message,
                ).then((v) {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                });
              }
            },
            child: Container(
              color: resource.color.colorWhite,
              child: Column(
                children: [
                  MSearchUserAppBarWidget(
                    title: 'Integrated Health Services (IHS)',
                    showBack: true,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
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
                                      'Add New Field Agent',
                                      style: context.textFontWeight600
                                          .onColor(resource.color.viewBgColor)
                                          .onFontSize(resource.fontSize.dp16),
                                    ),
                                  ),
                                  SizedBox(height: resource.dimen.dp10),
                                  for (var item in formFields) ...[
                                    item.getWidget(context),
                                  ],
                                  SizedBox(height: resource.dimen.dp20),
                                  InkWell(
                                    onTap: () {
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        _userBloc.addNewAgent({
                                          'mandal': fieldsData['mandal'],
                                          'name': fieldsData['name'],
                                          'mobile':
                                              fieldsData['contact_number'],
                                          'distict_id': fieldsData['dist_id'],
                                          'email': fieldsData['email'],
                                          'password': fieldsData['password'],
                                        }, emitResponse: true);
                                      }
                                    },
                                    child: ActionButtonWidget(
                                      text: 'ADD',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
