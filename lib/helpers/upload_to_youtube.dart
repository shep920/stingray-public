// import 'dart:io';
// import 'package:googleapis/youtube/v3.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import "package:googleapis_auth/auth_io.dart";

// class Upload {
//   static Future<String> toYouTube(File file) async {
//     final _credentials = auth.ServiceAccountCredentials.fromJson({
//       "type": "service_account",
//       "project_id": "hero-cbfc8",
//       "private_key_id": "a8800583a36bc5f8ff00f44f293dc50f134adeb3",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCsJICCd94I2Mt1\nHEh1N0/bfKpqdPfmqa8YrgRXQLR01vOkQIbRDOuxKRkb39VwkAeNYspfjBx/mEYC\n4fohNj7qkT5OaRIKEPL6rU3OJp8oQfOauM/05Yi1TkP4MrZ64TyscsJVjjkK6GF6\nzNFx3GtXItS85tlrJnpHbtbnvQcBFjbYFR49CK9jMa/WJAofQuFuxn3mpWD77++g\nPcp6vAb7lLsK7RL1RqCP0LzxAzOvxc9/Fn7Gv9B4VXF9GeGMmkDELSRbqYEk/Jc0\nVmqKO1ZTyhIqWtTzLYYiIBzYMI3sDZcdzmrMnYNcJP8aJynQW2RQ/MGnvhmRI1Qb\nekmor2aJAgMBAAECggEACqlcGDiKVOvwdflhd3kMhiCLgXprHCsoQBQPCsRkKNRj\nVKn2b54oPtm3x2UumAEjppsWw6Iu5awtseIDFumALhD+1eZmCp+QHPx81CbKNrkW\n+F836ggJVolZZlblvGiU1G1rIddkKwvHdc6XrkCjmUr7+BMoJh3E9wWjY8juVR/L\n5LamA25M2pLtT7Q1/nfM9Ck3HJIyHlENx/Fj1Mcqvjn8CJZYuGwZSfSHfH/FHlzo\nGslD3z9XqF+spRD9rgUAXROA0DdRAEHn0eQoFrMJmZ5uDhP1BznBju/IjbiXV5Zm\nRxGiwWRW8oCDIy6fijTeZu0J0zc5UqXAxFhzMMJJnQKBgQDtUqdJWD5B1l59iFwH\nzYHz8ZLottsJh+3+GITaG0NZg+o+KQ8nHcrjFuk2mwkbVUSjFoZWFhBoUQPYn3pL\nbTb3/vj9RTJnSPLsno1Vxr0Q50riGoLWLwxg0rm6G3CnyTo47+KyeZG6/g97ZqvI\nBUbUABlaRkHDIg1699oJgr1t7wKBgQC5sKkiZsH1aQPkwFiVezQQ/+8yr2yTlt/R\nDKmglELIf+HYvSLmbqxCSzC4iZ1oINt1tv+f7DWgDR+1M0uHzhxuy+XDlNlJcONg\nzmxu1hdCawtZZ1IXajSl3ZnBsECu8FK202vTYSrq8JDmzYt7eTCnieAj0S3YTXbi\n6KRhHtnrBwKBgGXv2LciViuFXrTg+1bGqQkVPJsE3/SqFEnOUlI036r1hIoKrN2K\naHk+gBHaagD5kS/UHwOfGpEUK2jCp476bF/9fwmazVmb9ew49lBfuxolnv6bkJNb\nRh/Yo7oSy0LmpkGKmH88xKHjOtcwdJzH13J8UGd8QgcE+3FUQK1RIPi1AoGAAlrC\nGkSRSwpU2U6zENoqE9ka8FqXFtv/5IezkuyuWBp/A5+KVL+sgX6wlHZyP4LDJZ/3\nZ9C38VqZP1PyLjun0qPVOwClLLA4wd58M3+VdesjjrOnr9JR7pR7wZ/5gf5cHiNa\nJ6kAwU/hlnuevCcSPd2asPmTCj4ZNtFaXDzm6HsCgYA7jUThdKNafAAa1mntTOQh\nxeDlYEb0wJiYIbscMaCtKnU+J4T1fAHEiQX5s3BZRSthY74udcFpqr8kQ2nS71OY\nbBxqn8BCfkZsW6P8JRhcUcQE6pSSEijDUNIw6irBh+n6qzlWQxvhOgT4tS967wdf\ndBAzhn9HFsJDpTIVtQi2RA==\n-----END PRIVATE KEY-----\n",
//       "client_email": "stringrayyoutube@hero-cbfc8.iam.gserviceaccount.com",
//       "client_id": "100231002792145600514",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/stringrayyoutube%40hero-cbfc8.iam.gserviceaccount.com"
//     });

//     final scopes = ['https://www.googleapis.com/auth/youtube.upload'];

//     AuthClient client = await clientViaServiceAccount(_credentials, scopes);

//     YouTubeApi youtube = YouTubeApi(client);

//     // Upload the video to YouTube
//     final media = Media(
//       file.openRead(),
//       file.lengthSync(),
//     );

//     final video = Video();
//     video.snippet = VideoSnippet();
//     video.snippet!.title = 'My Video Title';
//     video.snippet!.description = 'My Video Description';
//     video.status = VideoStatus();
//     video.status!.privacyStatus = 'unlisted';

//     List<String> parts = ['snippet', 'status'];

//     //upload the video to youtube
//     final videoResponse = await youtube.videos.insert(video, parts);

//     //get the video id
//     String videoId = videoResponse.id!;

//     //get the video url
//     String videoUrl = 'https://www.youtube.com/watch?v=$videoId';

//     print(videoUrl);

//     return videoUrl;
//   }
// }
