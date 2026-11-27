import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/network/api_result.dart';
import 'package:movies_app/core/network/errors.dart';
import 'package:movies_app/features/auth/domain/entities/auth_user_entity.dart';
import 'package:movies_app/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:movies_app/features/auth/presentation/register/view/register_cubit.dart';

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

void main() {
  late _MockRegisterUserUseCase mockRegisterUseCase;
  late RegisterCubit cubit;

  const tUser = AuthUserEntity(
    uid: 'u1',
    email: 'test@example.com',
    name: 'Test User',
    phone: '+201000000000',
    avatarAsset: 'assets/images/Component 11 – 1.png',
  );

  setUpAll(() {
    registerFallbackValue(
      const RegisterUserParams(
        name: '',
        email: '',
        password: '',
        phone: '',
        avatarAsset: '',
      ),
    );
  });

  setUp(() {
    mockRegisterUseCase = _MockRegisterUserUseCase();
    cubit = RegisterCubit(mockRegisterUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('RegisterCubit', () {
    test('initialState_hasInitialResource', () {
      expect(cubit.state.registerResource.isInitial, isTrue);
    });

    test('selectAvatar_updatesSelectedAvatarAsset', () {
      const nextAvatar = 'assets/images/Component 11 – 2.png';
      cubit.selectAvatar(nextAvatar);
      expect(cubit.state.selectedAvatarAsset, nextAvatar);
    });

    test('register_success_emitsSuccessResource', () async {
      when(
        () => mockRegisterUseCase(any()),
      ).thenAnswer((_) async => const Success(tUser));

      await cubit.register(
        name: 'Test User',
        email: 'test@example.com',
        password: 'Password1!',
        phone: '+201000000000',
      );

      expect(cubit.state.registerResource.isSuccess, isTrue);
    });

    test('register_failure_emitsErrorResourceWithMessage', () async {
      when(() => mockRegisterUseCase(any())).thenAnswer(
        (_) async => const Failure(
          exception: JustMessage('Email already in use'),
          message: 'Email already in use',
        ),
      );

      await cubit.register(
        name: 'Test User',
        email: 'test@example.com',
        password: 'Password1!',
        phone: '+201000000000',
      );

      expect(cubit.state.registerResource.isError, isTrue);
      expect(cubit.state.registerResource.message, 'Email already in use');
    });
  });
}
