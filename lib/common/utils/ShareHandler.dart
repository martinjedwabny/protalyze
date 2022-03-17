import 'package:share_plus/share_plus.dart';
class ShareHandler {
  static void share(String text, Function onError, Function onSuccess){
    Share.share(text)
      .then((value) => onSuccess(value))
      .catchError(onError);
  }
}