import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/constants/constants.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/user_credentials_entity.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';
import 'package:shareindia_health_camp/res/drawables/background_box_decoration.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class SideBar extends StatelessWidget {
  final int seletedItem;
  final Function(int) onItemSelected;
  SideBar({required this.onItemSelected, this.seletedItem = 0, super.key});
  final ValueNotifier _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _selectedIndex.value = selectedSideBarIndex;
    return Drawer(
      backgroundColor: resources.color.colorWhite,
      elevation: 1,
      child: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, index, child) {
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration:
                    BackgroundBoxDecoration(
                      gradientStartColor: resources.color.viewBgColor,
                      gradientEndColor: resources.color.iconTintColor,
                    ).gradientColorBg,
                child: InkWell(
                  onTap: () {
                    _selectedIndex.value = 0;
                    onItemSelected(0);
                    Scaffold.of(context).closeDrawer();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: UserCredentialsEntity.details(context).user?.name,
                      style: context.textFontWeight600.onColor(
                        resources.color.colorWhite,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '\n${UserCredentialsEntity.details(context).user?.email}',
                          style: context.textFontWeight600.onColor(
                            resources.color.colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: resources.dimen.dp20),

              if (UserCredentialsEntity.details(context).user?.isAdmin !=
                  2) ...[
                ListTile(
                  onTap: () {
                    _selectedIndex.value = 0;
                    onItemSelected(0);
                    Scaffold.of(context).closeDrawer();
                  },
                  selected: true,
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child:
                        ImageWidget(
                          path: DrawableAssets.icHome,
                          backgroundTint:
                              index == 0
                                  ? resources.color.viewBgColorLight
                                  : resources.color.sideBarItemUnselected,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                        ).loadImageWithMoreTapArea,
                  ),
                  title: Text(
                    resources.string.home,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight600.onFontSize(
                      resources.fontSize.dp12,
                    ),
                  ),
                ),
                SizedBox(height: resources.dimen.dp10),
              ],
              ListTile(
                onTap: () {
                  _selectedIndex.value = 1;
                  onItemSelected(1);
                  Scaffold.of(context).closeDrawer();
                },
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child:
                      ImageWidget(
                        path: DrawableAssets.icScreening,
                        backgroundTint:
                            index == 1
                                ? resources.color.viewBgColorLight
                                : resources.color.sideBarItemUnselected,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ).loadImageWithMoreTapArea,
                ),
                title: Text(
                  resources.string.screening,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textFontWeight600.onFontSize(
                    resources.fontSize.dp12,
                  ),
                ),
              ),
              SizedBox(height: resources.dimen.dp10),
              ListTile(
                onTap: () {
                  _selectedIndex.value = 2;
                  onItemSelected(2);
                  Scaffold.of(context).closeDrawer();
                },
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child:
                      ImageWidget(
                        path: DrawableAssets.icUser,
                        backgroundTint:
                            index == 2
                                ? resources.color.viewBgColorLight
                                : resources.color.sideBarItemUnselected,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ).loadImageWithMoreTapArea,
                ),
                title: Text(
                  resources.string.profile,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textFontWeight600.onFontSize(
                    resources.fontSize.dp12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  selectItem(int index) {
    _selectedIndex.value = index;
    onItemSelected(3);
  }
}
