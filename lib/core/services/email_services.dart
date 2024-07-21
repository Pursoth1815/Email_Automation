import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Define the provider for sending error emails
final emailProvider = Provider((ref) {
  return EmailService();
});

class EmailService {
  Future<void> sendErrorEmail(
      List<Map<String, dynamic>> errorTransactions) async {
    final smtpServer = gmail('ruvser03@gmail.com', 'ruvser03');

    final message = Message()
      ..from = Address('ruvser03@gmail.com', 'Pursoth')
      ..recipients.add('gokulhariharan005@gmail.com')
      ..subject = 'Error Transactions Report'
      ..text =
          'Here are the error transactions:\n\n${errorTransactions.map((e) => e.toString()).join('\n')}';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.toString()}');
    }
  }
}
