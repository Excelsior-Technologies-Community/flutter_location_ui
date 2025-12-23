import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class OsmService {

  /// 🔍 SEARCH – ALL INDIA (district, state, village)
  Future<List<dynamic>> search(String query) async {
    final encodedQuery = Uri.encodeComponent(query);

    final url =
        'https://nominatim.openstreetmap.org/search'
        '?q=$encodedQuery'
        '&format=json'
        '&addressdetails=1'
        '&countrycodes=IN'   // ✅ VERY IMPORTANT
        '&limit=10';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "flutter-location-picker-app/1.0 (your@email.com)"
      },
    );

    if (response.statusCode != 200) {
      return [];
    }

    final body = response.body.trim();

    // 🚨 HTML response safety
    if (!body.startsWith('[')) return [];

    return json.decode(body);
  }

  /// 📍 REVERSE GEOCODE
  Future<String> reverseGeocode(LatLng pos) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${pos.latitude}'
        '&lon=${pos.longitude}'
        '&format=json';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "flutter-location-picker-app/1.0 (your@email.com)"
      },
    );

    if (response.statusCode != 200) {
      return "Unknown location";
    }

    final body = response.body.trim();
    if (!body.startsWith('{')) return "Unknown location";

    final data = json.decode(body);
    return data['display_name'] ?? "Unknown location";
  }
}
