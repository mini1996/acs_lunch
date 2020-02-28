class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig([config]) {
    _instance.appConfig = config;
    return _instance;
  }

  AppConfig._internal() {
    print("A new 'AppConfig' instance has been created.");
  }

  Map appConfig;

}
