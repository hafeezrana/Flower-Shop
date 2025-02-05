import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flowershop/utils/toast.dart';
import 'package:location/location.dart';

class MapService {
  double? distance;
  bool isLoading = false;

  final Location _location = Location();

  Future<LocationData?> getCurrentLocation() async {
    try {
      isLoading = true;
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          ShowToast.msg('Location services are disabled.');
        }
      }

      // Check location permissions
      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          ShowToast.msg('Location permissions are denied.');
        }
      }

      // Get current location
      final LocationData locationData = await _location.getLocation();
      log('Current Location: Lat=${locationData.latitude}, Lng=${locationData.longitude}');
      return locationData;
    } catch (e) {
      log('Error getting location: $e');
      return null;
    } finally {
      isLoading = false;
    }
  }

  Future<double?> calculateDistanceWithPrice(
      {required LatLng centerPoint,
      required LatLng currentLocation,
      required double pricePerKM}) async {
    try {
      distance = Geolocator.distanceBetween(
        centerPoint.latitude,
        centerPoint.longitude,
        currentLocation.latitude,
        currentLocation.longitude,
      );

      if (distance != null) {
        final distanceInKm = distance! / 1000;
        String calculatedDistance = distanceInKm.toString().substring(0, 6);
        final deliveryPrice = double.parse(calculatedDistance) * pricePerKM;
        log('distance: $calculatedDistance, dePrice: $deliveryPrice');

        return deliveryPrice;
      } else {
        ShowToast.msg('Something went wrong. Please try again');
      }
    } catch (e) {
      log('error submit: ${e.toString()}');
      ShowToast.msg(e.toString());
    }
    return null;
  }
}

final locationProvider = StateProvider<MapService>((ref) {
  return MapService();
});

class UserLocationData {
  double? lat;
  double? lng;
  String? address;
  String? locality;
  UserLocationData({this.lat, this.lng, this.address, this.locality});
}
