import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/base_response.dart';
import 'package:im_mobile/models/user_model.dart';
import 'package:im_mobile/services/auth_service.dart';
import 'package:im_mobile/utils/logger.dart';

final registerControllerProvider = StateNotifierProvider<RegisterController, RegisterState>(
  (ref) => RegisterController(AuthService()),
);

class RegisterState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  RegisterState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class RegisterController extends StateNotifier<RegisterState> {
  final AuthService _authService;

  RegisterController(this._authService) : super(RegisterState());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      BaseResponse<UserModel> response = await _authService.register(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, isSuccess: response.success);
    } catch (e, stackTrace) {
      Log.e('RegisterController', '注册失败', e, stackTrace);
    }
  }

  void resetState() {
    state = RegisterState();
  }
}