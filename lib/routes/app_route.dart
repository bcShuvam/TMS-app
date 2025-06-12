import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_system/pages/admin/admin_dashboard_screen.dart';
import 'package:task_management_system/pages/admin/category/caterories_screen.dart';
import 'package:task_management_system/pages/admin/category/sub_categories_screen.dart';
import 'package:task_management_system/pages/admin/company/companies_screen.dart';
import 'package:task_management_system/pages/admin/company/create_company_screen.dart';
import 'package:task_management_system/pages/admin/user/create_user_screen.dart';
import 'package:task_management_system/pages/admin/user/users_list_screen.dart';
import 'package:task_management_system/pages/login_screen.dart';
import 'package:task_management_system/pages/new_password_screen.dart';
import 'package:task_management_system/pages/otp_verification_screen.dart';
import 'package:task_management_system/pages/super_admin/admin/create_update_admin.dart';
import 'package:task_management_system/pages/super_admin/admin/manage_admin.dart';
import 'package:task_management_system/pages/super_admin/dashboard.dart';
import 'package:task_management_system/pages/super_admin/subscription/new_subscription_screen.dart';
import 'package:task_management_system/pages/super_admin/subscription/subscriptions_screen.dart';
import 'package:task_management_system/pages/user/feed/my_task_screen.dart';
import 'package:task_management_system/pages/user/feed/post_feed_screen.dart';
import 'package:task_management_system/pages/user/issue/create_issue_screen.dart';
import 'package:task_management_system/pages/user/issue/issue_details_screen.dart';
import 'package:task_management_system/pages/user/user_dashboard_screen.dart';
import 'package:task_management_system/routes/app_route_name.dart';

GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: AppRouteName.loginRouteName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp_verification',
      name: AppRouteName.otpVerificationRouteName,
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/new_password',
      name: AppRouteName.newPasswordRouteName,
      builder: (context, state) => const NewPasswordScreen(),
    ),
    GoRoute(
      path: '/super_admin_dashboard',
      name: AppRouteName.superAdminDashboardRouteName,
      builder: (context, state) => SuperAdminDashboardScreen(),
    ),
    GoRoute(
      path: '/super_admin_manage_admin',
      name: AppRouteName.superAdminManageAdminRouteName,
      builder: (context, state) => ManageAdminScreen(),
    ),
    GoRoute(
      path: '/super_admin_create_update_admin',
      name: AppRouteName.superAdminCreateUpdateAdminRouteName,
      builder: (context, state) => CreateUpdateAdminScreen(),
    ),
    GoRoute(
      path: '/super_admin_new_subscription',
      name: AppRouteName.superAdminNewSubscriptionRouteName,
      builder: (context, state) => NewSubscriptionScreen(),
    ),
    GoRoute(
      path: '/super_admin_subscriptions',
      name: AppRouteName.superAdminSubscriptionsRouteName,
      builder: (context, state) => SubscriptionsScreen(),
    ),

    /////////////////////////////////////// Admin Route ///////////////////////////////////////
    GoRoute(
      path: '/admin_dashboard',
      name: AppRouteName.adminDashboardRouteName,
      builder: (context, state) => AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin_companies',
      name: AppRouteName.adminCompaniesRouteName,
      builder: (context, state) => CompaniesScreen(),
    ),
    GoRoute(
      path: '/admin_create_company',
      name: AppRouteName.adminCreateCompanyRouteName,
      builder: (context, state) => CreateCompanyScreen(),
    ),
    GoRoute(
      path: '/admin_categories',
      name: AppRouteName.adminCategoryRouteName,
      builder: (context, state) => CategoriesScreen(),
    ),
    GoRoute(
      path: '/admin_sub_categories',
      name: AppRouteName.adminSubCategoryRouteName,
      builder: (context, state) => SubCategoriesScreen(),
    ),
    GoRoute(
      path: '/admin_create_user',
      name: AppRouteName.adminCreateUserRouteName,
      builder: (context, state) => CreateUserScreen(),
    ),
    GoRoute(
      path: '/admin_users_list',
      name: AppRouteName.adminUsersListRouteName,
      builder: (context, state) => UsersListScreen(),
    ),

    /////////////////////////////////////// User Route ///////////////////////////////////////
    // GoRoute(
    //   path: '/user_dashboard',
    //   name: AppRouteName.userDashboardRouteName,
    //   builder: (context, state) => UserDashboardScreen(),
    // ),
    GoRoute(
      path: '/user_dashboard',
      name: AppRouteName.userDashboardRouteName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          // transitionDuration: const Duration(milliseconds: 1000),
          fullscreenDialog: true,
          child: UserDashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(
                curve: Curves.easeInOutCirc,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/user_post_feed',
      name: AppRouteName.userPostFeedRouteName,
      builder: (context, state) => PostFeedScreen(),
    ),
    GoRoute(
      path: '/user_create_issue',
      name: AppRouteName.userCreateIssueRouteName,
      builder: (context, state) => CreateIssueScreen(),
    ),
    GoRoute(
      path: '/user_my_issue',
      name: AppRouteName.userMyTasksRouteName,
      builder: (context, state) => MyTaskScreen(),
    ),
    GoRoute(
      path: '/user_issue_detail',
      name: AppRouteName.userIssueDetailRouteName,
      builder: (context, state) => IssueDetailsScreen(),
    ),
  ],
);
