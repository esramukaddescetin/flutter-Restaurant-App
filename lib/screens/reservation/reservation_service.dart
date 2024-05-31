import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String name;
  final String phoneNumber;
  final DateTime date;
  final String time;

  Reservation({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'date': Timestamp.fromDate(date),
      'time': time,
    };
  }

  factory Reservation.fromMap(String id, Map<String, dynamic> map) {
    return Reservation(
      id: id,
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'],
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'reservations';

  Future<void> addReservation(Reservation reservation) async {
    try {
      await _firestore.collection(_collectionName).add(reservation.toMap());
    } catch (e) {
      throw Exception('Failed to add reservation: $e');
    }
  }

  Stream<List<Reservation>> getReservations() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Reservation.fromMap(doc.id, doc.data())).toList());
  }

  Future<bool> isSlotAvailable(DateTime date, String time) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check slot availability: $e');
    }
  }
}
