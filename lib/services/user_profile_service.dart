import 'dart:async';
import '../models/user_profile.dart';

class UserProfileService {
  UserProfile? _profile;

  // Contoh data awal
  UserProfileService() {
    _profile = UserProfile(
      id: '1',
      name: 'Nama Pengguna',
      email: 'user@email.com',
      photoUrl: null,
      phoneNumber: '08123456789',
      address: 'Alamat pengguna',
    );
  }

  Future<UserProfile> getProfile() async {
    // Simulasi delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _profile!;
  }

  Future<void> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile = profile;
  }

  Future<void> updatePhoto(String photoUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_profile != null) {
      _profile = _profile!.copyWith(photoUrl: photoUrl);
    }
  }
}
