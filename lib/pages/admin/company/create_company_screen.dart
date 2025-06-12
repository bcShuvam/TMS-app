import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/admin_provider/company/company_provider.dart';
import '../../../routes/app_route_name.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';
import '../../../widgets/container/custom_container.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../../widgets/text_from_field/custom_text_form_field.dart';
import '../../../widgets/texts/custom_text.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  CompanyProvider? _companyProvider;

  @override
  void initState() {
    super.initState();
    _companyProvider = Provider.of<CompanyProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      tabName: _companyProvider!.isEdit ? 'Update Company' : 'Create Company',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        GoRouter.of(context).pushReplacementNamed(AppRouteName.adminCompaniesRouteName);
      },
    );
  }

  Widget _body() {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, _) {
        return Center(
          child: SingleChildScrollView(
            child: CustomContainer(
              verticalMargin: 24,
              child: Form(
                key: companyProvider.formKey,
                child: Column(
                  children: [
                    CustomText(text: 'Company Details', isHeading: true),
                    const SizedBox(height: 24),
                    CustomTextFromField(
                      controller: companyProvider.companyNameTextController,
                      labelText: 'Company Name *',
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Company Name is required'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: companyProvider.companyLogoTextController,
                      labelText: 'Company Logo *',
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: companyProvider.emailTextController,
                      labelText: 'Email *',
                      validator: (value) {
                        return value!.isEmpty ? 'Email is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: companyProvider.contactTextController,
                      labelText: 'Contact *',
                      validator: (value) {
                        return value!.isEmpty ? 'Contact is required' : value.length < 10 ? 'contact number length must be 10' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: companyProvider.addressTextController,
                      labelText: 'Address *',
                      validator: (value) {
                        return value!.isEmpty ? 'Address is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Industry Type *',
                      items: companyProvider.industryList,
                      value: companyProvider.selectedIndustry,
                      onChanged:
                          (newValue) =>
                          companyProvider.setSelectedIndustry(newValue!),
                    ),
                    SizedBox(
                      height:
                      companyProvider.selectedIndustry == 'Others' ? 16 : 0,
                    ),
                    if (companyProvider.selectedIndustry == 'Others')
                      CustomTextFromField(
                        controller: companyProvider.industryTypeTextController,
                        labelText: 'Industry *',
                        applySuffixIcon: true,
                        validator: (value) {
                          return value!.isEmpty ? 'Industry is required' : null;
                        },
                      ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: companyProvider.websiteTextController,
                      labelText: 'Website *',
                      validator: (value) {
                        return value!.isEmpty ? 'Website is required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      // obscure: companyProvider.obscure,
                      controller: companyProvider.descriptionTextController,
                      labelText: 'Description',
                      minLine: 2,
                      maxLines: 3,
                      applySuffixIcon: true,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      onPressed: () {
                        companyProvider.isEdit ? companyProvider.updateCompany(context) : companyProvider.onTapCreate(context);
                      },
                      width: 1,
                      height: 50,
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(text: companyProvider.isEdit ? 'Update' : 'Create', isSubHeading: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
