import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/src/models/ticket_model.dart';

const String TICKET_COLLETCION_REF = "Tickets";

class DatabaseServices {
  final _fireStore = FirebaseFirestore.instance;

  late final CollectionReference _ticketRef;

  DatabaseServices() {
    _ticketRef =
        _fireStore.collection(TICKET_COLLETCION_REF).withConverter<TicketModel>(
              fromFirestore: (snapshots, _) => TicketModel.fromMap(
                snapshots.data()!,
              ),
              toFirestore: (ticket, _) => ticket.toMap(),
            );
  }

  Stream<QuerySnapshot> getTickets() {
    return _ticketRef.snapshots();
  }

  Future<DocumentReference> addTicket(TicketModel model) async {
    try {
      return await _ticketRef.add(model);
    } catch (e) {
      print('Error adding ticket: $e');
      throw e;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();

      final imageRef = storageRef.child(
          'ticket_attachments/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = imageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => {});

      final imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }
}

final databaseServicesProvider = Provider<DatabaseServices>((ref) {
  return DatabaseServices();
});
