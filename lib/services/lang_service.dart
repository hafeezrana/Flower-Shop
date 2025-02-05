// import 'package:flowershop/utils/app_preferences.dart';
//
// class LanguageService {
//   static Future<String> getSelectedLanguage() async {
//     final prefs = AppPreferences.getString(AppPreferences.languageCode);
//     if (prefs.isNotEmpty) {
//       return prefs;
//     }
//     return 'en';
//   }
//
//   static Future<bool> saveSelectedLanguage(String languageCode) async {
//     final lang = await AppPreferences.setString(
//         AppPreferences.languageCode, languageCode);
//     return lang;
//   }
//
//
// }
//
//
