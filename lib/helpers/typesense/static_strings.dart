import 'package:hero/models/user_model.dart';
import 'package:hero/static_data/general_profile_data/fraternities.dart';

class StaticTSStrings {
  static String setBlockedUsers(User user) {
    List<dynamic> blocks = user.blockedUserIds + user.blockedBy;
    String ignore = 'typsenseId:!=[';
    if (blocks.isEmpty) {
      ignore = '';
    }
    if (blocks.isNotEmpty) {
      for (String block in blocks) {
        //add block in the form 'block,'. If it is the last block, do 'block]'
        if (block == blocks.last) {
          ignore += '$block]';
        } else {
          ignore += '$block,';
        }
      }
    }
    return ignore;
  }

  static String setBlockedWaveUsers(User user) {
    List<dynamic> blocks = user.blockedUserIds + user.blockedBy;
    String ignore = 'senderId:!=[';
    if (blocks.isEmpty) {
      ignore = '';
    }
    if (blocks.isNotEmpty) {
      for (String block in blocks) {
        //add block in the form 'block,'. If it is the last block, do 'block]'
        if (block == blocks.last) {
          ignore += '$block] &&';
        } else {
          ignore += '$block,';
        }
      }
    }
    return ignore;
  }

  static String setIgnoreUsers(List<User?>? loaded) {
    String _ignore = '';
    if (loaded != null) {
      _ignore = 'typsenseId:!=[';
      for (User? user in loaded) {
        if (user != null) {
          //if it is the last user, do 'user.id]'
          if (user == loaded.last) {
            _ignore += '${user.id}]';
          } else {
            _ignore += '${user.id},';
          }
        }
      }
    }
    return _ignore;
  }

  static String setSimilarUsers(User user) {
    String frats = Fraternities.tsFrats();
    String similar = '';
    if (user.firstUndergrad != '') {
      similar += 'firstUndergrad:${user.firstUndergrad} || ';
    }
    if (user.secondUndergrad != '') {
      similar += 'secondUndergrad:${user.secondUndergrad} || ';
    }
    if (user.thirdUndergrad != '') {
      similar += 'thirdUndergrad:${user.thirdUndergrad} || ';
    }
    if (user.postGrad != '') {
      similar += 'postGrad:${user.postGrad} || ';
    }
    if (user.firstStudentOrg != '') {
      similar += 'firstStudentOrg:${user.firstStudentOrg} || ';
    }
    if (user.secondStudentOrg != '') {
      similar += 'secondStudentOrg:${user.secondStudentOrg} || ';
    }
    if (user.thirdStudentOrg != '') {
      similar += 'thirdStudentOrg:${user.thirdStudentOrg} || ';
    }
    if (user.fraternity != '') {
      similar += '$frats || ';
    }
    if (user.favoriteBar != '') {
      similar += 'favoriteBar:`${user.favoriteBar}` || ';
    }
    if (user.favoriteSpot != '') {
      similar += 'favoriteSpot:`${user.favoriteSpot}` || ';
    }
    if (user.assosiatedDorm != '') {
      similar += 'assosiatedDorm:${user.assosiatedDorm} || ';
    }
    if (user.worstDorm != '') {
      similar += 'worstDorm:${user.worstDorm} || ';
    }
    if (user.intramuralSport != '') {
      similar += 'intramuralSport:${user.intramuralSport} || ';
    }

    //remove the last ' || ' if the string is not ''
    if (similar != '') {
      similar = similar.substring(0, similar.length - 4);
    }

    return similar;
  }

  static String ignoreWaves(List<String> waveIds) {
    String ignore = '';
    
    if (waveIds.isNotEmpty) {
      ignore = '(typesenseId:!=[';
    
      for (int i = 0; i < waveIds.length; i++) {
        if (i == waveIds.length - 1) {
          ignore += waveIds[i] + "]) &&";
        } else {
          ignore += waveIds[i] + ",";
        }
      }
    }
    return ignore;
  }
}
