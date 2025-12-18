import 'package:share_plus/share_plus.dart';

class GCShareFile {
  static Future<void> share(
      String path, {
        String title = '',
        String subject = '',
        String text = '',
      }) async {
    await Share.shareXFiles(
      [XFile(path)],
      text: text.isNotEmpty ? text : null,
      subject: subject.isNotEmpty ? subject : null,
    );
  }
}
