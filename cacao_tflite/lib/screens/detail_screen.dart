import 'dart:io';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> diseaseData;
  final File imageFile;

  const DetailScreen({
    super.key,
    required this.diseaseData,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          diseaseData["Tên bệnh"] ?? "Chi tiết",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh bệnh
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  imageFile,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Các mục thông tin
            _buildSection("🩺 Triệu chứng", diseaseData["Triệu chứng"]),
            _buildSection("🦠 Nguyên nhân", diseaseData["Nguyên nhân"]),
            _buildSection("🛡️ Cách phòng ngừa", diseaseData["Cách phòng ngừa"]),
            _buildSection("💊 Điều trị", diseaseData["Điều trị"]),
            _buildSection("📝 Ghi chú", [diseaseData["Ghi chú"]]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    if (content == null) return const SizedBox.shrink();

    List<String> items = [];
    if (content is List) {
      items = List<String>.from(content);
    } else if (content is String && content.isNotEmpty) {
      items = [content];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text("• $item"),
              )),
        ],
      ),
    );
  }
}
