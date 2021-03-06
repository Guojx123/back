import 'package:flutter/material.dart';

/// Single time change notifier
/// to be used with Selector Widget on individual variables of interest
class TimeModel extends ChangeNotifier {
  int _h1 = 0, _h2 = 0, _m1 = 0, _m2 = 0, _s1 = 0, _s2 = 0;
  bool _isPm = false;
  int _day = 0;

  int get h1 => _h1;
  set h1(int a) {
    if (_h1 != a) {
      _h1 = a;
      notifyListeners();
    }
  }

  int get h2 => _h2;
  set h2(int a) {
    if (_h2 != a) {
      _h2 = a;
      notifyListeners();
    }
  }

  int get m1 => _m1;
  set m1(int a) {
    if (_m1 != a) {
      _m1 = a;
      notifyListeners();
    }
  }

  int get m2 => _m2;
  set m2(int a) {
    if (_m2 != a) {
      _m2 = a;
      notifyListeners();
    }
  }

  int get s1 => _s1;
  set s1(int a) {
    if (_s1 != a) {
      _s1 = a;
      notifyListeners();
    }
  }

  int get s2 => _s2;
  set s2(int a) {
    if (_s2 != a) {
      _s2 = a;
      notifyListeners();
    }
  }

  bool get isPm => _isPm;
  set isPm(bool a) {
    if (a != _isPm) {
      _isPm = a;
      notifyListeners();
    }
  }

  int get day => _day;
  set day(int d) {
    if (_day != d) {
      _day = d;
      notifyListeners();
    }
  }

  void updateTime(DateTime d, bool is24hrFormat) {
    isPm = d.hour > 11;
    day = d.day;
    if (is24hrFormat) {
      h1 = d.hour ~/ 10;
      h2 = d.hour % 10;
    } else {
      if (d.hour > 12) {
        h1 = (d.hour - 12) ~/ 10;
        h2 = (d.hour - 12) % 10;
      } else if (d.hour == 0) {
        h1 = 1;
        h2 = 2;
      } else {
        h1 = d.hour ~/ 10;
        h2 = d.hour % 10;
      }
    }
    m1 = d.minute ~/ 10;
    m2 = d.minute % 10;
    s1 = d.second ~/ 10;
    s2 = d.second % 10;
  }
}
