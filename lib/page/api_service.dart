import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Ganti dengan URL API Laravel Anda

  // Mendapatkan semua berita berdasarkan role
  static Future<List<Map<String, dynamic>>> fetchNews({required String role}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/news?role=$role'), // Menambahkan query parameter role
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data']; // Sesuaikan dengan struktur respons Laravel
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Gagal memuat data berita: ${response.body}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil berita: $e');
    }
  }

  // Mendapatkan detail berita
  static Future<Map<String, dynamic>?> getNewsDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/news/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Gagal mendapatkan detail berita: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error mendapatkan detail berita: $e');
      return null;
    }
  }

  // Menambahkan berita
  static Future<bool> addNews(String title, String description, String content, String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/news'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'title': title,
          'description': description,
          'content': content, // Tambahkan content
          'image_url': imageUrl,
        }),
      );
      if (response.statusCode == 201) {
        print('Berita berhasil ditambahkan');
        return true;
      } else {
        print('Gagal menambahkan berita: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error menambahkan berita: $e');
      return false;
    }
  }

  // Mengupdate berita
  static Future<bool> updateNews({
    required int id,
    required String title,
    required String description,
    required String content, // Tambahkan content
    required String imageUrl,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/news/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'title': title,
          'description': description,
          'content': content, // Kirim content
          'image_url': imageUrl,
        }),
      );
      if (response.statusCode == 200) {
        print('Berita berhasil diperbarui');
        return true;
      } else {
        print('Gagal memperbarui berita: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error memperbarui berita: $e');
      return false;
    }
  }

  // Menghapus berita
  static Future<bool> deleteNews(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/news/$id'));
      if (response.statusCode == 200) {
        print('Berita berhasil dihapus');
        return true;
      } else {
        print('Gagal menghapus berita: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error menghapus berita: $e');
      return false;
    }
  }

  // Fungsi untuk mengedit berita (dengan content)
  static Future<bool> editNews(int newsId, String title, String description, String content, String imageUrl) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/news/$newsId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'title': title,
          'description': description,
          'content': content, // Kirim content
          'image_url': imageUrl,
        }),
      );
      if (response.statusCode == 200) {
        print('Berita berhasil diperbarui');
        return true;
      } else {
        print('Gagal memperbarui berita: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error memperbarui berita: $e');
      return false;
    }
  }
}
