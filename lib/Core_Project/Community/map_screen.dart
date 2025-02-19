import 'package:competitivecodingarena/Core_Project/Community/map_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geocode/geocode.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  LatLng? currentLocation;
  String? currentAddress;
  final MapController mapController = MapController();
  final tileProvider = CancellableNetworkTileProvider();
  final GeoCode geoCode = GeoCode(apiKey: '355349127400001694721x61807');
  double _currentZoom = 15.0;
  final String _thunderforestApiKey = '685265794bee48c1a91192c232fb2d2a';
  final String _currentLayer = 'standard';
  double _radiusInMeters = 500.0;
  bool _showRadiusControl = false;
  final bool _showRadius = true;
  late AnimationController _animationController;
  Animation<double>? _zoomAnimation;
  Animation<double>? _latAnimation;
  Animation<double>? _lngAnimation;
  final Duration _animationDuration = const Duration(milliseconds: 500);
  final Curve _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    tileProvider.dispose();
    super.dispose();
  }

  Future<void> getAddressFromCoordinates(LatLng position) async {
    try {
      Address address = await geoCode.reverseGeocoding(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        currentAddress = [
          address.streetAddress,
          address.city,
          address.region,
          address.postal,
          address.countryName,
          position.latitude.toString(),
          position.longitude.toString()
        ].where((element) => element != null).join(', ');
      });
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLocation = newLocation;
      });

      await getAddressFromCoordinates(newLocation);
      _animatedMove(currentLocation!, _currentZoom);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _animatedMove(LatLng target, double zoom) {
    final startLatLng = mapController.camera.center;

    _latAnimation =
        Tween<double>(begin: startLatLng.latitude, end: target.latitude)
            .animate(CurvedAnimation(
                parent: _animationController, curve: _animationCurve));

    _lngAnimation =
        Tween<double>(begin: startLatLng.longitude, end: target.longitude)
            .animate(CurvedAnimation(
                parent: _animationController, curve: _animationCurve));

    _zoomAnimation = Tween<double>(begin: _currentZoom, end: zoom).animate(
        CurvedAnimation(parent: _animationController, curve: _animationCurve));

    Animation<double> animation =
        CurvedAnimation(parent: _animationController, curve: _animationCurve);
    animation.addListener(() {
      mapController.move(LatLng(_latAnimation!.value, _lngAnimation!.value),
          _zoomAnimation!.value);
    });
    _animationController
        .forward(from: 0)
        .then((_) => setState(() => _currentZoom = zoom));
  }

  TileLayer get _tileLayer {
    final layer = mapLayers[_currentLayer]!;
    String url = layer.requiresApiKey
        ? layer.urlTemplate.replaceAll('{apikey}', _thunderforestApiKey)
        : layer.urlTemplate;
    return TileLayer(
        urlTemplate: url,
        userAgentPackageName: 'com.example.app',
        tileProvider: tileProvider,
        maxZoom: 19,
        keepBuffer: 5);
  }

  void _toggleRadiusControl() =>
      setState(() => _showRadiusControl = !_showRadiusControl);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                currentLocation ?? const LatLng(51.509364, -0.128928),
            initialZoom: _currentZoom,
          ),
          children: [
            _tileLayer,
            if (currentLocation != null) ...[
              if (_showRadius)
                MapRadiusOverlay(
                    radius: _radiusInMeters, location: currentLocation!),
              MapMarker(
                  location: currentLocation!, onTap: _toggleRadiusControl),
            ],
            MapAttribution(),
          ],
        ),
        if (_showRadiusControl)
          Positioned(
            bottom: 0,
            child: RadiusControl(
                minRadius: 100,
                maxRadius: 5000,
                radius: _radiusInMeters,
                onChanged: (value) => setState(() => _radiusInMeters = value)),
          ),
        MapControls(
            onZoomIn: () =>
                _animatedMove(mapController.camera.center, _currentZoom + 1),
            onZoomOut: () =>
                _animatedMove(mapController.camera.center, _currentZoom - 1),
            onLocate: getCurrentLocation),
        if (currentAddress != null)
          Positioned(
            top: 16,
            left: 30,
            right: 30,
            child: Container(
              constraints:
                  BoxConstraints(minWidth: 0, maxWidth: double.infinity),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                currentAddress!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
