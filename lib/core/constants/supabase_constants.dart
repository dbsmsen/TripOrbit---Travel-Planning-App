class SupabaseConstants {
  static const String supabaseUrl = 'https://ujahdbsnsuucqexgwyej.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVqYWhkYnNuc3V1Y3FleGd3eWVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczODY5NzksImV4cCI6MjA2Mjk2Mjk3OX0.yelk3cBkWVkPmn52IUIwjx7xPiV6ku0VLy7viHlXmqw';

  // Auth related constants
  static const String authRedirectUri =
      'io.supabase.triporbit://login-callback/';

  // Storage bucket names
  static const String userAvatarsBucket = 'user-avatars';
  static const String tripImagesBucket = 'trip-images';

  // Table names
  static const String usersTable = 'users';
  static const String tripsTable = 'trips';
  static const String tripMembersTable = 'trip_members';
  static const String itinerariesTable = 'itineraries';
  static const String activitiesTable = 'activities';
  static const String expensesTable = 'expenses';
  static const String reviewsTable = 'reviews';
  static const String savedPlacesTable = 'saved_places';
}
