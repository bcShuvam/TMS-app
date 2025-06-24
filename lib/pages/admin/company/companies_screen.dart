import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/admin_provider/company/company_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../../themes/custom_colors.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/container/custom_container.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CompanyProvider>(context, listen: false).getAllCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(),
      floatingActionButton: _floatingButton(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: 'Companies',
      showLeading: true,
      applyShadow: true,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      leadingIconColor: Colors.black,
      onTapLeadingIcon: () {
        GoRouter.of(context).pushReplacementNamed(AppRouteName.adminDashboardRouteName);
      },
    );
  }

  Widget _floatingButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        GoRouter.of(context).pushNamed(AppRouteName.adminCreateCompanyRouteName);
      },
      icon: const Icon(FontAwesomeIcons.plus, color: Colors.black),
      label: CustomText(text: "Add Company", isContent: true,),
      backgroundColor: CustomColors.primaryColor,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _body() {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, _) {
        final companies = companyProvider.companies;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomContainer(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'All Registered Companies',
                    isHeading: true,
                  ),
                  const SizedBox(height: 16),
                  companies.isEmpty
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CustomText(
                        text: "No companies found!",
                        isSubHeading: true,
                      ),
                    ),
                  )
                      : RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        companyProvider.getAllCompanies();
                      },
                        child: ListView.separated(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: companies.length,
                                            separatorBuilder: (_, __) => const Divider(height: 24),
                                            itemBuilder: (context, index) {
                        final company = companies[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: CustomColors.primaryWhite,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: '${index + 1}.',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: CustomText(
                                  text: company['title'] ?? 'N/A',
                                  isSubHeading: true,
                                  maxLines: 3,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Tooltip(
                                      message: "Edit Company",
                                      child: IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                        onPressed: () {
                                          // print('Edit Company: ${company['title']}');
                                          // print(company);
                                          companyProvider.onTapEdit(context, company);
                                          // Pass ID or data if needed
                                          GoRouter.of(context).pushNamed(AppRouteName.adminCreateCompanyRouteName);
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Delete Company",
                                      child: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () {
                                          print('Delete Company: ${company['title']}');
                                          print('Delete Company: ${company['_id']}');
                                          // companyProvider.deleteCompany(context, company['_id']);
                                          // Confirm deletion
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text("Confirm Deletion"),
                                              content: Text("Are you sure you want to delete ${company['name']}?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    companyProvider.deleteCompany(context, company['_id']);
                                                  },
                                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                                            },
                                          ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
