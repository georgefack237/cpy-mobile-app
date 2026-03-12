import 'package:cpy_app/data/local/database_services.dart';
import 'package:cpy_app/data/models/hymn_book_collection.dart';
import 'package:cpy_app/data/models/hymn_song.dart';
import 'package:cpy_app/data/models/poem_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../core/helpers/helper_functions.dart';
import '../data/models/hymn_partition.dart';

List<HymnPartition> currentSongPartition = [];

List<HymnBookCollection> localBooks = [];
List<HymnSong>  localHymns = [];
List<PoemModel>  localPoems = [];

HelperFunctions helperFunctions = HelperFunctions();

DatabaseService databaseService = DatabaseService();

ValueNotifier<bool> isNetworkEnabled = ValueNotifier(true);

Logger logger = Logger();

