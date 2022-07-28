import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/widgets/default_appbar.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  final String kHtml = """
<p style="text-align: justify;"><strong><span style="color: rgb(239, 239, 239);">COPYRIGHT AND TRADEMARKS AND PATENTS</span></strong></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">Unless otherwise noted, product names, designs, logos, titles, text, images, animations, color combinations, button shapes, layout, audio, video, and HTML code within this app are the trademarks, service marks, trade names, copyrights, or other property of Wisconsin Rut Report Copyright 2022. Wisconsin Rut Report ALL RIGHTS RESERVED. All other unregistered and registered trademarks are the property of their respective owners. Nothing contained on this app should be construed as granting, by implication, estoppel, or otherwise, any license or right to distribute, modify, transmit, use, reuse, or re-post any of Wisconsin Rut Report Intellectual Property displayed on this app without the express written permission of Wisconsin Rut Report.</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);"><strong>NO WARRANTIES AND LIMITS OF LIABILITIES</strong></span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">Information and documents provided on this app are provided &quot;as is&quot; without warranty of any kind, either express or implied, including without limitation warranties of merchantability, fitness for a particular purpose, and non-infringement. Wisconsin Rut Report uses reasonable efforts to include accurate and up-to-date information on this app; it does not, however, make any warranties or representations as to its accuracy or completeness. Wisconsin Rut Report periodically adds, changes, improves, or updates the information and documents on this app without notice. Wisconsin Rut Report assumes no liability or responsibility for any errors or omissions in the content of this app. Your use of this app is at your own risk. Under no circumstances and under no legal theory shall Wisconsin Rut Report, or any other party involved in creating, producing, or delivering this app&rsquo;s contents be liable to you or any other person for any indirect, direct, special, incidental, or consequential damages arising from your access to, or use of, this app.</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);"><strong>MAKING PURCHASES</strong></span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">If you wish to make purchases of products or services described on this app, you may be asked to supply certain information, including but not limited to credit card or other payment information. You agree that all information that you provide here will be accurate, complete and current. You agree to pay all charges incurred by users of your account and credit card or other payment mechanism at the prices in effect when such charges are incurred. Moreover, you agree to review and to comply with the terms and conditions of any specific agreement that you enter into with Wisconsin Rut Report in connection with the purchase of any product or service.</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);"><strong>COMMUNICATIONS WITH THIS APP</strong></span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">You are encouraged to communicate with this site where applicable. You are prohibited from transmitting any unlawful, threatening, libelous, defamatory, obscene, scandalous, inflammatory, pornographic, or profane material or any material that could constitute or encourage conduct that would be considered a criminal offense, give rise to civil liability, or otherwise violate any law. Wisconsin Rut Report will fully cooperate with any law enforcement authorities or court order requesting or directing Wisconsin Rut Report to disclose the identity of or help identify or locate anyone transmitting any such information or materials. Although Wisconsin Rut Report is under no obligation to do so and assumes no responsibility or liability arising from the content of any such locations nor for any error, defamation, libel, slander, omission, falsehood, obscenity, pornography, profanity, danger, or inaccuracy contained in any information within such locations on this app. Wisconsin Rut Report assumes no responsibility or liability for any actions or communications by you or any unrelated third party within or outside of this app. Wisconsin Rut Report reserves the right to modify or remove any and all information posted to its web sites.</span></p>
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70.h,
        title: const DefaultAppbar(title: "Terms & Conditions"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          physics: const BouncingScrollPhysics(),
          child: HtmlWidget(
            kHtml,
          ),
        ),
      ),
    );
  }
}
