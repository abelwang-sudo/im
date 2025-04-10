import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/router/router.dart';
import 'package:im_mobile/utils/shared_preferences_util.dart';
import 'package:im_mobile/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesUtil.init();

  // 初始化日志系统
  await Log.logFilePath; // 触发Logger初始化，确保只初始化一次
  Log.i('App', 'Application started');

  // 使用 router.dart 中定义的 container
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
              surfaceContainerLow: Colors.white
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.compact,
          scaffoldBackgroundColor: Colors.white,
          dividerTheme: DividerThemeData(color: Colors.grey.shade200),
          cardColor: Colors.white,
          cardTheme: CardTheme(
            elevation: 0,
          ),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.white),
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              scrolledUnderElevation: 0,
              color: Colors.white),
          outlinedButtonTheme: const OutlinedButtonThemeData(
              style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          )),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          )),
          dialogBackgroundColor: Colors.white,
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIconConstraints: const BoxConstraints(
              maxWidth: 40,
              minWidth: 40,
              maxHeight: 20,
            ),
          ),
          listTileTheme: ListTileThemeData(dense: true),
          switchTheme: SwitchThemeData(
              materialTapTargetSize: MaterialTapTargetSize.padded)),
      routerConfig: router,
    );
  }
}
