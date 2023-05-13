import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension TypographyUtils on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => GoogleFonts.openSansTextTheme(theme.textTheme);

  TextStyle? get labelLarge => textTheme.labelLarge?.copyWith(
        color: Colors.black,
      );
}
