
import 'package:intl/intl.dart';

String getHumanReadableDate(int milliseconds) {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm a');

  return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}