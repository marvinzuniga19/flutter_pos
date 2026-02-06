class Category {
  final String id;
  final String name;
  final String? icon;

  Category({required this.id, required this.name, this.icon});

  Category copyWith({String? id, String? name, String? icon}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
