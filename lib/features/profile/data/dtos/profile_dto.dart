import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';

/// DTO와 Entity 간 변환
class ProfileDto {
  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
        nickname: json['nickname'],
        imageUrl: json['profileImageUrl'],
        location: json['location'],
      );
  ProfileDto({
    required this.nickname,
    required this.imageUrl,
    required this.location,
  });

  final String nickname;
  final String imageUrl;
  final String location;

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'profileImageUrl': imageUrl,
        'location': location,
      };

  // DTO -> Entity 변환
  Profile toEntity() => Profile(
        nickname: nickname,
        imageUrl: imageUrl,
        location: location,
      );

  // Entity -> DTO 변환
  factory ProfileDto.fromEntity(Profile entity) => ProfileDto(
        nickname: entity.nickname,
        imageUrl: entity.imageUrl,
        location: entity.location,
      );
}
