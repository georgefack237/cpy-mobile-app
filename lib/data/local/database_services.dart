import 'dart:async';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/data/models/hymn_song.dart';
import 'package:cpy_app/data/models/poem_model.dart';
import 'package:cpy_app/features/media/data/models/media_file.dart';
import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/profile/model/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/notifications/models/notification_id.dart';


class DatabaseService {

  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();


    final path = join(databasePath, 'cpy_app_platform.db');

    FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
      if (oldVersion < newVersion) {
      }
    }

    return await openDatabase(
      path,
      onUpgrade: onUpgrade,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }


  Future<void> _onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE hymn_books(id INTEGER PRIMARY KEY, hymn_book_author_id INTEGER, name_en TEXT, name_fr TEXT, hymn_songs_count INTEGER, hymn_poems_count INTEGER)',
    );


  await db.execute(
  'CREATE TABLE files(id INTEGER PRIMARY KEY, media_type_id INTEGER, name TEXT, path TEXT,size INTEGER, link TEXT, place_holder_image TEXT )',
  );

    await db.execute(
      'CREATE TABLE hymn_songs(id INTEGER PRIMARY KEY, hymn_book_id INTEGER, category_id INTEGER, scale_id INTEGER, language_id INTEGER, title TEXT, audio_url TEXT, has_one_progression INTEGER, has_chord_over_lyrics INTEGER, partitions TEXT, unique_progression INTEGER, file_size INTEGER)',
    );


    await db.execute(
      'CREATE TABLE poems(id INTEGER PRIMARY KEY, hymn_book_id INTEGER, category_id INTEGER, title TEXT, lyrics TEXT)',
    );

    await db.execute(
      'CREATE TABLE word_references(id INTEGER PRIMARY KEY, word TEXT, etymology TEXT, definition TEXT, created_at TEXT)',
    );

    await db.execute(
      'CREATE TABLE notification_ids(id INTEGER PRIMARY KEY, notification_id TEXT)',
    );

    await db.execute(
      'CREATE TABLE picture_verses(id INTEGER PRIMARY KEY, verse TEXT, description TEXT, type TEXT, image TEXT, is_active INTEGER)',
    );

    await db.execute(
      'CREATE TABLE profiles(id INTEGER PRIMARY KEY, notification_id TEXT, device_id TEXT)',
    );
  }



  //// WORD REFERENCE

    Future<WordReference> insertWord(WordReference word) async {
    final db = await _databaseService.database;
    await db.insert(
        'word_references',
        word.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted word");
    }

    return word;
  }



  Future<PictureVerse> insertVerse(PictureVerse verse) async {
    final db = await _databaseService.database;
    await db.insert(
        'picture_verses',
        verse.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted picture verse");
    }

    return verse;
  }


  Future<List<PictureVerse>?> getAllVerses() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('picture_verses');

    if (maps.isEmpty) {
      return null;
    } else {
      return maps.map((verse) {
        return PictureVerse.fromJson(verse);
      }).toList();
    }
  }



  Future<MediaFile> insertFile(MediaFile file) async {
    final db = await _databaseService.database;
    await db.insert(
        'files',
        file.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted word");
    }

    return file;
  }


  Future<List<MediaFile>?> getAllFiles() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('files');

    if (maps.isEmpty) {
      return null;
    } else {
      return maps.map((word) {
        return MediaFile.fromDb(word);
      }).toList();
    }
  }

  Future<List<WordReference>?> getAllWords() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('word_references');

    if (maps.isEmpty) {
      return null;
    } else {
      return maps.map((word) {
        return WordReference.fromDb(word);
      }).toList();
    }
  }

  deleteWords() async {
    final db =  await _databaseService.database;
    return await db.rawDelete("DELETE FROM word_references");
  }



  Future<NotificationId> insertNotificationId(NotificationId notificationId) async {
    final db = await _databaseService.database;
    await db.insert(
        'notification_ids',
        notificationId.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted notification id");
    }

    return notificationId;
  }



  /// Insert Notification Id
  Future<Profile> insertProfile(Profile profile) async {
    final db = await _databaseService.database;
    await db.insert(
        'profiles',
        profile.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted profile successfully");
    }

    return profile;
  }


  Future<Profile?> getProfile(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('profiles', where: 'device_id = ?', whereArgs: [id]);

    if(maps.isEmpty){
      return null;
    }else{

      return Profile.fromDb(maps[0]);
    }

  }

  /// Get notification Id
  Future<NotificationId?> getNotificationId(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('notification_ids', where: 'id = ?', whereArgs: [id]);

    if(maps.isEmpty){
      return null;
    }else{
      return NotificationId.fromDb(maps[0]);
    }

  }


  /// Insert Hymn Book
  Future<PoemModel> insertHymnPoem(PoemModel poem) async {
    final db = await _databaseService.database;
    await db.insert(
        'poems',
        poem.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted hymn song");
    }

    return poem;
  }


  /// Insert Hymn Book
  Future<HymnSong> insertHymnSong(HymnSong hymn) async {

    final db = await _databaseService.database;

    await db.insert(
        'hymn_songs',
         hymn.toDb(),
         conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted hymn song");
    }

    return hymn;

  }



  Future<List<PoemModel>?> getAllPoems() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('poems');

    if (maps.isEmpty) {
      return null;
    } else {
      return maps.map((poem) {
        return PoemModel.fromDb(poem);
      }).toList();
    }
  }



  Future<List<HymnSong>?> getAllSongs() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('hymn_songs');

    if (maps.isEmpty) {
      return null;
    } else {
      return maps.map((poem) {
        return HymnSong.fromDb(poem);
      }).toList();
    }
  }



  Future<HymnSong?> getHymnSongById({required int id}) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query(
        'hymn_songs', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    } else {
      return HymnSong.fromDb(maps[0]);

    }
  }


  Future<List<PoemModel>?> getHymnPoemsByHymnBookId({required int hymnBookId}) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query(
        'poems', where: 'hymn_book_id = ?', whereArgs: [hymnBookId]);

    if (maps.isEmpty) {
      return null;
    } else {
      return maps.map((poem) {
        return PoemModel.fromDb(poem);
      }).toList();
    }
  }

  /// Get hymn book by id
  Future<List<HymnSong>?> getHymnSongsByHymnBookId({required int hymnBookId}) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query(
        'hymn_songs', where: 'hymn_book_id = ?', whereArgs: [hymnBookId]);

    if (maps.isEmpty) {

      return null;

    } else {

      return maps.map((hymn) {
        return HymnSong.fromDb(hymn);
      }).toList();

    }
  }


    /// Insert Hymn songs
  Future<HymnBookCollection> insertHymnBook(HymnBookCollection hymnBook) async {
    final db = await _databaseService.database;
    await db.insert(
      'hymn_books',
      hymnBook.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    if (kDebugMode) {
      print("Inserted hymn book");
    }

    return hymnBook;
  }


  /// Get all hymn books
  Future<List<HymnBookCollection>>getHymnBooks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('hymn_books');
    return List.generate(maps.length, (index) => HymnBookCollection.fromDb(maps[index]));
  }


  /// Get hymn book by id
  Future<HymnBookCollection?> getHymnBookById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('hymn_books', where: 'id = ?', whereArgs: [id]);

    if(maps.isEmpty){
      return null;
    }else{
      return HymnBookCollection.fromDb(maps[0]);
    }

  }


  /// Delete all hymn Books
  deleteAllHymnBooks() async {
    final db =  await _databaseService.database;
    return await db.rawDelete("DELETE FROM hymn_books");
  }

  /// Delete hymn book by id
  Future<void> deleteHymnBookById(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'hymn_books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  /// Insert HymnBook batch
  Future<void> insertHymnBookBatch(List<HymnBookCollection> hymnBooks)async{
    final db = await _databaseService.database;
    final Batch batch = db.batch();
    for (var data in hymnBooks) {
      batch.insert(
        'hymn_books',
        data.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }


  /// Update hymn book
  Future<void> updateHymnBook(HymnBookCollection hymnBook) async {
    final db = await _databaseService.database;
    await db.update(
      'hymn_books',
      hymnBook.toDb(),
      where: 'id = ?',
      whereArgs: [hymnBook.id],
    );
  }



  Future<void> deleteToken(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'tokens',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  deleteUsers() async {
    final db =  await _databaseService.database;
    return await db.rawDelete("DELETE FROM users");
  }

}
