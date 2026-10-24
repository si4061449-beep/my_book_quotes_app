import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const BookQuotesApp());
}

class BookQuotesApp extends StatelessWidget {
  const BookQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'বইয়ের উক্তি ও শিক্ষা',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xF2F5F8),
      ),
      home: const QuoteHomeScreen(),
    );
  }
}

class QuoteHomeScreen extends StatefulWidget {
  const QuoteHomeScreen({super.key});

  @override
  State<QuoteHomeScreen> createState() => _QuoteHomeScreenState();
}

class _QuoteHomeScreenState extends State<QuoteHomeScreen> {
  final List<Map<String, String>> _quotes = [
    {
      'quote': '“সফলতা কোনো চূড়ান্ত বিষয় নয়, ব্যর্থতা মানেই ধ্বংস নয়; চালিয়ে যাওয়ার সাহসটাই আসল।”',
      'book': '— দ্য লাস্ট লেকচার',
      'explanation': 'শিক্ষা: জীবনে হার-জিত থাকবেই, আসল বিষয় হলো নিজের লক্ষ্য থেকে পিছু না হটে চেষ্টা চালিয়ে যাওয়া।'
    },
    {
      'quote': '“যখন তুমি কিছু পাওয়ার জন্য মন থেকে চেষ্টা করবে, তখন পুরো বিশ্ব তোমাকে তা পেতে সাহায্য করবে।”',
      'book': '— দ্য অ্যালকেমিস্ট (পাউলো কোয়েলহো)',
      'explanation': 'শিক্ষা: নিজের স্বপ্নের প্রতি অটল বিশ্বাস ও পরিশ্রম থাকলে সাফল্য আসবেই।'
    },
    {
      'quote': '“ভবিষ্যতের সেরা পূর্বাভাস হলো তা নিজে তৈরি করা।”',
      'book': '— দ্য সেভেন হ্যাবিটস অব হাইলি ইফেক্টিভ পিপল',
      'explanation': 'শিক্ষা: ভাগ্য বা পরিস্থিতির ওপর দোষ না দিয়ে নিজের ভবিষ্যৎ গঠনে আজই কাজ শুরু করা উচিত।'
    },
  ];

  int _currentIndex = 0;

  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
    });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'quote_channel_id',
      'Daily Quotes',
      channelDescription: 'Notification for daily inspirational quotes',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'আজকের অনুপ্রেরণামূলক উক্তি 📖',
      _quotes[_currentIndex]['quote'],
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuote = _quotes[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('বইয়ের উক্তি ও শিক্ষা'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      currentQuote['quote']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentQuote['book']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),
                    Text(
                      currentQuote['explanation']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black64,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _nextQuote,
                  icon: const Icon(Icons.refresh),
                  label: const Text('অন্য উক্তি'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showNotification,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('নোটিফিকেশন দেখুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
