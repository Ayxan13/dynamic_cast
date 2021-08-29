import 'package:dynamic_cast/constants.dart';

Translation _translation = new _EngTranslation();

enum Lang {
  Aze,
  Eng,
}

void setLanguage(Lang lang) {
  switch (lang) {
    case Lang.Eng:
      _translation = new _EngTranslation();
      break;

    case Lang.Aze:
      _translation = new _AzeTranslation();
      break;
  }
}

Translation get str => _translation;

// Provides translations to various languages
abstract class Translation {
  // Identifiers that start with `meta` are not actually translations.
  // they are meta-information about the translation
  Lang get metaLanguage;
  String get metaCurrentLanguageName;

  String get appName;
  String get signInOrUp;
  String get signUp;
  String get signIn;
  String get signUpBenefits;
  String get email;
  String get password;
  String get passwordHasMinSize;
  String get next;
  String get enterEmail;
  String get emailFormatWrong;
  String get emailHint => "someone@example.com";
  String get forgotPassword;
  String get userNotFound;
  String get somethingWentWrong;
  String get passwordTooWeak;
  String get emailAlreadyInUse;
  String get skip;
  String get podcasts;
  String get filters;
  String get discover;
  String get profile;
}

class _EngTranslation extends Translation {
  Lang get metaLanguage => Lang.Eng;
  String get metaCurrentLanguageName => "English";
  String get appName => "Dynamic Cast";
  String get signInOrUp => "Sign in or create an account";
  String get signUp => "Sign up";
  String get signIn => "Sign in";
  String get signUpBenefits => "Save the podcasts you like "
      "and sync across all your devices.";
  String get email => "Email";
  String get password => "Password";
  String get passwordHasMinSize =>
      "Must be at least $PASSWORD_MIN_LENGTH characters.";
  String get next => "Next";
  String get enterEmail => "Please enter your email.";
  String get emailFormatWrong => "Email format is wrong.";
  String get forgotPassword => "I forgot my password";
  String get userNotFound => "Username or password wrong";
  String get somethingWentWrong => "Something went wrong!";
  String get passwordTooWeak => "Password is too weak.";
  String get emailAlreadyInUse => "Email is already in use.";
  String get skip => "Skip";
  String get podcasts => "Podcasts";
  String get filters => "Filters";
  String get discover => "Discover";
  String get profile => "Profile";
}

class _AzeTranslation extends Translation {
  Lang get metaLanguage => Lang.Aze;
  String get metaCurrentLanguageName => "Azərbaycanca";
  String get appName => "Dinamik Kast";
  String get signInOrUp => "Daxil ol və ya hesab yarat";
  String get signUp => "Hesab yarat";
  String get signIn => "Daxil ol";
  String get signUpBenefits => "Bəyəndiyin podkastları topla və "
      "bütün cihazların arasında sinxronizasiya et.";
  String get email => "E-poçt";
  String get password => "Parol";
  String get passwordHasMinSize =>
      "Ən azı $PASSWORD_MIN_LENGTH hərf olmalıdır.";
  String get next => "Növbəti";
  String get enterEmail => "E-poçtunuzu daxil edin.";
  String get emailFormatWrong => "E-poçt formatı düzgün deyil.";
  String get forgotPassword => "Parolumu unutdum.";
  String get userNotFound => "İstifadəçi adı və ya parol yanlışdır.";
  String get somethingWentWrong => "Xəta baş verdi!";
  String get passwordTooWeak => "Parol çox zəifdir.";
  String get emailAlreadyInUse => "E-poçt artıq istifadə olunub.";
  String get skip => "Keç";
  String get podcasts => "Podkastlar";
  String get filters => "Filterlər";
  String get discover => "Kəşf et";
  String get profile => "Profil";
}
