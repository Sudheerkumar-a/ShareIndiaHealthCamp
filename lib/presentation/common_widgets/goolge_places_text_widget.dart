// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shareindia_health_camp/core/common/log.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/data/remote/dio_logging_interceptor.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/encryption_utils.dart';
import 'package:uuid/uuid.dart';

const double defaultHeight = 27;

class GooglePlacesTextWidget extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final int? maxLines;
  final int? maxLength;
  final int maxLengthValidation;
  final String fontFamily;
  final FocusNode? focusNode;
  final bool isMandetory;
  final BorderSide borderSide;
  final Color? fillColor;
  final Function(String)? onChanged;
  final Function? suffixIconClick;
  final Function(String)? isValid;
  final String? regex;
  final AutovalidateMode? autovalidateMode;
  final Function(dynamic)? onLocationSelected;
  String? _sessionToken;
  String? placesApiKey;
  Dio? dio;

  GooglePlacesTextWidget(
      {this.height = defaultHeight,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.textInputType,
      this.textInputAction,
      this.maxLines = 1,
      this.maxLength,
      this.maxLengthValidation = 0,
      this.fontFamily = '',
      this.focusNode,
      this.isMandetory = false,
      this.fillColor,
      this.borderSide = BorderSide.none,
      this.onChanged,
      this.suffixIconClick,
      this.regex,
      this.isValid,
      this.autovalidateMode,
      this.onLocationSelected,
      super.key});

  Future<List<GooglePlaceEntity>> _getPlaces(String input) async {
    _sessionToken ??= const Uuid().v4();

    if (dio == null) {
      dio = Dio();
      dio?.options.baseUrl = 'https://maps.googleapis.com/maps/api/place/';
      dio?.interceptors.add(DioLoggingInterceptor());
    }
    try {
      var response = await dio?.get(
        'autocomplete/json',
        queryParameters: {
          'input': input,
          'key': placesApiKey,
          'sessiontoken': _sessionToken,
          'components': 'country:AE'
        },
      );
      printLog(response?.data);
      final predictions = response?.data?['predictions'];
      return predictions != null
          ? (predictions as List).map((prediction) {
              final place = GooglePlaceEntity();
              place.placeName = prediction['description'];
              place.placeID = prediction['place_id'];
              return place;
            }).toList()
          : [];
    } on DioException catch (e) {
      printLog(e.toString());
    }
    return [];
  }

  Future<LatLng?> _getPlaceDetails(String placeId) async {
    try {
      var response = await dio?.get(
        'details/json',
        queryParameters: {
          'place_id': placeId,
          'key': placesApiKey,
          'sessiontoken': _sessionToken,
          'fields': 'geometry',
        },
      );
      printLog(response?.data);
      final location = response?.data?['result']?['geometry']?['location'];
      return location != null ? LatLng(location['lat'], location['lng']) : null;
    } on DioException catch (e) {
      printLog(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    placesApiKey =
        EncryptionUtils().decryptAES('');
    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<GooglePlaceEntity>(
        optionsBuilder: (TextEditingValue textEditingValue) async {
          List<GooglePlaceEntity> list = List.empty(growable: true);
          if (textEditingValue.text.length > 2 &&
              textEditingValue.text != textController?.text) {
            list = await _getPlaces(textEditingValue.text);
          }
          return list.where((GooglePlaceEntity option) {
            return option
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          Future.delayed(Duration.zero, () {
            textEditingController.text = textController?.text ?? '';
          });
          return RightIconTextWidget(
            isEnabled: true,
            height: resources.dimen.dp27,
            labelText: labelText,
            hintText: hintText,
            errorMessage: errorMessage,
            textController: textEditingController,
            focusNode: focusNode,
          );
        },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
            ),
            child: SizedBox(
              height: 52.0 * options.length,
              width: constraints.biggest.width,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final GooglePlaceEntity option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        option.toString(),
                        style: context.textFontWeight400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        onSelected: (GooglePlaceEntity place) async {
          final latLong = await _getPlaceDetails(place.placeID ?? '');
          if (latLong != null) {
            onLocationSelected
                ?.call({'place': place.placeName, 'latLong': latLong});
          }
        },
      );
    });
  }
}
