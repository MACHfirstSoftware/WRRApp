import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HowToEnterPage extends StatelessWidget {
  const HowToEnterPage({Key? key}) : super(key: key);

  final String kHtml = """
<p style="text-align: left;"><strong><span style="color: rgb(239, 239, 239);">How To Enter the WI Big Buck Contest:</span></strong></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">Entering the Wisconsin Big Buck Contest is fast and simple. Participation in the contest will provide you the opportunity to win cash and prizes from several of the best brands in the hunting industry. To enter, you must first have downloaded the Premium version of the Wisconsin Rut Report App. This is a cost of \$29.99 and ultimately pays your entry fee into the contest.&nbsp;</span></p>
<a href="https://wisconsinrutreport.com/contest/">https://wisconsinrutreport.com/contest/</a>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">Once you&rsquo;re registered for the contest, it&rsquo;s time to hunt! Upon harvesting a buck that you would like to enter into the contest, you will have to visit our website and provide the following information.</span></p>
<ul>
    <li style="text-align: left; color: rgb(239, 239, 239);">DNR Harvest Authorization</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">County of Harvest</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">Day and Time of Harvest&nbsp;</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">What Weapon was Used</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">Overall Inches of Inside Spread with a Photo</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">Length of Main Beams with a Photo</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">Number of Tines</li>
    <li style="text-align: left; color: rgb(239, 239, 239);">Measurements of Each Tine Including Brow Tines with a Photo</li>
</ul>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);"><strong>Win Cash and Prizes!</strong></span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);"><u>Zone 1 Archery</u></span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">1st &nbsp; &nbsp; &nbsp; \$2,500.00</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">2nd &nbsp; &nbsp; &nbsp;Mathews V3X Bow&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">3rd &nbsp; &nbsp; &nbsp; Ozonics HR500</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">4th &nbsp; &nbsp; &nbsp; Seven Oakes Taxidermy Shoulder Mount</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">5th &nbsp; &nbsp; &nbsp; Vortex Viper HD 3000 Range Finder&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">6th &nbsp; &nbsp; &nbsp; Cuddeback Trail Camera</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);"><u>Zone 1 Firearm</u></span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">1st &nbsp; &nbsp; &nbsp; \$2,500.00</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">2nd &nbsp; &nbsp; &nbsp;Jon Boat (Brand/Model)?</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">3rd &nbsp; &nbsp; &nbsp; Vortex Viper HS 2.5- 10x44 Scope</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">4th &nbsp; &nbsp; &nbsp; Seven Oakes Taxidermy Shoulder Mount</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">5th &nbsp; &nbsp; &nbsp; Ozonics HR500&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">6th &nbsp; &nbsp; &nbsp; Cuddeback Trail Camera</span></p>
<p style="text-align: left;"><br></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);"><u>Zone 2 Archery</u></span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">1st &nbsp; &nbsp; &nbsp; \$2,500.00</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">2nd &nbsp; &nbsp; &nbsp;Mathews V3X Bow&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">3rd &nbsp; &nbsp; &nbsp; Ozonics HR500</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">4th &nbsp; &nbsp; &nbsp; Seven Oakes Taxidermy Shoulder Mount</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">5th &nbsp; &nbsp; &nbsp; Cuddeback Trail Camera&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">6th &nbsp; &nbsp; &nbsp; Black Widow Scrape Kit and Nose Jammer 4 Pack</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);"><u>Zone 2 Firearm</u></span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">1st &nbsp; &nbsp; &nbsp; Redneck 6x7 Big Country Platinum Blind&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">2nd &nbsp; &nbsp; &nbsp;Jon Boat (Brand/Model?)</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">3rd &nbsp; &nbsp; &nbsp; Seven Oakes Taxidermy Shoulder Mount</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">5</span><span style="color: rgb(239, 239, 239);">th &nbsp; &nbsp; &nbsp; Ozonics HR500 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">5th &nbsp; &nbsp; &nbsp; Vortex Viper Binoculars 10x42&nbsp;</span></p>
<p style="text-align: left;"><span style="color: rgb(239, 239, 239);">6th &nbsp; &nbsp; &nbsp; Cuddeback Trail Camera</span></p>
<p style="text-align: justify;"><span style="color: rgb(239, 239, 239);">&nbsp;</span></p>
""";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        physics: const BouncingScrollPhysics(),
        child: HtmlWidget(
          kHtml,
        ),
      ),
    );
  }
}
