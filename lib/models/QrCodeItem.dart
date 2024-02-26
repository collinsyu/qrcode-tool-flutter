
class QrCodeItem {
  final int? id;
  final String value;
  final String date;
  final String type;

  QrCodeItem({
    this.id,
    required this.value,
    required this.date,
    required this.type,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the getDatabase().
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'value': value,
      'type': type,
      'date': date,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'QrCodeItem{id: $id, value: $value, type: $type, date: $date}';
  }
}