import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  static const String apiKey = "YOUR_REAL_API_KEY";

  Future<List<dynamic>> autocomplete(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&key=$apiKey'
        '&language=en'
        '&components=country:in';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    print("AUTOCOMPLETE RESPONSE 👉 $data");

    if (data['status'] == 'OK') {
      return data['predictions'];
    } else {
      print("❌ AUTOCOMPLETE ERROR: ${data['status']}");
      return [];
    }
  }

  Future<LatLng> getLatLngFromPlaceId(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=geometry'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    print("DETAILS RESPONSE 👉 $data");

    final loc = data['result']['geometry']['location'];
    return LatLng(loc['lat'], loc['lng']);
  }

  Future<String> reverseGeocode(LatLng pos) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${pos.latitude},${pos.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['results'].isNotEmpty) {
      return data['results'][0]['formatted_address'];
    }
    return "Unknown location";
  }
}
