/// Pay Consts
abstract class PayKeyConsts {
  static const stripePublishKey = String.fromEnvironment(
    'PUBLISH_KEY',
    defaultValue: '',
  );

  static const stripeSecretKey = String.fromEnvironment(
    'SECRET_KEY',
    defaultValue: '',
  );
}

abstract class SupabaseConsts {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '<YOUR_SUPABASE_URL>',
  );

  static const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANNON_KEY',
  );
}

abstract class GoogleMapKeyConsts {
  static const googleMapKey = String.fromEnvironment(
    'GOOGLE_MAP_KEY',
    defaultValue: 'YOUR_GOOGLE_MAP_KEY',
  );
}
