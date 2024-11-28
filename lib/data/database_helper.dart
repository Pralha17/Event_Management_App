import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'events.db');

    return openDatabase(
      path,
      version: 2, // Updated version to handle schema changes
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            location TEXT,
            date TEXT,
            time TEXT,
            amount REAL,
            organizerId TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE organizers (
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE organizers (
              id TEXT PRIMARY KEY,
              name TEXT
            )
          ''');
        }
      },
    );
  }

  // Insert an event
  Future<int> insertEvent(Map<String, dynamic> event) async {
    try {
      final db = await database;
      return await db.insert('events', event);
    } catch (e) {
      throw Exception('Failed to insert event: $e');
    }
  }

  // Save or update organizer name
  Future<void> saveOrganizerName(String organizerId, String name) async {
    try {
      final db = await database;
      await db.insert(
        'organizers',
        {'id': organizerId, 'name': name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to save organizer name: $e');
    }
  }

  // Fetch organizer name
  Future<String?> getOrganizerName(String organizerId) async {
    try {
      final db = await database;
      final results = await db.query(
        'organizers',
        where: 'id = ?',
        whereArgs: [organizerId],
      );
      return results.isNotEmpty ? results.first['name'] as String? : null;
    } catch (e) {
      throw Exception('Failed to fetch organizer name: $e');
    }
  }

  // Fetch all events, optionally filtered by organizerId
  Future<List<Map<String, dynamic>>> getAllEvents({String? organizerId}) async {
    try {
      final db = await database;
      if (organizerId != null) {
        return await db.query(
          'events',
          where: 'organizerId = ?',
          whereArgs: [organizerId],
          orderBy: 'date',
        );
      }
      return await db.query('events', orderBy: 'date');
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  // Update an event
  Future<int> updateEvent(Map<String, dynamic> event) async {
    try {
      final db = await database;
      return await db.update(
        'events',
        event,
        where: 'id = ?',
        whereArgs: [event['id']],
      );
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  // Delete an event
  Future<int> deleteEvent(int id) async {
    try {
      final db = await database;
      return await db.delete('events', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
