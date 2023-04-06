import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/static_data/general_profile_data/bars.dart';
import 'package:hero/static_data/general_profile_data/fraternities.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';
import 'package:hero/static_data/general_profile_data/nothing_data.dart';
import 'package:hero/static_data/general_profile_data/places.dart';
import 'package:hero/static_data/profile_data.dart';

class GenerateSimilarInterests {
  static List<Widget> generate(
      {required User localUser,
      required User compareTo,
      required Color defualtColor,
      int? maxLength}) {
    List<Widget> _interests = [];
    if (compareTo.fraternity != '' && compareTo.fraternity != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          child: FaIcon(
              Leadership.fratLeaders.firstWhere(
                  (listFrat) => compareTo.fratPosition == listFrat['value'],
                  orElse: () {
                return Nothing.nothing;
              })['iconData'],
              color: (compareTo.fraternity == localUser.fraternity)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.firstUndergrad != '' && compareTo.firstUndergrad != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          child: FaIcon(
              ProfileData.getUndergrads().firstWhere(
                (listUndergrad) =>
                    compareTo.firstUndergrad == listUndergrad['value'],
                orElse: () => Nothing.nothing,
              )['icon'],
              color: (compareTo.firstUndergrad == localUser.firstUndergrad)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.secondUndergrad != '' &&
        compareTo.secondUndergrad != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          child: FaIcon(
              ProfileData.getUndergrads().firstWhere(
                  (listUndergrad) =>
                      compareTo.secondUndergrad == listUndergrad['value'],
                  orElse: () {
                return Nothing.nothing;
              })['icon'],
              color: (compareTo.secondUndergrad == localUser.secondUndergrad)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.thirdUndergrad != '' && compareTo.thirdUndergrad != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          child: FaIcon(
              ProfileData.getUndergrads().firstWhere(
                (listUndergrad) =>
                    compareTo.thirdUndergrad == listUndergrad['value'],
                orElse: () {
                  return Nothing.nothing;
                },
              )['icon'],
              color: (compareTo.thirdUndergrad == localUser.thirdUndergrad)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }

    if (compareTo.postGrad != '' && compareTo.postGrad != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          child: FaIcon(Icons.school,
              color: (compareTo.postGrad == localUser.postGrad)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }

    if (compareTo.firstStudentOrg != '' &&
        compareTo.firstStudentOrg != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
          child: FaIcon(
              Leadership.leadership.firstWhere(
                (listLeader) =>
                    compareTo.firstStudentOrgPosition == listLeader['value'],
                orElse: () {
                  return Nothing.nothing;
                },
              )['iconData'],
              size: 20,
              color: (compareTo.firstStudentOrg == localUser.firstStudentOrg)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.secondStudentOrg != '' &&
        compareTo.secondStudentOrg != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
          child: FaIcon(
              Leadership.leadership.firstWhere(
                (listLeader) =>
                    compareTo.secondStudentOrgPosition == listLeader['value'],
                orElse: () {
                  return Nothing.nothing;
                },
              )['iconData'],
              size: 20,
              color: (compareTo.secondStudentOrg == localUser.secondStudentOrg)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.thirdStudentOrg != '' &&
        compareTo.thirdStudentOrg != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
          child: FaIcon(
              Leadership.leadership.firstWhere(
                (listLeader) =>
                    compareTo.thirdStudentOrgPosition == listLeader['value'],
                orElse: () {
                  return Nothing.nothing;
                },
              )['iconData'],
              size: 20,
              color: (compareTo.thirdStudentOrg == localUser.thirdStudentOrg)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.favoriteBar != '' && compareTo.favoriteBar != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
          child: FaIcon(
              Bars.bars().firstWhere(
                  (bar) => compareTo.favoriteBar == bar['value'], orElse: () {
                return Nothing.nothing;
              })['iconData'],
              size: 20,
              color: (compareTo.favoriteBar == localUser.favoriteBar)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }
    if (compareTo.favoriteSpot != '' && compareTo.favoriteSpot != 'None') {
      _interests.add(Container(
          margin: EdgeInsets.only(top: 4, bottom: 4, left: 4),
          child: FaIcon(
              Places.places().firstWhere(
                  (bar) => compareTo.favoriteSpot == bar['value'], orElse: () {
                return Nothing.nothing;
              })['iconData'],
              size: 20,
              color: (compareTo.favoriteSpot == localUser.favoriteSpot)
                  ? ExtraColors.highlightColor
                  : defualtColor)));
    }

    if (maxLength != null && _interests.length > maxLength) {
      _interests = _interests.sublist(0, maxLength);
    }

    return _interests;
  }
}
