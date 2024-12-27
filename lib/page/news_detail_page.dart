import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news['title']),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            news['image_url'] != null
                ? Image.network(
                    news['image_url'],  // Pastikan key sesuai
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  )
                : const SizedBox.shrink(),  // Jika tidak ada gambar, jangan tampilkan apa-apa
            const SizedBox(height: 16),
            // Judul berita
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                news['title'],
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
            // Konten berita (Paragraf)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                news['content'] ?? 'No content available', // Menangani null content
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.justify, // Meratakan teks paragraf
              ),
            ),
          ],
        ),
      ),
    );
  }
}
