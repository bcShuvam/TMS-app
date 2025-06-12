import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/custom_audio_provider.dart';
import 'package:task_management_system/providers/user_provider/issue/issue_provider.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/button/custom_elevated_button.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/dropdown/custom_dropdown.dart';
import 'package:task_management_system/widgets/text_from_field/custom_text_form_field.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/custom_image_provider.dart';
import '../../../routes/app_route_name.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/texts/custom_text.dart';

class CreateIssueScreen extends StatefulWidget {
  const CreateIssueScreen({super.key});

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {
  IssueProvider? issueProvider;
  AuthProvider? authProvider;
  @override
  void initState() {
    issueProvider = Provider.of<IssueProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).getCategories();
    });
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
      tabName: 'Create Issue',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        issueProvider!.getIssues();
        issueProvider!.clearIssueForm();
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouteName.userDashboardRouteName);
      },
    );
  }

  Widget _body() {
    return Consumer<IssueProvider>(
      builder: (context, issueProvider, _) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: CustomContainer(
              applyShadow: true,
              child: Form(
                key: issueProvider.createFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Category',
                      items: issueProvider.categoriesList,
                      value: issueProvider.selectedCategoryName,
                      onChanged: (value) {
                        issueProvider.updateSelectedCategoryName(value!);
                        final selectedIndex =
                            issueProvider.selectedCategoryIndex;
                        final selectedCategoryId = issueProvider.selectedCategory['_id'];
                        issueProvider.getSubCategories(selectedCategoryId);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Sub Category',
                      items: issueProvider.subCategoriesList,
                      value: issueProvider.selectedSubCategoryName,
                      onChanged: (value) {
                        issueProvider.updateSelectedSubCategoryName(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown(
                      labelText: 'Assign to',
                      items: issueProvider.assignIssueList,
                      value: issueProvider.assignedToValue,
                      onChanged: (value) {
                        issueProvider.updateAssignedTo(value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    if(issueProvider.assignedToValue == issueProvider.assignIssueList[1])
                    CustomTextFromField(
                      controller: issueProvider.assignedToUserNameTextController,
                      labelText: 'Assigned to *',
                      readOnly: true,
                      applySuffixIcon: true,
                      suffixIcon: InkWell(
                        onTap: () {
                          issueProvider.getAllCompanyUsers();
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) =>
                                  _assignBottomSheet(context));
                        },
                        child: Icon(FontAwesomeIcons.solidUser),
                      ),
                      onTap: (){
                        issueProvider.getAllCompanyUsers();
                        showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            builder: (context) =>
                                _assignBottomSheet(context));
                      },
                      validator: (value) {
                        return issueProvider.assignedToValue == issueProvider.assignIssueList[1] && value!.isEmpty
                            ? 'Assigned to required'
                            : null;
                      },
                    ),
                    if(issueProvider.assignedToValue == issueProvider.assignIssueList[1])
                    const SizedBox(height: 16),
                    Consumer<CustomImageProvider>(
                      builder: (context, imageProvider, _) {
                        return CustomTextFromField(
                          controller: issueProvider.imageFileTextController,
                          labelText: 'Image',
                          readOnly: true,
                          applySuffixIcon: true,
                          suffixIcon: InkWell(
                            onTap: () {
                              imageProvider.pickImageFromGallery();
                              issueProvider.setImage(imageProvider.imageName);
                              print('Tapped on icon');
                            },
                            child: Icon(FontAwesomeIcons.camera),
                          ),
                          validator: (value) {},
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Consumer<CustomAudioProvider>(
                      builder: (context, audioProvider, _) {
                        return CustomTextFromField(
                          controller: issueProvider.audioFileTextController,
                          labelText: 'Voice Message',
                          readOnly: true,
                          applySuffixIcon: true,
                          suffixIcon: InkWell(
                            onTap: () {
                              audioProvider.recordAudio();
                              // issueProvider.setImage(audioProvider.imageName);
                              print(audioProvider.isRecording ? 'Stop recording' : 'Start recording');
                            },
                            child: Icon(audioProvider.isRecording ? FontAwesomeIcons.pause : FontAwesomeIcons.microphone, color: audioProvider.isRecording ? Colors.red : Colors.black,),
                          ),
                          validator: (value) {},
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: issueProvider.deadLineDateTimeTextController,
                      readOnly: true,
                      labelText: 'Deadline datetime *',
                      applySuffixIcon: true,
                      suffixIcon: InkWell(
                        onTap: () {
                          issueProvider.selectDate(context);
                        },
                        child: Icon(Icons.calendar_month),
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Deadline datetime required' : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFromField(
                      controller: issueProvider.descriptionTextController,
                      labelText: 'Description',
                      minLine: 2,
                      maxLines: 3,
                      validator: (value) {},
                    ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      onPressed: () {
                        issueProvider.createIssue(context);
                      },
                      backgroundColor: CustomColors.primaryColor,
                      width: 1,
                      height: 50,
                      widget: CustomText(text: 'Create', isSubHeading: true),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _assignBottomSheet(BuildContext context) {
    return Consumer<IssueProvider>(
      builder: (context, issueProvider, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: ColoredBox(
            color: CustomColors.primaryWhite,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: CustomTextFromField(
                            controller: issueProvider.searchByNameController,
                            labelText: 'Search username',
                            applySuffixIcon: true,
                            suffixIcon: const Icon(Icons.search),
                            validator: (value) {},
                            onChange: (value) => issueProvider.searchUserName(
                              value!,
                              issueProvider.userList,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: issueProvider.userSearchResult.length,
                      itemBuilder: (context, index) {
                        final user = issueProvider.userSearchResult[index];

                        return GestureDetector(
                          onTap: () {
                            issueProvider.setSelectedAssignedToUserId(user['_id'], user['name']);
                            context.pop();
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 20, color: Colors.blueGrey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomText(
                                          text: user['name'],
                                          isContent: true,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.email, size: 20, color: Colors.teal),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomText(
                                          text: user['email'],
                                          isContent: true,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.business, size: 20, color: Colors.deepPurple),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomText(
                                          text: user['department'],
                                          isContent: true,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.badge, size: 20, color: Colors.orange),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomText(
                                          text: user['designation'],
                                          isContent: true,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
