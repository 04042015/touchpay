enum TableStatus {
  available,
  occupied,
  reserved,
  cleaning,
}

class Table {
  final String id;
  final String name;
  final int capacity;
  final TableStatus status;
  final String? currentOrderId;
  final DateTime? occupiedSince;
  final DateTime createdAt;
  final DateTime updatedAt;

  Table({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
    this.currentOrderId,
    this.occupiedSince,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      status: TableStatus.values.firstWhere(
        (status) => status.name == json['status'],
      ),
      currentOrderId: json['current_order_id'],
      occupiedSince: json['occupied_since'] != null
          ? DateTime.parse(json['occupied_since'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'status': status.name,
      'current_order_id': currentOrderId,
      'occupied_since': occupiedSince?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Table copyWith({
    String? id,
    String? name,
    int? capacity,
    TableStatus? status,
    String? currentOrderId,
    DateTime? occupiedSince,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Table(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      occupiedSince: occupiedSince ?? this.occupiedSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
