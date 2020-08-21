import 'package:http/http.dart' as http;
import 'package:video_conferening_mobile/util/user.util.dart';

Future<http.Response> startMeeting() async {
  var userId = await loadUserId();
  var response = await http
      .post('http://10.0.2.2:8081/meeting/start', body: {'userId': userId});
  return response;
}
