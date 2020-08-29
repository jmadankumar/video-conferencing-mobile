import 'package:http/http.dart' as http;
import 'package:video_conferening_mobile/util/user.util.dart';

final String MEETING_API_URL = 'https://api.meetx.madankumar.me/meeting';
// final String MEETING_API_URL = 'http://10.0.2.2:8081/meeting';

Future<http.Response> startMeeting() async {
  var userId = await loadUserId();
  var response =
      await http.post('$MEETING_API_URL/start', body: {'userId': userId});
  return response;
}

Future<http.Response> joinMeeting(String meetingId) async {
  var response = await http.get('$MEETING_API_URL/join?meetingId=$meetingId');
  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  }
  throw UnsupportedError('Not a valid meeting');
}
