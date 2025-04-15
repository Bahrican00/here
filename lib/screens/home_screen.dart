import 'dart:async'; // Completer için eklendi
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator eklendi
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Haritalar eklendi
import 'package:geocoding/geocoding.dart'; // Geocoding eklendi
import 'dart:math'; // Math.min için eklendi
import '../models/post_model.dart';
import '../models/match_request_model.dart';
import '../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<PostModel> _posts = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final String _currentUserId = 'sample_user_id'; // Örnek, gerçek kullanıcı ID'si eklenecek
  Position? _currentPosition;
  final Completer<GoogleMapController> _mapController = Completer(); // Harita kontrolcüsü
  Set<Marker> _markers = {}; // Harita işaretçileri

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetchPosts(); // Konum al ve gönderileri getir
  }

  // Konum iznini kontrol et ve konumu al
  Future<void> _determinePositionAndFetchPosts() async {
    print("--- Konum ve Gönderi Getirme Başladı (Basitleştirilmiş) ---"); // Log eklendi
    setState(() {
      _isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    try {
      print("Konum servisleri kontrol ediliyor...");
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      print("Konum servisleri etkin: $serviceEnabled");
      if (!serviceEnabled) {
        print("Hata: Konum servisleri kapalı.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konum servisleri kapalı.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      print("Konum izinleri kontrol ediliyor...");
      permission = await Geolocator.checkPermission();
      if (!mounted) return;
      print("Mevcut Konum İzni: $permission");
      if (permission == LocationPermission.denied) {
        print("Konum izni isteniyor...");
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
        print("İzin Sonrası Konum İzni: $permission");
        if (permission == LocationPermission.denied) {
          print("Hata: Konum izinleri reddedildi.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Konum izinleri reddedildi.')),
          );
           setState(() => _isLoading = false);
          return;
        }
      }

      if (!mounted) return;
      if (permission == LocationPermission.deniedForever) {
        print("Hata: Konum izinleri kalıcı olarak reddedildi.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konum izinleri kalıcı olarak reddedildi, izinleri uygulama ayarlarından açın.')),
        );
         setState(() => _isLoading = false);
        return;
      }

      print("Mevcut konum alınıyor...");
      _currentPosition = await Geolocator.getCurrentPosition()
          .timeout(Duration(seconds: 15));
      if (!mounted) return;
      print("Mevcut konum alındı: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}");

      print("Harita kontrolcüsü alınıyor...");
      final GoogleMapController controller = await _mapController.future;
      if (!mounted) return;
      print("Harita mevcut konuma taşınıyor...");
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        ),
      ));

      print("State güncelleniyor (isLoading = false) - Basitleştirilmiş..."); // Log eklendi
      setState(() {
        _isLoading = false;
      });

      print("--- Konum ve Gönderi Getirme Bitti (Basitleştirilmiş/Başarılı) ---"); // Log eklendi

    } catch (e) {
      print("Hata (_determinePositionAndFetchPosts içinde): $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum alınamadı veya bir hata oluştu: ${e.toString().substring(0, min(e.toString().length, 30))}...')),
      );
      setState(() => _isLoading = false);
      print("--- Konum ve Gönderi Getirme Bitti (Basitleştirilmiş/Hata) ---"); // Log eklendi
    }
  }

  // Koordinatlara göre gönderileri getir
  Future<void> _fetchPostsByCoordinates(double latitude, double longitude) async {
    print("--- Gönderi Getirme Başladı (Koordinat: $latitude, $longitude) ---"); // Log eklendi
    try {
      print("API'den gönderiler alınıyor (SampleLocation)... "); // Log eklendi
      final posts = await _apiService.getPostsByLocation("SampleLocation"); // Geçici
      if (!mounted) return;
      print("API'den ${posts.length} gönderi alındı."); // Log eklendi

      Set<Marker> newMarkers = {};
      List<PostModel> postsWithValidLocation = [];

      print("Gönderiler için Geocoding başlatılıyor..."); // Log eklendi
      await Future.wait(posts.map((post) async {
         print("  Geocoding: ${post.location}"); // Log eklendi
          try {
            List<Location> locations = await locationFromAddress(post.location);
             print("    ${post.location} -> ${locations.isNotEmpty ? locations.first.latitude.toString() + ','+ locations.first.longitude.toString() : 'Bulunamadı'}"); // Log eklendi
            if (locations.isNotEmpty) {
             final loc = locations.first;
             newMarkers.add(Marker(
                markerId: MarkerId(post.id),
                position: LatLng(loc.latitude, loc.longitude),
                infoWindow: InfoWindow(
                  title: post.location,
                  snippet: 'Detayları görmek için tıkla',
                   onTap: () {
                    _showPostDetails(post);
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ));
              postsWithValidLocation.add(post);
            } else {
              print("  Uyarı: Adres koordinatlara çevrilemedi: ${post.location}");
            }
          } catch (e) {
             print("  Hata: Adres geocode edilirken hata (${post.location}): $e"); // Log eklendi
          }
      }));
      print("Geocoding tamamlandı. ${newMarkers.length} işaretçi oluşturuldu."); // Log eklendi
       if (!mounted) return;

      print("State güncelleniyor (isLoading = false)..."); // Log eklendi
      setState(() {
        _posts = postsWithValidLocation;
        _markers = newMarkers;
        _isLoading = false;
      });
      print("--- Gönderi Getirme Bitti (Başarılı) ---"); // Log eklendi
    } catch (e) {
      print("Hata (_fetchPostsByCoordinates içinde): $e"); // Detaylı hata logu
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paylaşımlar yüklenemedi: ${e.toString().substring(0, 30)}...')),
      );
      print("--- Gönderi Getirme Bitti (Hata) ---"); // Log eklendi
    }
  }

  // Örnek: Gönderi detaylarını göstermek için bir fonksiyon
  void _showPostDetails(PostModel post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SpinKitCircle(color: Colors.blue, size: 30),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(height: 10),
                Text(post.location, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // title yerine location kullan
                SizedBox(height: 5),
                // Text('Konum: ${post.location}'), // Zaten başlıkta gösteriliyor, kaldırılabilir veya farklı bilgi eklenebilir
                // Örneğin Kullanıcı ID'si gösterilebilir:
                Text('Paylaşan: ${post.userId}'),
                 SizedBox(height: 10),
                ElevatedButton.icon(
                   icon: Icon(Icons.favorite_border),
                   label: Text('Eşleşme İsteği Gönder'),
                   onPressed: () {
                     Navigator.pop(context); // Bottom sheet'i kapat
                     _sendMatchRequest(post.userId);
                   },
                 )
             ],
          ),
        );
      },
    );
  }

  Future<void> _sendMatchRequest(String receiverId) async {
    try {
      final request = MatchRequestModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverId: receiverId,
        message: '',
        createdAt: DateTime.now(),
      );
      await _apiService.sendMatchRequest(request);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eşleşme isteği gönderildi!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eşleşme isteği gönderilemedi: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Diğer sekmelere geçiş
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/store');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/photo');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/likes');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: DrawerMenu(),
      body: Stack( // Harita ve yükleme ikonunu üst üste koymak için Stack kullanıldı
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : LatLng(41.0082, 28.9784), // Başlangıçta İstanbul (veya başka bir yer)
              zoom: _currentPosition != null ? 14.0 : 10.0,
            ),
            onMapCreated: (GoogleMapController controller) {
               print("!!! GoogleMap -> onMapCreated çağrıldı !!!"); 
               if (!_mapController.isCompleted) {
                 print("Map controller tamamlanıyor...");
                 _mapController.complete(controller);
                 print("Map controller tamamlandı.");
               } else {
                  print("Map controller zaten tamamlanmış.");
               }
            },
            markers: Set(), // İşaretçiler boş olarak ayarlandı
            myLocationEnabled: true, // Kullanıcının mavi noktasını göster
            myLocationButtonEnabled: true, // Konumuma git butonunu göster
          ),
          // Yükleme ikonu, _isLoading true ise haritanın üzerinde görünecek
          if (_isLoading)
            Center(
              child: SpinKitCircle(color: Colors.blue),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}