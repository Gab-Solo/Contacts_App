import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/data/db/app_database.dart';
import 'package:sembast/sembast.dart';

class ContactDao {
  static const String CONTACT_STORE_NAME = 'contacts';
  // A Store with int keys and Map<String, dynamic> values.
  // This is precisely what we need since we convert Contact objects to Map.
  final _contactStore = intMapStoreFactory.store(CONTACT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Contact contact) async {
    await _contactStore.add(
      await _db,
      contact.toMap(),
    );
  }

  Future update(Contact contact) async {
    // Finder object allows us to filter by key, field values and more.
    final finder = Finder(
      filter: Filter.byKey(contact.id),
    );

    await _contactStore.update(
      await _db,
      contact.toMap(),
      finder: finder,
    );
  }

  Future delete(Contact contact) async {
    final finder = Finder(
      filter: Filter.byKey(contact.id),
    );

    await _contactStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Contact>> getAllInSortedOrder() async {
    // Finder object can also facilitate sorting.
    // As before, we're primarily sorting based on favorite status,
    // secondary sorting is alphabetical
    final finder = Finder(sortOrders: [
      // false indicates that isFavorite will be sorted in descending order.
      SortOrder('isFavorite', false),
      SortOrder('name'),
    ]);

    final recordSnapshots = await _contactStore.find(
      await _db,
      finder: finder,
    );
    // Map iterates over the whole list and gives us access to every element.
    // it also returns a new list containing different values (Contact objects)
    return recordSnapshots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);
      contact.id = snapshot.key;
      return contact;
    }).toList();
  }
}
