import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

final emailProvider = Provider((ref) {
  return EmailService();
});

class EmailService {
  Future sendEmailv2(dynamic errorTransactions) async {
    final smtpServer = SmtpServer(
      'smtp.office365.com',
      port: 587,
      ssl: false,
      ignoreBadCertificate: false,
      username: 'kp1518@outlook.com',
      password: "Pursoth@123#\$",
    );

    final email = createHtmlTable('kp1518@outlook.com', 'List Of Failed Transaction', errorTransactions);

    final message = Message()
      ..from = Address("kp1518@outlook.com")
      ..recipients.add("pursothpersonal@gmail.com")
      ..recipients.add("pursoth.v.08@gmail.com")
      ..subject = 'Failed Transaction History'
      ..html = email;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
      return false;
    } catch (e) {
      print('Message not sent. \n${e.toString()}');
      return false;
    }
  }

  String createHtmlTable(String from, String subject, List<Map<String, dynamic>> errorTransactions) {
    final buffer = StringBuffer();
    buffer.writeln('<html><body>');
    buffer.writeln('<p>From: $from</p>');
    buffer.writeln('<h3>Subject: $subject</h3>');
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
    buffer.writeln('</body></html>');
    return buffer.toString();
  }
}
