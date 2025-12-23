# LocationUi

A simple **Flutter Location Picker** using **OpenStreetMap (Nominatim API)** and **Google Maps**.  
Allows users to **search districts, cities, villages in India**, select location on map, and get **latitude, longitude, and address**. 

---
## Features
- Search Indian districts, cities, and villages  
- Auto-complete search suggestions  
- Move map to select location  
- Show marker on selected location  
- Reverse geocode to get address  
- Returns `lat`, `lng`, and `address` via callback  
---
## ✨ Preview
![screen-20251223-1152452](https://github.com/user-attachments/assets/ce927745-242e-43b6-a702-400714f89fc0)

---

## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter_location_ui:
    path: ../flutter_location_ui  # For local development
```
from git:
```
dependencies:
  flutter_location_ui:
    git:
      url: https://github.com/yourusername/flutter_location_ui.git  # Your github path
``` 
Then run:
```
flutter pub get
```
---
Add required dependencies in pubspec.yaml:
```
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.3.0
  http: ^1.1.0
  location: ^5.0.3
```
---

## 🗂 Project Structure
```
lib/
├─ main.dart
├─ osm_location_picker.dart          # ✅ Library file (OSM search + Google Map)
├─ screens/
│   └─ location_picker_screen.dart  # Optional, main screen for picker
└─ widgets/
    ├─ search_bar_widget.dart       # Optional search bar widget
    ├─ search_suggestion_list.dart  # Optional suggestion list widget
    └─ location_info_card.dart      # Optional bottom address card

```
---
## Parameters
* This library uses OpenStreetMap Nominatim API.
   * Free for personal / small projects.
   * Must include User-Agent and email in requests.
* Requires Google Maps API key to show the map.
* Make sure your API key is enabled for Android/iOS.
* Add permissions in AndroidManifest.xml for location.
 ---
## Notes
* This library uses OpenStreetMap Nominatim API.
   * Free for personal / small projects.
   * Must include User-Agent and email in requests.
* Requires Google Maps API key to show the map.
* Make sure your API key is enabled for Android/iOS.
* Add permissions in AndroidManifest.xml for location.

---

## Add To Permissions 
```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

```
---
## Usage
### Basic Example
```
import 'package:flutter/material.dart';
import 'osm_location_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OSM Location Picker Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(selectedAddress.isEmpty ? "No location selected" : selectedAddress),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPicker(
                      onLocationPicked: (loc) {
                        setState(() {
                          selectedAddress = "${loc['address']} \nLat:${loc['lat']} Lng:${loc['lng']}";
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              child: const Text("Pick Location"),
            )
          ],
        ),
      ),
    );
  }
}
```
---

## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
---
