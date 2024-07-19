class Feature {
    final int id;
    final String name;
    final String description;
    final bool active;

    Feature({
        required this.id,
        required this.name,
        required this.description,
        required this.active,
    });

    factory Feature.fromJson(Map<String, dynamic> json) {
        return Feature(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            active: json['active'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'name': name,
            'description': description,
            'active': active,
        };
    }
}
