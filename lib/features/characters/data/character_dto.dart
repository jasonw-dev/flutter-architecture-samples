import 'package:flutter_architecture_samples/features/characters/domain/character.dart';

/// The wire shape of a character, in the API's own vocabulary: `image` rather
/// than `imageUrl`, `""` rather than null, `origin` as a nested object.
///
/// It exists so those conventions stop at this file. It models the fields the
/// app reads and ignores the rest of the payload (`url`, `created`, `episode`);
/// a DTO is a translation of the response, not an archive of it.
class CharacterDto {
  const CharacterDto({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.image,
    required this.originName,
  });

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    final origin = json['origin'] as Map<String, dynamic>;
    return CharacterDto(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
      originName: origin['name'] as String,
    );
  }

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String image;
  final String originName;

  Character toDomain() => Character(
    id: id,
    name: name,
    status: status,
    species: species,
    imageUrl: image,
    originName: originName,
    type: type.isEmpty ? null : type,
  );
}
