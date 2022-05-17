import 'package:bytebank/models/contacts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDataBase() {
  return getDatabasesPath().then((dbPath) {
    // Cria o banco no caminho
    final String path = join(dbPath, 'bytebank.db');

    // Abre o banco de dados
    return openDatabase(path, onCreate: (db, version) {
      // Vai executar a query do sqlite
      db.execute('CREATE TABLE contacts ('
          'id NUMBER INTERGER,'
          'name TEXT, '
          'account_number INTERGER)');
    }, version: 1);
  });
}

Future<int> save(Contact contact) {
  return createDataBase().then((db) {
    final Map<String, dynamic> contactMap = Map();
    contactMap['id'] = contact.id;
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;

    return db.insert('contacts', contactMap);
  });
}

Future<List<Contact>> findAll() {
  return createDataBase().then((db) {
    return db.query('contacts').then((maps) {
      final List<Contact> contacts = [];

      for (Map<String, dynamic> map in maps) {
        final Contact contact = Contact(
          map['id'],
          map['name'],
          map['account_number'],
        );
        contacts.add(contact);
      }
      return contacts;
    });
  });
}
