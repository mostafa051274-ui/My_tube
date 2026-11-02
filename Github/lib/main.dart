import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أداة يوتيوب',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  String _extractVideoId(String url) {
    final regExp = RegExp(r'^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*');
    final match = regExp.firstMatch(url);
    return (match != null && match.group(2)!.length == 11) ? match.group(2)! : url.trim();
  }

  Future<void> _launchUrl(String targetUrl) async {
    final Uri uri = Uri.parse(targetUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('تعذر فتح الرابط $uri');
    }
  }

  void _openYoutube() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;
    String videoId = _extractVideoId(input);
    _launchUrl('https://www.youtube.com/watch?v=$videoId');
  }

  void _downloadVideo(String service) {
    String input = _controller.text.trim();
    if (input.isEmpty) return;
    String videoId = _extractVideoId(input);
    String fullUrl = 'https://www.youtube.com/watch?v=$videoId';

    String downloadUrl = '';
    if (service == 'vidssave') {
      downloadUrl = 'https://vidssave.com/youtube-video-downloader-8hs?url=$fullUrl';
    } else if (service == 'ytdown') {
      downloadUrl = 'https://app.ytdown.to/en38/?url=$fullUrl';
    }

    _launchUrl(downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أداة تشغيل وتنزيل اليوتيوب'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'ضع رابط الفيديو هنا',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _openYoutube,
              icon: const Icon(Icons.play_arrow),
              label: const Text('فتح في يوتيوب'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => _downloadVideo('vidssave'),
              icon: const Icon(Icons.download),
              label: const Text('تنزيل (VidsSave)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => _downloadVideo('ytdown'),
              icon: const Icon(Icons.download),
              label: const Text('تنزيل (YTDown)'),
            ),
          ],
        ),
      ),
    );
  }
}
