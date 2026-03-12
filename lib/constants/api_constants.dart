class ApiConstants {

  static const successCode = 201;
  static const errorCode = 403;
  static const serverErrorCode = 500;

 // static const String baseUrl = 'http://18.132.26.96/api';
  //static const String storageUrl = 'http://18.132.26.96/storage/';


  static const String baseUrl = 'https://chantpouryehoshoua.org/api';

  static const String storageUrl = 'https://chantpouryehoshoua.org/storage/';

  static const String addProfileURL = '$baseUrl/addUserProfileData';


  static const String getHymnBooksURL = '$baseUrl/getHymnBooks';

  static const String getHymnBookSongsURL = '$baseUrl/getHymnBookSongs';
  static const String getHymnBookSongsListURL = '$baseUrl/getHymnBookSongList';
  static const String getHymnBookSongURL = '$baseUrl/getHymnSong';

  static const String addHymnSongURL = '$baseUrl/addHymnSong';
  static const String getHymnBookPoemsURL = '$baseUrl/getHymnBookPoems';


  /// All
  static const String getBooksDataURL = '$baseUrl/getBooksData';


  /// Poems

  static const String getHPoemByItemURL = '$baseUrl/getPoemById';


  /// Media files
  static const String getMediaFilesURL = '$baseUrl/getMediaFiles';


  static const String getWordsURL = '$baseUrl/getAllWords';
  static const String getNotificationsURL = '$baseUrl/getAllNotifications';



  /// Picture verses
  static const String getVersesURL = '$baseUrl/getVerses';

}
