/// Centralized constants for Note Vatika.
/// All strings, URLs, and configuration values live here.
class AppConstants {
  // ─── App Info ───────────────────────────────────────────────────
  static const String appName = 'Note Vatika';
  static const String appTagline = 'Your Garden of Knowledge 🌿';
  static const String appVersion = '1.0.0';

  // ─── API URLs ───────────────────────────────────────────────────
  /* TODO: Replace with real API URL */
  static const String coursesUrl = 'https://your-api.com/courses.json';
  /* TODO: Replace with real API URL */
  static const String subjectsUrl = 'https://your-api.com/subjects.json';
  /* TODO: Replace with real API URL */
  static const String topicsUrl = 'https://your-api.com/topics.json';
  /* TODO: Replace with real API URL */
  static const String notesUrl = 'https://your-api.com/notes.json';

  // ─── Asset Paths ────────────────────────────────────────────────
  static const String logoPath = 'assets/default/logo.PNG';
  static const String homeLogoPath = 'assets/default/homeLogo.PNG';
  static const String devImgPath = 'assets/default/devImg.JPG';

  // ─── Temp Data Paths ────────────────────────────────────────────
  static const String tempCoursesPath = 'lib/temp_data/courses.json';
  static const String tempSubjectsPath = 'lib/temp_data/subjects.json';
  static const String tempTopicsPath = 'lib/temp_data/topics.json';
  static const String tempNotesPath = 'lib/temp_data/notes.json';

  // ─── Developer Info ─────────────────────────────────────────────
  static const String developerName = 'Mayur Soni';
  static const String developerRole = 'Flutter Developer & Student';
  static const String developerBio =
      'Passionate about building beautiful mobile applications '
      'that make education accessible to everyone. Currently pursuing '
      'computer science and building tools to help students learn better.';

  /* TODO: Replace with real social URLs */
  static const String githubUrl = 'https://github.com/yourusername';
  /* TODO: Replace with real social URLs */
  static const String instagramUrl = 'https://instagram.com/yourusername';

  // ─── Motivational Quote ─────────────────────────────────────────
  static const String motivationalQuote =
      '"Education is the most powerful weapon which you can use to change the world." — Nelson Mandela';

  // ─── Network Config ─────────────────────────────────────────────
  static const Duration networkTimeout = Duration(seconds: 10);
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration interstitialAdDelay = Duration(seconds: 2);
}
