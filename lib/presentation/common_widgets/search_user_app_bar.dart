import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/enum/enum.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/local/user_data_db.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class SearchUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final EdgeInsets? padding;
  final Function(AppBarItem)? onItemTap;
  SearchUserAppBarWidget({
    required this.userName,
    this.padding,
    this.onItemTap,
    super.key,
  });
  final ValueNotifier _isAvailable = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _isAvailable.value = context.userDataDB.get(
      UserDataDB.userOnvaction,
      defaultValue: false,
    );
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  onItemTap?.call(AppBarItem.user);
                },
                child: Tooltip(
                  message: resources.string.userProfile,
                  child:
                      ImageWidget(
                        path: DrawableAssets.icUserCircle,
                        width: 20,
                        height: 20,
                        backgroundTint: resources.color.viewBgColorLight,
                        padding: EdgeInsets.all(resources.dimen.dp10),
                      ).loadImageWithMoreTapArea,
                ),
              ),
              Text(
                "User Name",
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp12)
                    .onColor(resources.color.colorBlack),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
