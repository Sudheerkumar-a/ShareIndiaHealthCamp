import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/common/common_utils.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class MSearchUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const MSearchUserAppBarWidget({required this.title,this.showBack=false, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BackgroundBoxDecoration().gradientColorBg,
      child: Row(
        children: [
          if(!showBack)
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          if(showBack)
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              title,
              style: context.textFontWeight600.onColor(
                resources.color.colorWhite,
              ),
            ),
          ),
          SizedBox(width: resources.dimen.dp10),
          InkWell(
            onTap: () {
              resources.setLocal(language: isSelectedLocalEn? 'te':'en');
            },
            child:
                ImageWidget(
                  path: DrawableAssets.icLangEn,
                  backgroundTint: Colors.white,
                  padding: EdgeInsets.all(resources.dimen.dp10),
                ).loadImageWithMoreTapArea,
          ),
          InkWell(
            onTap: () {
              logout(context);
            },
            child:
                ImageWidget(
                  path: DrawableAssets.icLogout,
                  backgroundTint: Colors.white,
                  padding: EdgeInsets.all(resources.dimen.dp10),
                ).loadImageWithMoreTapArea,
          ),
          Tooltip(
            message: resources.string.userProfile,
            child:
                ImageWidget(
                  path: DrawableAssets.icUserCircle,
                  width: 20,
                  height: 20,
                  backgroundTint: Colors.white,
                  padding: EdgeInsets.all(resources.dimen.dp10),
                ).loadImageWithMoreTapArea,
          ),
          // Text(userName,
          //     style: context.textFontWeight600
          //         .onFontSize(resources.fontSize.dp12)
          //         .onColor(resources.color.textColorLight))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
