import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/notification/noti_service.dart';
import 'package:task_management_system/providers/admin_provider/category/category_provider.dart';
import 'package:task_management_system/providers/admin_provider/company/company_provider.dart';
import 'package:task_management_system/providers/admin_provider/user/user_provider.dart';
import 'package:task_management_system/providers/auth_provider.dart';
import 'package:task_management_system/providers/custom_audio_provider.dart';
import 'package:task_management_system/providers/custom_image_provider.dart';
import 'package:task_management_system/providers/super_admin_provider/admin/create_admin_provider.dart';
import 'package:task_management_system/providers/super_admin_provider/dashboard/dashboard_provider.dart';
import 'package:task_management_system/providers/super_admin_provider/subscription/subscription_provider.dart';
import 'package:task_management_system/providers/user_provider/issue/issue_provider.dart';
import 'package:task_management_system/routes/app_route.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  // init notifications
  NotiService().initNotification();

  ErrorWidget.builder = (FlutterErrorDetails details) => Directionality(
    textDirection: TextDirection.ltr,
    child: Scaffold(
      body: Center(child: CustomText(text: "Something went wrong!")),
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => CustomImageProvider()), // 👈 Move this up here
            ChangeNotifierProxyProvider2<AuthProvider, CustomImageProvider, IssueProvider>(
              create: (context) => IssueProvider(
                context.read<AuthProvider>(),
                context.read<CustomImageProvider>(),
              ),
              update: (context, auth, imageProvider, previous) => IssueProvider(
                auth,
                imageProvider,
              ),
            ),
            ChangeNotifierProxyProvider<AuthProvider, CreateUpdateAdminProvider>(
              create: (context) => CreateUpdateAdminProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => CreateUpdateAdminProvider(auth),
            ),
            ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
            ChangeNotifierProvider(create: (context) => SuperAdminDashboardProvider()),
            ChangeNotifierProxyProvider<AuthProvider, CompanyProvider>(
              create: (context) => CompanyProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => CompanyProvider(auth),
            ),
            ChangeNotifierProxyProvider<AuthProvider, CategoryProvider>(
              create: (context) => CategoryProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => CategoryProvider(auth),
            ),
            ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
              create: (context) => UserProvider(context.read<AuthProvider>()),
              update: (context, auth, previous) => UserProvider(auth),
            ),
            ChangeNotifierProvider(create: (context) => CustomImageProvider()),
            ChangeNotifierProvider(create: (context) => CustomAudioProvider()),
          ],
          child: MaterialApp.router(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}