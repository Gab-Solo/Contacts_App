import 'dart:io';

import 'package:meta/meta.dart';

class Contact {
  // Database id (key)
  int id;

  String name;
  String email;
  // String - not all phone numbers are valid mathematical numbers
  String phoneNumber;
  bool isFavorite;
  File imageFile;
  // Contructor with optional named parameters
  Contact({
    // @required annotation makes sure that
    // an optional parameter is actually passed in
    @required this.name,
    @required this.email,
    @required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      // A trick which allows us to sort based on isFavorite.
      // Boolean values are not comparable, integers, however, can be compared.
      'isFavorite': isFavorite ? 1 : 0,
      // We cannot store a file object in with SEMBAST library directly.
      // That's why we only store its path.
      'imageFilePath': imageFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
      imageFile:
          map['imageFilePath'] != null ? File(map['imageFilePath']) : null,
    );
  }
}
