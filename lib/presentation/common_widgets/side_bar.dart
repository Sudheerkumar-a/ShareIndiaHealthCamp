import 'package:flutter/material.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/image_widget.dart';
import 'package:shareindia_health_camp/res/drawables/drawable_assets.dart';

class SideBar extends StatelessWidget {
  final int seletedItem;
  final Function(int) onItemSelected;
  SideBar({required this.onItemSelected, this.seletedItem = 0, super.key});
  final ValueNotifier _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _selectedIndex.value = seletedItem;
    return Drawer(
      backgroundColor: resources.color.colorWhite,
      elevation: 1,
      child: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, index, child) {
          return ListView(
            children: <Widget>[
              SizedBox(height: resources.dimen.dp20),
              SizedBox(
                height: 50,
                child: InkWell(
                  onTap: () {
                    _selectedIndex.value = 0;
                    onItemSelected(0);
                  },
                  child:
                      ImageWidget(
                        path: DrawableAssets.icLogo,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ).loadImageWithMoreTapArea,
                ),
              ),
              SizedBox(height: resources.dimen.dp20),
              ListTile(
                onTap: () {
                  _selectedIndex.value = 0;
                  onItemSelected(0);
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
                                ? resources.color.sideBarItemSelected
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
              ListTile(
                onTap: () {
                  _selectedIndex.value = 1;
                  onItemSelected(1);
                },
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child:
                      ImageWidget(
                        path: DrawableAssets.icReport,
                        backgroundTint:
                            index == 1
                                ? resources.color.sideBarItemSelected
                                : resources.color.sideBarItemUnselected,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ).loadImageWithMoreTapArea,
                ),
                title: Text(
                  resources.string.report,
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
                },
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child:
                      ImageWidget(
                        path: DrawableAssets.icUser,
                        backgroundTint:
                            index == 2
                                ? resources.color.sideBarItemSelected
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
