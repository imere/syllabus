import 'package:schedule/course.model.dart';
import 'package:sqflite/sqflite.dart';

const TABLE = 'COURSES';
const ID = 'ID';
const NAME = 'NAME';
const ROOM = 'ROOM';
const TEACHER = 'TEACHER';
const START = 'START';
const STEP = 'STEP';
const WEEKDAY = 'WEEKDAY';
const WEEKS = 'WEEKS';

class CourseProvider {
  Database _db;

  static Future getPath() async {
    return await getDatabasesPath();
  }

  Future open(String path) async {
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $TABLE (
          $ID      integer primary key autoincrement, 
          $NAME    text    not null default '',
          $ROOM    text    not null default '',
          $TEACHER text    not null default '',
          $START   integer not null default -1,
          $STEP    integer not null default -1,
          $NAME    text    not null default '',
          $WEEKDAY integer not null default -1,
          $WEEKS   text    not null default '[]');
        ''');
      },
    );
  }

  Future<CourseModel> insert(CourseModel course) async {
    await _db.insert(TABLE, course.toMap());
    return course;
  }

  Future<CourseModel> getTodo(int id) async {
    List<Map> maps = await _db.query(
      TABLE,
      columns: [ID, NAME, ROOM, TEACHER, START, STEP, WEEKDAY, WEEKS],
      where: '$ID = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return CourseModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      TABLE,
      where: '$ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(CourseModel course) async {
    return await _db.update(
      TABLE,
      course.toMap(),
      where: '$WEEKDAY = ? and $NAME',
      whereArgs: [course.weekday, course.name],
    );
  }

  Future close() async => _db.close();
}
