import 'package:flutter/material.dart';
import 'api_service.dart';
import 'news_detail_page.dart'; // Pastikan ini di-import

class BeritaPage extends StatefulWidget {
  final List<Map<String, dynamic>> newsList;

  const BeritaPage({super.key, required this.newsList});

  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  List<dynamic> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Panggil fetch data saat inisialisasi
  }

  Future<void> _fetchNews() async {
    try {
      final news = await ApiService.fetchNews(role: ''); // Anda bisa menambahkan role jika diperlukan
      setState(() {
        _newsList = news; // Update daftar berita
        _isLoading = false; // Selesai memuat
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Tetap selesai meskipun error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_newsList.isEmpty) {
      return const Center(child: Text('Tidak ada berita tersedia.'));
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final news = _newsList[index];
          return Column(
            children: [
              _buildNewsCard(
                context,
                imageUrl: news['image_url'] ?? '',
                title: news['title'] ?? 'Judul Tidak Tersedia',
                description: news['description'] ?? 'Deskripsi Tidak Tersedia',
                content: news['content'] ?? 'Konten Tidak Tersedia',
                date: news['date'] ?? 'Tanggal Tidak Tersedia',
                newsId: news['id'],  // Pass the news ID for CRUD operations
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNews(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String imageUrl,
    required String title,
    required String description,
    required String content,
    required String date,
    required int newsId,  // Add newsId here
  }) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman NewsDetailPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              news: {
                'title': title,
                'imageUrl': imageUrl,
                'description': description,
                'content': content,
                'date': date,
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
                    )
                  : Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Add edit and delete buttons here
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _editNews(
                    context,
                    title,
                    description,
                    content,
                    imageUrl,
                    newsId,
                  ),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deleteNews(context, newsId),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengedit berita
  void _editNews(
    BuildContext context,
    String currentTitle,
    String currentDescription,
    String currentContent,
    String currentImageUrl,
    int newsId,  // Gunakan int untuk ID berita
  ) {
    final TextEditingController titleController =
        TextEditingController(text: currentTitle);
    final TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    final TextEditingController contentController =
        TextEditingController(text: currentContent);
    final TextEditingController imageUrlController =
        TextEditingController(text: currentImageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Berita"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Berita',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Konten',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                final success = await ApiService.updateNews(
                  id: newsId,
                  title: titleController.text,
                  description: descriptionController.text,
                  content: contentController.text,
                  imageUrl: imageUrlController.text,
                );
                if (success) {
                  await _fetchNews(); // Refresh daftar berita
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui berita.')),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus berita
  void _deleteNews(BuildContext context, int newsId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Berita"),
          content: Text("Apakah Anda yakin ingin menghapus berita ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                final success = await ApiService.deleteNews(newsId);
                if (success) {
                  await _fetchNews(); // Refresh daftar berita
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus berita.')),
                  );
                }
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menambahkan berita
  void _addNews(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Berita"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Berita',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Konten',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                final success = await ApiService.addNews(
                  titleController.text,
                  descriptionController.text,
                  contentController.text,
                  imageUrlController.text,
                );
                if (success) {
                  await _fetchNews(); // Refresh daftar berita
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan berita.')),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
