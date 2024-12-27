import 'package:flutter/material.dart';
import 'package:news_app/main.dart';
import 'package:news_app/page/api_service.dart';
import 'kategori_page.dart';
import 'profile_page.dart';
import 'berita_page.dart';

class AdminHomePage extends StatefulWidget {
  final String name;

  const AdminHomePage({super.key, required this.name});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _newsList = [];
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BeritaPage(newsList: _newsList), // Inisialisasi dengan list kosong
      const KategoriPage(),
      const ProfilePage(),
    ];
    _fetchNews(); // Ambil berita saat halaman diinisialisasi
  }

  // Mengubah tampilan halaman berdasarkan index yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Mendapatkan berita terbaru dari API
  Future<void> _fetchNews() async {
    try {
      setState(() {
        _newsList = []; // Menampilkan loading indicator
      });
      final news = await ApiService.fetchNews(); // Panggil fetchNews dari ApiService
      setState(() {
        _newsList = news; // Memperbarui daftar berita
      });
    } catch (e) {
      print('Error saat memuat berita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat berita. Coba lagi nanti.')),
      );
    }
  }

  // Fungsi untuk refresh halaman berita
  Future<void> _refreshPage() async {
    await _fetchNews(); // Panggil fungsi untuk mendapatkan berita terbaru
  }

  @override
  Widget build(BuildContext context) {
    if (_newsList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.withOpacity(0.8),
        actions: _buildAppBarActions(context),
        elevation: 5.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Mengubah title di AppBar berdasarkan halaman yang dipilih
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Berita Terkini';
      case 1:
        return 'Kategori';
      case 2:
        return 'Profil Pengguna';
      default:
        return 'Admin';
    }
  }

  // Menggunakan fungsi untuk membuat aksi-aksi di AppBar
  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () async {
          await _refreshPage(); // Pastikan fungsi refresh dipanggil di sini
        },
      ),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => _searchNews(context),
      ),
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () => _showNotifications(context),
      ),
    ];
  }

  // Menggunakan Drawer untuk navigasi
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin 1',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Home',
            color: Colors.blueAccent,
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category,
            text: 'Categories',
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/KategoriPage');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: 'Settings',
            color: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.redAccent,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat item dalam Drawer
  ListTile _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required Color color,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }

  // Membuat Bottom Navigation Bar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Berita',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      showUnselectedLabels: true,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
    );
  }

  // Menambahkan Floating Action Button hanya di Berita
  FloatingActionButton? _buildFloatingActionButton() {
    return _selectedIndex == 0
        ? FloatingActionButton(
            onPressed: () => _addNews(context),
            child: const Icon(Icons.add),
            backgroundColor: Colors.blue,
          )
        : null;
  }

  // Fungsi untuk menambah berita
  void _addNews(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Berita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(controller: titleController, labelText: 'Judul Berita'),
            _buildTextField(controller: descriptionController, labelText: 'Deskripsi'),
            _buildTextField(controller: imageUrlController, labelText: 'URL Gambar'),
          ],
        ),
        actions: _buildDialogActions(
          context,
          onSave: () async {
            final success = await ApiService.addNews(
              titleController.text,
              descriptionController.text,
              imageUrlController.text,
            );
            if (success) {
              await _fetchNews(); // Refresh daftar berita
              Navigator.of(context).pop();
            } else {
              print('Gagal menambahkan berita');
            }
          },
        ),
      ),
    );
  }

  // Fungsi untuk membuat TextField
  TextField _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  // Aksi untuk dialog simpan dan batal
  List<Widget> _buildDialogActions(BuildContext context, {required VoidCallback onSave}) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Batal'),
      ),
      TextButton(
        onPressed: onSave,
        child: const Text('Simpan'),
      ),
    ];
  }

  // Fungsi pencarian berita
  void _searchNews(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search News'),
        content: const Text('Masukkan kata kunci berita yang ingin dicari.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk notifikasi
  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('Tidak ada notifikasi berita baru.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}


