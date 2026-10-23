
import 'package:flutter/material.dart';

void main() {
  runApp(const AeroGuideApp());
}

// WARNA APLIKASI
const Color navy = Color(0xFF102A43);
const Color aviationBlue = Color(0xFF2878B5);
const Color lightBlue = Color(0xFFDCEBFA);
const Color backgroundColor = Color(0xFFF5F8FC);

// MODEL DATA PESAWAT
class Aircraft {
  final String name;
  final String manufacturer;
  final String capacity;
  final String speed;
  final String range;
  final IconData icon;

  const Aircraft({
    required this.name,
    required this.manufacturer,
    required this.capacity,
    required this.speed,
    required this.range,
    required this.icon,
  });
}

// DATA KATALOG PESAWAT
const List<Aircraft> aircraftList = [
  Aircraft(
    name: 'Airbus A320',
    manufacturer: 'Airbus',
    capacity: '150–180 penumpang',
    speed: '828 km/jam',
    range: '6.300 km',
    icon: Icons.flight,
  ),
  Aircraft(
    name: 'Boeing 737-800',
    manufacturer: 'Boeing',
    capacity: '162–189 penumpang',
    speed: '842 km/jam',
    range: '5.765 km',
    icon: Icons.flight,
  ),
  Aircraft(
    name: 'Airbus A350-900',
    manufacturer: 'Airbus',
    capacity: '300–440 penumpang',
    speed: '903 km/jam',
    range: '15.000 km',
    icon: Icons.flight,
  ),
];

// APLIKASI UTAMA
class AeroGuideApp extends StatelessWidget {
  const AeroGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroGuide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: aviationBlue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// HALAMAN BERANDA DAN KATALOG
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedCategory = 'Semua';
  int selectedPage = 0;

  List<Aircraft> get filteredAircraft {
    return aircraftList.where((aircraft) {
      final matchesSearch = aircraft.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesCategory = selectedCategory == 'Semua' ||
          aircraft.manufacturer == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.flight_takeoff, size: 29),
            SizedBox(width: 10),
            Text(
              'AeroGuide',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cari pesawat',
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                selectedPage = 1;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: selectedPage == 0
            ? buildHome()
            : selectedPage == 1
                ? buildCatalog()
                : buildSimplePage(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage,
        onDestinationSelected: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.airplanemode_active),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // HALAMAN BERANDA
  Widget buildHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [navy, aviationBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.flight_takeoff,
                size: 55,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Jelajahi Dunia Penerbangan',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Temukan informasi pesawat komersial '
                'dari berbagai produsen dunia.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Katalog Pesawat',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        const SizedBox(height: 5),
        const Text('Kenali pesawat komersial populer.'),
        const SizedBox(height: 12),
        ...aircraftList.map(
          (aircraft) => AircraftCard(
            aircraft: aircraft,
            onTap: () => showAircraftDetail(context, aircraft),
          ),
        ),
      ],
    );
  }

  // HALAMAN KATALOG DENGAN PENCARIAN
  Widget buildCatalog() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Cari Pesawat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Masukkan nama pesawat...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          children: ['Semua', 'Airbus', 'Boeing'].map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (_) {
                setState(() {
                  selectedCategory = category;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (filteredAircraft.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Pesawat tidak ditemukan.'),
          )
        else
          ...filteredAircraft.map(
            (aircraft) => AircraftCard(
              aircraft: aircraft,
              onTap: () => showAircraftDetail(context, aircraft),
            ),
          ),
      ],
    );
  }

  // HALAMAN FAVORIT DAN PROFIL SEMENTARA
  Widget buildSimplePage() {
    final isFavoritePage = selectedPage == 2;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFavoritePage ? Icons.favorite : Icons.person,
              size: 65,
              color: aviationBlue,
            ),
            const SizedBox(height: 16),
            Text(
              isFavoritePage ? 'Pesawat Favorit' : 'Profil Pengguna',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFavoritePage
                  ? 'Fitur favorit dapat dikembangkan selanjutnya.'
                  : 'Selamat datang di aplikasi AeroGuide.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedPage = 0;
                });
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}

// KARTU INFORMASI PESAWAT
class AircraftCard extends StatelessWidget {
  final Aircraft aircraft;
  final VoidCallback onTap;

  const AircraftCard({
    super.key,
    required this.aircraft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 80,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.flight,
                size: 42,
                color: aviationBlue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aircraft.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    aircraft.manufacturer,
                    style: const TextStyle(color: aviationBlue),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    aircraft.capacity,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Kecepatan: ${aircraft.speed}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: aviationBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                      child: const Text('Lihat Detail'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DETAIL PESAWAT
void showAircraftDetail(
  BuildContext context,
  Aircraft aircraft,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: backgroundColor,
    builder: (context) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Icon(
                  Icons.flight,
                  size: 90,
                  color: aviationBlue,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                aircraft.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              Text(
                'Produsen: ${aircraft.manufacturer}',
                style: const TextStyle(
                  fontSize: 16,
                  color: aviationBlue,
                ),
              ),
              const Divider(height: 30),
              DetailRow(
                icon: Icons.people,
                title: 'Kapasitas penumpang',
                value: aircraft.capacity,
              ),
              DetailRow(
                icon: Icons.speed,
                title: 'Kecepatan jelajah',
                value: aircraft.speed,
              ),
              DetailRow(
                icon: Icons.public,
                title: 'Jarak tempuh',
                value: aircraft.range,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup Detail'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// BARIS INFORMASI DETAIL
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(icon, color: aviationBlue, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
