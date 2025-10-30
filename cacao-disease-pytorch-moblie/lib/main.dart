import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cacao Disease Detection',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DiseaseDetectionPage(),
    );
  }
}

class DiseaseDetectionPage extends StatefulWidget {
  const DiseaseDetectionPage({super.key});
  @override
  State<DiseaseDetectionPage> createState() => _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  static const platform = MethodChannel('cacao.disease/classifier');

  List<String> _labels = [];
  String _result = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _loadLabels();
  }

  Future<void> _loadLabels() async {
    try {
      final data = await rootBundle.loadString('assets/labels.txt');
      final lines = data.split('\n');
      final loadedLabels = lines
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      setState(() {
        _labels = loadedLabels;
      });

      print('✅ Labels loaded: $_labels');
    } catch (e) {
      print('❌ Lỗi khi đọc labels.txt: $e');
    }
  }

  Future<Map<String, dynamic>?> classifyWithAndroid(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final result = await platform.invokeMethod('classifyImage', {
        'image': bytes,
      });

      if (result is Map) {
        return Map<String, dynamic>.from(result);
      } else {
        print('❌ Dữ liệu trả về không đúng định dạng');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi từ native Kotlin: $e');
      return null;
    }
  }

  Future<void> _detectDisease() async {
    if (_selectedImage == null || _labels.isEmpty) {
      print('❌ Không có ảnh hoặc chưa load xong labels');
      return;
    }

    final resultMap = await classifyWithAndroid(_selectedImage!);
    if (resultMap == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Không nhận diện được')),
      );
      return;
    }

    final int predictedIndex = resultMap['labelIndex'];
    final double score = (resultMap['score'] as num).toDouble();

    if (predictedIndex >= _labels.length) {
      print('❌ Index trả về vượt quá danh sách nhãn');
      return;
    }

    setState(() {
      _result = _labels[predictedIndex];
      _confidence = score;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Kết quả: $_result (${(score * 100).toStringAsFixed(2)}%)'),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _result = '';
        _confidence = 0.0;
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
        _result = '';
        _confidence = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhận Diện Bệnh Ca Cao')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: _selectedImage == null
                    ? const Center(child: Text('Chưa có ảnh nào'))
                    : Image.file(_selectedImage!, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                'Kết quả: $_result (${(_confidence * 100).toStringAsFixed(2)}%)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Chụp ảnh'),
            ),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Chọn ảnh'),
            ),
            ElevatedButton.icon(
              onPressed: _detectDisease,
              icon: const Icon(Icons.search),
              label: const Text('Nhận diện bệnh'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
