import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:thiran_tech/core/services/data/network/network_api_services.dart';

final emailProvider = Provider((ref) {
  return EmailService();
});

class EmailService {
  Future<bool> sendEmail(String accessToken, String recipient, String subject, String body, {String? htmlBody}) async {
    final smtpServer = gmailSaslXoauth2('ruvser03@gmail.com', accessToken);

    final message = Message()
      ..from = Address('ruvser03@gmail.com', 'Pursoth')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    if (htmlBody != null) {
      message.html = htmlBody;
    }

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      return false;
    }
  }

  String createHtmlTable(List<Map<String, dynamic>> errorTransactions) {
    final buffer = StringBuffer();
    buffer.writeln('<table border="1" style="width: 100%; border-collapse: collapse;">');
    buffer.writeln('<tr style="background-color: #007BFF; color: white; text-align: center;">');
    buffer.writeln('<th style="padding: 8px;">Transaction ID</th>');
    buffer.writeln('<th style="padding: 8px;">Description</th>');
    buffer.writeln('<th style="padding: 8px;">Status</th>');
    buffer.writeln('<th style="padding: 8px;">Transaction Time</th>');
    buffer.writeln('</tr>');

    for (final transaction in errorTransactions) {
      buffer.writeln('<tr style="background-color: ${errorTransactions.indexOf(transaction) % 2 == 0 ? '#f2f2f2' : 'white'}; text-align: center;">');
      buffer.writeln('<td style="padding: 8px;">${transaction['transaction_id']}</td>');
      buffer.writeln('<td style="padding: 8px;">${transaction['transaction_description']}</td>');
      buffer.writeln('<td style="padding: 8px;">${transaction['transaction_status']}</td>');
      buffer.writeln('<td style="padding: 8px;">${transaction['transaction_time']}</td>');
      buffer.writeln('</tr>');
    }

    buffer.writeln('</table>');
    return buffer.toString();
  }

  Future<bool> sendErrorEmail(List<Map<String, dynamic>> errorTransactions) async {
    const clientId = '';
    const clientSecret = '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';
    const refreshToken = '1//04m0GcOFcefVRCgYIARAAGAQSNwF-L9IrDX-f0XG0FJkir3xUMbQZSTSJN9LnAXWCMaMx9MEmacO821UKK4F0xDraWuFVACD7oHA';
    const recipient = 'gokulhariharan005@gmail.com';
    const subject = 'Failed Transaction Details';
    const body = 'This is a test email.';

    try {
      var data = {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      };

      final accessToken = await NetworkApiServices().post(data);

      final htmlBody = createHtmlTable(errorTransactions);
      bool flag = await sendEmail(accessToken, recipient, subject, body, htmlBody: htmlBody);
      if (flag) {
        print('Email sent successfully');
        return true;
      } else {
        print('Email not  sent');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
    return false;
  }
}
