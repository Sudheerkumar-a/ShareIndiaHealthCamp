// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shareindia_health_camp/core/extensions/build_context_extension.dart';
import 'package:shareindia_health_camp/core/extensions/text_style_extension.dart';
import 'package:shareindia_health_camp/domain/entities/single_data_entity.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/goolge_places_text_widget.dart';
import 'package:shareindia_health_camp/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:shareindia_health_camp/presentation/utils/location.dart';

const LatLng defaultLocation = LatLng(25.5508, 55.5524);

class LocationWidget extends StatelessWidget {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final ValueNotifier<LatLng> _onMarkerCoordinates =
      ValueNotifier(defaultLocation);
  final double mapZoom = 12;
  final Map<String, dynamic> locationData;
  Map<String, dynamic> _locationData = const {};
  Function(dynamic) onDataChanged;
  final tecLatLang = TextEditingController();
  final tecAddress = TextEditingController();
  final tecMakaniNumber = TextEditingController();

  LocationWidget(
      {required this.locationData, required this.onDataChanged, super.key});
  _onMarkerDataChanged(LatLng latLang, {String? address}) async {
    final shortLatLong = LatLng(
        double.parse(latLang.latitude.toStringAsFixed(6)),
        double.parse(latLang.longitude.toStringAsFixed(6)));
    _locationData['latLang'] = shortLatLong;
    _locationData['coordinates'] =
        '${shortLatLong.latitude},${shortLatLong.longitude}';
    _locationData['address'] = address ?? '';
    tecLatLang.text = _locationData['coordinates'] ?? '';
    tecAddress.text = _locationData['address'] ?? '';
    tecMakaniNumber.text = _locationData['makaniNumber'] ?? '';
    _onMarkerCoordinates.value = shortLatLong;
    onDataChanged(_locationData);
    Future.delayed(const Duration(milliseconds: 200), () async {
      CameraPosition cameraPosition = CameraPosition(
        target: shortLatLong,
        zoom: mapZoom,
      );
      final GoogleMapController controller = await _controller.future;
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _locationData = Map.from(locationData['data']);
    final field = (locationData['field'] as FormEntity);
    _onMarkerCoordinates.value = _locationData['latLang'] ?? defaultLocation;
    if (_locationData['latLang'] == null) {
      Future.delayed(Duration.zero, () async {
        var isLocationOn = await Location.checkGps();
        if (isLocationOn) {
          Location.getLocation().then((value) async {
            final shortLatLong = LatLng(value.latitude, value.longitude);
            _onMarkerCoordinates.value = shortLatLong;
            Future.delayed(const Duration(milliseconds: 200), () async {
              CameraPosition cameraPosition = CameraPosition(
                target: shortLatLong,
                zoom: mapZoom,
              );
              final GoogleMapController controller = await _controller.future;
              await controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
            });
          });
        } else if (context.mounted) {}
      });
    }
    tecLatLang.text = _locationData['coordinates'] ?? '';
    tecAddress.text = _locationData['address'] ?? '';
    tecMakaniNumber.text = _locationData['makaniNumber'] ?? '';
    return ValueListenableBuilder(
        valueListenable: _onMarkerCoordinates,
        builder: (context, coordinates, child) {
          final CameraPosition kGooglePlex = CameraPosition(
            target: coordinates,
            zoom: mapZoom,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (field.getLabel.isNotEmpty) ...[
                Text(
                  field.getLabel,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp14),
                ),
                SizedBox(
                  height: context.resources.dimen.dp10,
                )
              ],
              SizedBox(
                height: 200,
                child: InkWell(
                  child: GoogleMap(
                    mapType: MapType.terrain,
                    myLocationEnabled: true,
                    initialCameraPosition: kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    gestureRecognizers: {
                      Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer())
                    },
                    onTap: (latLang) async {
                      _onMarkerDataChanged(latLang);
                    },
                    markers: {
                      Marker(
                          markerId: const MarkerId('MarkerId'),
                          position: coordinates)
                    },
                  ),
                ),
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              RightIconTextWidget(
                height: resources.dimen.dp27,
                textInputAction: TextInputAction.next,
                labelText: 'Latitude & Longitude',
                hintText: 'Latitude & Longitude',
                textController: tecLatLang,
                focusNode: FocusNode(canRequestFocus: false),
                isValid: (value) {
                  if (value.isEmpty) {
                    return 'Enter valid Latitude & Longitude';
                  }
                  return null;
                },
                onChanged: (value) {
                  _locationData['coordinates'] = value;
                  onDataChanged(_locationData);
                },
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              GooglePlacesTextWidget(
                height: resources.dimen.dp27,
                textInputAction: TextInputAction.next,
                labelText: 'address',
                hintText: 'addressHint',
                textController: tecAddress,
                focusNode: FocusNode(canRequestFocus: false),
                isValid: (value) {
                  if (value.isEmpty) {
                    return 'valid address';
                  }
                  return null;
                },
                onLocationSelected: (location) {
                  _onMarkerDataChanged(location['latLong'],
                      address: location['place']);
                },
              ),
            ],
          );
        });
  }
}
