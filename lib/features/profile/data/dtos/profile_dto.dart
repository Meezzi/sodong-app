import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';

class ProfileDto {
  ProfileDto({
    required this.nickname,
    required this.imageUrl,
    required this.location,
  });
  final String nickname;
  final String imageUrl;
  final String location;

  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
        nickname: json['nickname'],
        imageUrl: json['imageUrl'],
        location: json['location'],
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'imageUrl': imageUrl,
        'location': location,
      };

  ProfileEntity toEntity() => ProfileEntity(
        nickname: nickname,
        imageUrl: imageUrl,
        location: location,
      );

  factory ProfileDto.fromEntity(ProfileEntity entity) => ProfileDto(
        nickname: entity.nickname,
        imageUrl: entity.imageUrl,
        location: entity.location,
      );
}
