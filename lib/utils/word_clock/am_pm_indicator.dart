import 'package:back/utils/word_clock/time_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'digit.dart';

/// Shows AM/PM if format isn't 24 hr
class AmPmIndicator extends StatelessWidget {
  final bool show;

  const AmPmIndicator(this.show, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (show) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Selector<TimeModel, bool>(
              selector: (_, b) => b.isPm,
              builder: (_, isPm, child) => SizedBox(
                width: MediaQuery.of(context).size.width / 10,
                child: Digit(
                  null,
                  simpleString: isPm ? 'P' : 'A',
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 10,
              child: const Digit(
                null,
                simpleString: 'M',
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
