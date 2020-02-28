class Endpoints {
  Endpoints._();

  static const String refreshToken = "/user/login";
  static const String loginUrl = "/users/current.json";
  static const String lunchBookingUrl = "/time_entries.json";
  static const String checkBookingUrl = "/time_entries.json?project_id=342&limit=100&spent_on=";
  static const String lunchCancellingUrl="/time_entries/";
 static const String menuDisplayUrl="/custom_fields.json";
}
