import 'package:quizapp/about/about.dart';
import 'package:quizapp/profile/profile.dart';
import 'package:quizapp/login/login.dart';
import 'package:quizapp/topics/topics.dart';
import 'package:quizapp/home/home.dart';

// It's usually nice to organise routes into a separate file like this
var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/topics': (context) => const TopicsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
};
