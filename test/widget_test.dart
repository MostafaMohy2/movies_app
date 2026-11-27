import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/config/app_config_cubit.dart';
import 'package:movies_app/core/config/app_config_states.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_cubit.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_page.dart';
import 'package:movies_app/features/auth/presentation/login/view/login_states.dart';
import 'package:movies_app/main.dart';

class _MockAppConfigCubit extends Mock implements AppConfigCubit {}

class _MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  late _MockAppConfigCubit mockAppConfigCubit;
  late _MockLoginCubit mockLoginCubit;

  setUpAll(() {
    registerFallbackValue(LoadAppConfigAction());
  });

  setUp(() async {
    await sl.reset();
    mockAppConfigCubit = _MockAppConfigCubit();
    mockLoginCubit = _MockLoginCubit();

    when(() => mockAppConfigCubit.state).thenReturn(const AppConfigStates());
    when(
      () => mockAppConfigCubit.stream,
    ).thenAnswer((_) => const Stream<AppConfigStates>.empty());
    when(() => mockAppConfigCubit.doAction(any())).thenAnswer((_) async {});
    when(() => mockAppConfigCubit.close()).thenAnswer((_) async {});

    when(() => mockLoginCubit.state).thenReturn(const LoginStates());
    when(
      () => mockLoginCubit.stream,
    ).thenAnswer((_) => const Stream<LoginStates>.empty());
    when(
      () => mockLoginCubit.navigation,
    ).thenAnswer((_) => const Stream<LoginNavigationAction>.empty());
    when(() => mockLoginCubit.close()).thenAnswer((_) async {});

    sl.registerSingleton<AppConfigCubit>(mockAppConfigCubit);
    sl.registerFactory<LoginCubit>(() => mockLoginCubit);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('App opens on LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MoviesApp());
    await tester.pump();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
