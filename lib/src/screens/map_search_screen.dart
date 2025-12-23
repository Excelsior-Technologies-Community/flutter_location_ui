import 'package:flutter/material.dart';
import 'package:flutter_location_ui/src/services/osm_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final OsmService osmService = OsmService();
  final TextEditingController searchController = TextEditingController();

  GoogleMapController? mapController;

  LatLng currentLatLng = const LatLng(23.0225, 72.5714); // Ahmedabad default
  String address = "Move map to select location";

  bool loading = false;
  List<dynamic> suggestions = [];

  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setMarker(currentLatLng);
    _updateAddress(currentLatLng);
  }

  void _setMarker(LatLng pos) {
    markers.clear();
    markers.add(Marker(markerId: const MarkerId("selected"), position: pos));
    setState(() {});
  }

  Future<void> _updateAddress(LatLng pos) async {
    setState(() => loading = true);
    address = await osmService.reverseGeocode(pos);
    setState(() => loading = false);
  }

  Future<void> _onSearch(String value) async {
    if (value.length < 3) {
      suggestions.clear();
      setState(() {});
      return;
    }

    suggestions = await osmService.search(value);
    setState(() {});
  }

  Future<void> _onSelectPlace(Map item) async {
    final latLng = LatLng(
      double.parse(item['lat']),
      double.parse(item['lon']),
    );

    currentLatLng = latLng;

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 12, // ✅ District zoom
        ),
      ),
    );

    searchController.clear();
    suggestions.clear();

    _setMarker(latLng);
    address = item['display_name'];

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLatLng,
              zoom: 5, // ✅ India level zoom
            ),
            onMapCreated: (c) => mapController = c,

            onCameraMove: (position) {
              currentLatLng = position.target;
            },

            onCameraIdle: () {
              _setMarker(currentLatLng);
              _updateAddress(currentLatLng);
            },

            markers: markers,
            zoomControlsEnabled: false,
          ),


          // 🔎 Search bar
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Search location...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: _onSearch,
              ),
            ),
          ),

          // 📝 Suggestions list
          if (suggestions.isNotEmpty)
            Positioned(
              top: 60,
              left: 10,
              right: 10,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (_, index) {
                    final item = suggestions[index];
                    return ListTile(
                      title: Text(item['display_name']),
                      onTap: () => _onSelectPlace(item),
                    );
                  },
                ),
              ),
            ),

          // 📍 Selected location info
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: loading
                        ? const CircularProgressIndicator()
                        : Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "lat": currentLatLng.latitude,
                        "lng": currentLatLng.longitude,
                        "address": address,
                      });
                    },
                    child: const Text("Confirm"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
