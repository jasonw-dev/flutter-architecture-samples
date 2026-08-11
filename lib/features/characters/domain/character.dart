/// A character as the rest of the app talks about it.
///
/// Nothing here knows an API exists: no `fromJson`, no wire field names, no
/// empty-string sentinels. That shape lives in `CharacterDto`.
class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.originName,
    this.type,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String imageUrl;
  final String originName;

  /// Null when the character has no sub-species. The API says the same thing
  /// with `""`; the translation happens in the DTO.
  final String? type;

  @override
  bool operator ==(Object other) =>
      other is Character &&
      other.id == id &&
      other.name == name &&
      other.status == status &&
      other.species == species &&
      other.imageUrl == imageUrl &&
      other.originName == originName &&
      other.type == type;

  @override
  int get hashCode =>
      Object.hash(id, name, status, species, imageUrl, originName, type);
}
