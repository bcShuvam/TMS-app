import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/providers/user_provider/issue/issue_provider.dart';
import 'package:task_management_system/routes/app_route_name.dart';
import 'package:task_management_system/themes/custom_colors.dart';
import 'package:task_management_system/widgets/container/custom_container.dart';
import 'package:task_management_system/widgets/text_from_field/custom_text_form_field.dart';
import 'package:task_management_system/widgets/texts/custom_text.dart';

import '../../../widgets/appbar/custom_appbar.dart';
import '../../../widgets/button/custom_elevated_button.dart';

class IssueDetailsScreen extends StatefulWidget {
  const IssueDetailsScreen({super.key});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      tabName: 'Issue Detail',
      showLeading: true,
      applyShadow: true,
      leadingIconColor: Colors.black,
      leadingIcon: FontAwesomeIcons.arrowLeft,
      onTapLeadingIcon: () {
        GoRouter.of(context).pushNamed(AppRouteName.userDashboardRouteName);
        print('Tapped on Drawer');
      },
    );
  }

  Widget _body() {
    return Consumer<IssueProvider>(
      builder: (context, issueProvider, _) {
        final issue = issueProvider.selectedIssue;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CustomContainer(
            applyShadow: true,
            verticalMargin: 16,
            child: Badge(
              backgroundColor: Colors.transparent,
              label: IconButton(
                onPressed: () => _showDeleteConfirmationDialog(context),
                icon: Icon(FontAwesomeIcons.trash, color: Colors.red, size: 24,),
              ),
              largeSize: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CustomText(
                          text: issue['categoryName'],
                          isHeading: true,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: issue['subCategoryName'],
                          isSubContent: true,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabelValue('Created By', issue['createdByName']),
                  const SizedBox(height: 8),
                  _buildLabelValue('Details', issue['issueDetails']),
                  const SizedBox(height: 8),

                  if ((issue['issueImage'] ?? '').isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        issue['issueImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),

                  _buildAudioSection(issue['issueVoiceMessage']),

                  const SizedBox(height: 16),
                  Divider(),

                  _buildLabelValue('Status', issue['issueStatus']),
                  _buildLabelValue(
                    'Opened',
                    issue['issueOpenDatetime'].toString().split('T')[0],
                  ),
                  _buildLabelValue(
                    'Deadline',
                    issue['issueDeadlineDateTime'].toString().split('T')[0],
                  ),
                  _buildLabelValue(
                    'Assigned At',
                    issue['issueAssignedDatetime'].toString(),
                  ),
                  _buildLabelValue('Comment', issue['comment']),
                  _buildLabelValue('Total Time', issue['totalTime'].toString()),
                  _buildLabelValue(
                    'Approval Status',
                    issue['approvalStatus'].toString(),
                  ),
                  _buildLabelValue('Feedback', issue['feedback'].toString()),
                  const SizedBox(height: 24),
                  CustomElevatedButton(
                    onPressed: () => _showApplyConfirmationDialog(context),
                    backgroundColor: CustomColors.primaryColor,
                    width: double.infinity,
                    height: 50,
                    widget: CustomText(
                      text: 'Apply to Resolve Issue',
                      isSubHeading: true,
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

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: CustomText(text: "$label:", isContent: true, maxLines: 2),
          ),
          Expanded(
            child: CustomText(text: value, isContent: true, maxLines: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection(String audioUrl) {
    if (audioUrl.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: 'No voice messages', isContent: true),
          InkWell(
            onTap: () => print('Tapped on no audio'),
            child: Icon(FontAwesomeIcons.volumeXmark),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            minHeight: 6,
            borderRadius: BorderRadius.circular(100),
            value: 0.05,
            color: CustomColors.primaryColor,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () => print('Tapped on play audio'),
          child: Icon(FontAwesomeIcons.volumeHigh),
        ),
      ],
    );
  }

  void _showApplyConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<IssueProvider>(
          builder: (context, issueProvider, _) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: CustomText(text: 'Confirm Application', isHeading: true),
              content: SingleChildScrollView(
                child: Form(
                  key: issueProvider.applyIssueFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text:
                            'Are you sure you want to apply to resolve this issue?',
                        isContent: true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: 'Please provide a comment:',
                        isContent: true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      CustomTextFromField(
                        controller: issueProvider.commentTextController,
                        minLine: 3,
                        maxLines: 3,
                        labelText: 'Comment *',
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Comment is required'
                              : value.length < 3
                              ? 'Comment must be at least 3 character long'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                CustomElevatedButton(
                  backgroundColor: CustomColors.lightRed,
                  onPressed: () => Navigator.of(context).pop(),
                  widget: CustomText(text: 'Cancel', isContent: true),
                ),
                CustomElevatedButton(
                  backgroundColor: CustomColors.jadeGreen,
                  onPressed: () {
                    issueProvider.applyForIssue(context);
                  },
                  widget: CustomText(
                    text: 'Confirm',
                    color: Colors.white,
                    isContent: true,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<IssueProvider>(
          builder: (context, issueProvider, _) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: CustomText(text: 'Delete Confirm', isHeading: true),
              content: SingleChildScrollView(
                child: Form(
                  key: issueProvider.applyIssueFormKey,
                  child: CustomText(
                    text:
                        'Are you sure you want to delete this issue?',
                    isContent: true,
                    maxLines: 2,
                  ),
                ),
              ),
              actions: [
                CustomElevatedButton(
                  backgroundColor: CustomColors.lightRed,
                  onPressed: () => Navigator.of(context).pop(),
                  widget: CustomText(text: 'Cancel', isContent: true),
                ),
                CustomElevatedButton(
                  backgroundColor: CustomColors.jadeGreen,
                  onPressed: () {
                    issueProvider.deleteIssue(context);
                  },
                  widget: CustomText(
                    text: 'Confirm',
                    color: Colors.white,
                    isContent: true,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
