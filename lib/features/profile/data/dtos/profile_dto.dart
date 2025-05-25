import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';

/// DTO와 Entity 간 변환
class ProfileDto {
  ProfileDto({
    required this.nickname,
    required this.imageUrl,
    required this.location,
  });

  final String nickname;
  final String imageUrl;
  final String location;

  // JSON -> DTO 변환 시 profileImageUrl 키 사용
  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
        nickname: json['nickname'],
        imageUrl: json['profileImageUrl'], // profileImageUrl로 수정
        location: json['location'],
      );

  // DTO -> JSON 변환 시 profileImageUrl 키 사용
  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'profileImageUrl': imageUrl, // profileImageUrl로 수정
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
