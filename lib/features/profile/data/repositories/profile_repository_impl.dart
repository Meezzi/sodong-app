import 'package:sodong_app/features/profile/data/data_sources/profile_data_source.dart';
import 'package:sodong_app/features/profile/data/dtos/profile_dto.dart';
import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

/// 추상 레포지토리 구현체
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this.remoteDataSource);
  final ProfileDataSource remoteDataSource;

  @override
  Future<ProfileEntity> getUser(String userId) async {
    final dto = await remoteDataSource.getUser(userId);
    return dto.toEntity();
  }

  @override
  Future<void> updateUser(String userId, ProfileEntity user) async {
    final dto = ProfileDto.fromEntity(user);
    await remoteDataSource.updateUser(userId, dto);
  }
}
