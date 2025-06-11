import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'detail_screen.dart';

class DiseaseDetectionPage extends StatefulWidget {
  const DiseaseDetectionPage({super.key});

  @override
  State<DiseaseDetectionPage> createState() => _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Interpreter? _interpreter;
  List<String> _labels = [];
  String _result = '';
  String? _diseaseName;
  double _confidence = 0.0;
  bool _isLoading = false;
  

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/efficientnetb0.tflite');
      print('✅ Mô hình tải thành công!');
    } catch (e) {
      print('❌ Lỗi khi tải mô hình: $e');
    }
  }

  Future<void> _loadLabels() async {
    final labelsData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
    _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _selectedImage = File(image.path);
      _result = '';
      _confidence = 0.0;
    });
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

  Float32List _preprocessImage(img.Image image) {
    final resized = img.copyResizeCropSquare(image, size: 224);
    final Float32List input = Float32List(1 * 224 * 224 * 3);
    int index = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        input[index++] = pixel.r.toDouble();
        input[index++] = pixel.g.toDouble();
        input[index++] = pixel.b.toDouble();
      }
    }
    return input;
  }

  Future<void> _detectDisease() async {
  if (_selectedImage == null || _interpreter == null || _labels.isEmpty) return;

  setState(() => _isLoading = true); // ⬅️ thêm

  try {
    final imageBytes = await _selectedImage!.readAsBytes();
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) return;

    final input = _preprocessImage(decoded);
    final output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

    final List<double> scores = List<double>.from(output[0]);
    int maxIndex = 0;
    double maxScore = scores[0];
    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        maxIndex = i;
      }
    }

    setState(() {
      _result = _labels[maxIndex];
      _confidence = maxScore;
    });

    final jsonString = await DefaultAssetBundle.of(context).loadString('assets/disease_info.json');
    final Map<String, dynamic> allData = json.decode(jsonString);
    final Map<String, dynamic>? diseaseJson = allData[_result.trim()];

    if (diseaseJson == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Không tìm thấy thông tin bệnh.')),
      );
      return;
    }

    setState(() {
      _diseaseName = diseaseJson["Tên bệnh"];
    });

    setState(() {
      _isLoading = true;
    });

    // 🕒 Đợi 3 giây mô phỏng animation loading
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    // ✅ Sau đó mới chuyển sang màn hình chi tiết
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          diseaseData: diseaseJson,
          imageFile: _selectedImage!,
        ),
      ),
    );

  } finally {
    setState(() => _isLoading = false); // ⬅️ ẩn loading
  }
}


  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhận Diện Bệnh Ca Cao'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.green.shade50,
        child: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
              child: Center(
                child: _isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('🔍 Đang nhận diện... Vui lòng chờ', style: TextStyle(fontSize: 16)),
                        ],
                      )
                    : _selectedImage == null
                        ? const Text('🖼️ Vui lòng chọn hoặc chụp ảnh để nhận diện')
                        : Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_selectedImage!, fit: BoxFit.cover),
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 12),
            if (_result.isNotEmpty)
              Column(
                children: [
                  Text(
                    '${_getDiseaseEmoji(_diseaseName ?? _result)} Kết quả: ${_diseaseName ?? _result}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Độ chính xác: ${(_confidence * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.camera_alt, "Chụp ảnh", _takePhoto),
                _actionButton(Icons.photo_library, "Chọn ảnh", _pickImage),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _detectDisease,
                icon: const Icon(Icons.search, size: 28),
                label: const Text("Nhận diện bệnh"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  String _getDiseaseEmoji(String name) {
  name = name.toLowerCase();
  if (name.contains("khỏe")) return "🌿";
  if (name.contains("gỉ")) return "🦠";
  if (name.contains("đốm")) return "☣️";
  if (name.contains("thối")) return "🧫";
  return "🧐";
}

}
