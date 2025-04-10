import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(41.015137, 28.979530); // İstanbul

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("Konum izni verildi.");
    } else {
      print("Konum izni reddedildi.");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars), // Menü ikonu
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menü tıklandı!')),
            );
          },
        ),
        title: const Text('Here'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.solidMessage), // Mesaj ikonu
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mesajlar açıldı!')),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house), // Ana Sayfa ikonu
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.store), // Mağaza ikonu
            label: 'Mağaza',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.camera, size: 40), // FotoBIOS ikonu
            label: 'Fotoğraf',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart), // Beğeniler ikonu
            label: 'Beğeniler',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser), // Profil ikonu
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}