import 'dart:developer' as log1;
import 'dart:math';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
// import 'package:thai_date_formatter/thai_date_formatter.dart';

final tzAsiaBangkok = tz.getLocation('Asia/Bangkok');

String dateFormat(DateTime? date, {String format = 'dd/MM/y', String local = 'th', int addDays = 0}) {
  // format: dd/MM/yyyy kk:mm:ss
  // format: dd/MM/y kk:mm:ss
  if(date == null) return '';

  if(addDays > 0){
    date = date.add(Duration(days: addDays));
  }else if(addDays < 0){
    date = date.subtract(Duration(days: addDays.abs()));
  }

  date = tz.TZDateTime.from(date, tzAsiaBangkok);
  if (local == 'th') {
    return DateFormat(format, local).format(date.copyWith(year: date.year + 543));
  } else {
    return DateFormat(format).format(date);
  }
}

String priceFormat(double? num, LanguageController lController,
  { int digits = 2, bool showSymbol = true, trimDigits = false }) {
  if (num == null) {
    return '';
  } else {
    final symbol = lController.usedCurrency?.icon ?? lController.defaultCurrency?.icon ?? '฿';

    // if (vat > 0) {
    //   num += num * vat / 100;
    // }
    // digits = 4;
    if (digits > 0) {
      num = (num * pow(10, digits)).round().toDouble() / pow(10, digits);
    } else {
      num = (num).round().toDouble();
    }
    String name = showSymbol? symbol: '';

    // return formatNumber(NumberFormat.currency(decimalDigits: digits, name: name).format(num));
    return NumberFormat.currency(decimalDigits: areAllDigitsZero(num) && trimDigits? 0: digits, name: name).format(num);
  }
}

bool areAllDigitsZero(double number) {
  String numberString = number.toString();
  if(!numberString.contains('.0')) return false;
  String? sub = numberString.split('.')[1];
  return sub.split('').every((digit) => digit == '0');
}

String numberFormat(double? num, {int digits = 2}) {
  if (num == null) {
    return '';
  } else {
    if (digits > 0) {
      num = (num * pow(10, digits)).round().toDouble() / pow(10, digits);
    } else {
      num = (num).round().toDouble();
    }

    String name = '';
    return NumberFormat.currency(decimalDigits: digits, name: name).format(num);
  }
}

String reString(String input) {
    if (input.length <= 2 && input.isNotEmpty) return '${input[0]}*';
    
    String firstChar = input[0];
    String lastChar = input[input.length - 1];
    String maskedPart = '*' * (input.length - 2);
    return '$firstChar$maskedPart$lastChar';
  }

