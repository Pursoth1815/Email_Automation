import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

final emailProvider = Provider((ref) {
  return EmailService();
});

class EmailService {
  Future<String> getAccessToken(String clientId, String clientSecret, String refreshToken) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        'https://oauth2.googleapis.com/token',
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      } else {
        throw Exception('Failed to obtain access token: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error response data: ${(e as DioException).response?.data}');
      print('Error response headers: ${(e).response?.headers}');
      throw Exception('Error obtaining access token: $e');
    }
  }

  Future<void> sendEmail(String accessToken, String recipient, String subject, String body, {String? htmlBody}) async {
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
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
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

  Future<void> sendErrorEmail(List<Map<String, dynamic>> errorTransactions) async {
    const clientId = '';
    const clientSecret = '';
    const refreshToken = '';
    const recipient = 'pursothpersonal@gmail.com';
    const subject = 'Failed Transaction Details';
    const body = 'This is a test email.';

    try {
      final accessToken = await getAccessToken(clientId, clientSecret, refreshToken);
      final htmlBody = createHtmlTable(errorTransactions);
      await sendEmail(accessToken, recipient, subject, body, htmlBody: htmlBody);
      print('Email sent successfully');
    } catch (e) {
      print('Error: $e');
    }
  }
}
