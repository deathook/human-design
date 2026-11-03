// language_service.dart - Quản lý chuyển đổi ngôn ngữ Song Ngữ (VI / EN)
import 'package:flutter/material.dart';

class LanguageService {
  static final ValueNotifier<String> currentLang = ValueNotifier<String>('vi');

  static bool get isEnglish => currentLang.value == 'en';

  static void toggleLanguage() {
    currentLang.value = (currentLang.value == 'vi') ? 'en' : 'vi';
  }

  static void setLanguage(String lang) {
    if (lang == 'vi' || lang == 'en') {
      currentLang.value = lang;
    }
  }

  static String t(String vi, String en) {
    return isEnglish ? en : vi;
  }
}
