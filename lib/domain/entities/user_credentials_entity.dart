import 'package:flutter/widgets.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/constants/data_constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/data/local/user_data_db.dart';
import 'package:shareindia_health_camp/data/model/login_model.dart';
import 'package:shareindia_health_camp/data/model/single_data_model.dart';
import 'package:shareindia_health_camp/domain/entities/user_entity.dart';

class UserCredentialsEntity {
  static UserCredentialsEntity? userData;
  UserEntity? user;
  UserCredentialsEntity();
  factory UserCredentialsEntity.details(
    BuildContext context, {
    isDataChanged = false,
  }) {
    if ((userData?.user == null || isDataChanged) && userToken.isNotEmpty) {
      final userEntity =
          UserModel.fromJson(
            Map<String, dynamic>.from(context.userDataDB.get(UserDataDB.user)),
          ).toEntity();

      final district =
          districts
              .where(
                (e) =>
                    e['name']?.toLowerCase() ==
                        userEntity.district?.toLowerCase() ||
                    e['id']?.toLowerCase() ==
                        userEntity.district?.toLowerCase(),
              )
              .firstOrNull;
      if (district != null) {
        final selectedDistrict =
            NameIDModel.fromDistrictsJson(district).toEntity();
        userEntity.districtId = selectedDistrict.id;
      }
      userData = UserCredentialsEntity()..user = userEntity;
    }
    return userData ?? UserCredentialsEntity();
  }
}
