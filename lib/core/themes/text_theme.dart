import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00528f),
      surfaceTint: Color(0xff0061a7),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0077cc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5d5f5f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff9f9f9),
      onSecondaryContainer: Color(0xff535555),
      tertiary: Color(0xff5e5e5e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9d9d9d),
      onTertiaryContainer: Color(0xff0e1010),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff181c22),
      onSurfaceVariant: Color(0xff404752),
      outline: Color(0xff707783),
      outlineVariant: Color(0xffc0c7d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3137),
      inversePrimary: Color(0xffa1c9ff),
      primaryFixed: Color(0xffd2e4ff),
      onPrimaryFixed: Color(0xff001c37),
      primaryFixedDim: Color(0xffa1c9ff),
      onPrimaryFixedVariant: Color(0xff00487f),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff464747),
      surfaceDim: Color(0xffd7dae2),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3fc),
      surfaceContainer: Color(0xffebeef6),
      surfaceContainerHigh: Color(0xffe5e8f0),
      surfaceContainerHighest: Color(0xffe0e2ea),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004479),
      surfaceTint: Color(0xff0061a7),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0077cc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff414343),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff737575),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff424343),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff747475),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff181c22),
      onSurfaceVariant: Color(0xff3c434e),
      outline: Color(0xff585f6b),
      outlineVariant: Color(0xff747b87),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3137),
      inversePrimary: Color(0xffa1c9ff),
      primaryFixed: Color(0xff0077cc),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005ea3),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff737575),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5b5c5c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff747475),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5b5c5c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dae2),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3fc),
      surfaceContainer: Color(0xffebeef6),
      surfaceContainerHigh: Color(0xffe5e8f0),
      surfaceContainerHighest: Color(0xffe0e2ea),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002342),
      surfaceTint: Color(0xff0061a7),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004479),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff202323),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff414343),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff212223),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff424343),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1d242e),
      outline: Color(0xff3c434e),
      outlineVariant: Color(0xff3c434e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3137),
      inversePrimary: Color(0xffe2edff),
      primaryFixed: Color(0xff004479),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002e54),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff414343),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2b2d2d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff424343),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2c2d2d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dae2),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3fc),
      surfaceContainer: Color(0xffebeef6),
      surfaceContainerHigh: Color(0xffe5e8f0),
      surfaceContainerHighest: Color(0xffe0e2ea),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa1c9ff),
      surfaceTint: Color(0xffa1c9ff),
      onPrimary: Color(0xff00325a),
      primaryContainer: Color(0xff0077cc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xffd4d4d4),
      onSecondaryContainer: Color(0xff3e4040),
      tertiary: Color(0xffc7c6c6),
      onTertiary: Color(0xff2f3031),
      tertiaryContainer: Color(0xff747475),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101419),
      onSurface: Color(0xffe0e2ea),
      onSurfaceVariant: Color(0xffc0c7d4),
      outline: Color(0xff8a919d),
      outlineVariant: Color(0xff404752),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ea),
      inversePrimary: Color(0xff0061a7),
      primaryFixed: Color(0xffd2e4ff),
      onPrimaryFixed: Color(0xff001c37),
      primaryFixedDim: Color(0xffa1c9ff),
      onPrimaryFixedVariant: Color(0xff00487f),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff464747),
      surfaceDim: Color(0xff101419),
      surfaceBright: Color(0xff363940),
      surfaceContainerLowest: Color(0xff0b0e14),
      surfaceContainerLow: Color(0xff181c22),
      surfaceContainer: Color(0xff1c2026),
      surfaceContainerHigh: Color(0xff262a30),
      surfaceContainerHighest: Color(0xff31353b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa9cdff),
      surfaceTint: Color(0xffa1c9ff),
      onPrimary: Color(0xff00172e),
      primaryContainer: Color(0xff2f94f1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xffd4d4d4),
      onSecondaryContainer: Color(0xff1e2020),
      tertiary: Color(0xffcbcaca),
      onTertiary: Color(0xff151617),
      tertiaryContainer: Color(0xff919191),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101419),
      onSurface: Color(0xfffafaff),
      onSurfaceVariant: Color(0xffc4cbd8),
      outline: Color(0xff9ca3b0),
      outlineVariant: Color(0xff7c8490),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ea),
      inversePrimary: Color(0xff004a81),
      primaryFixed: Color(0xffd2e4ff),
      onPrimaryFixed: Color(0xff001226),
      primaryFixedDim: Color(0xffa1c9ff),
      onPrimaryFixedVariant: Color(0xff003864),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff0f1112),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff353637),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff101112),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff353636),
      surfaceDim: Color(0xff101419),
      surfaceBright: Color(0xff363940),
      surfaceContainerLowest: Color(0xff0b0e14),
      surfaceContainerLow: Color(0xff181c22),
      surfaceContainer: Color(0xff1c2026),
      surfaceContainerHigh: Color(0xff262a30),
      surfaceContainerHighest: Color(0xff31353b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffafaff),
      surfaceTint: Color(0xffa1c9ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa9cdff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd4d4d4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcfafa),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcbcaca),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101419),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffafaff),
      outline: Color(0xffc4cbd8),
      outlineVariant: Color(0xffc4cbd8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ea),
      inversePrimary: Color(0xff002b4f),
      primaryFixed: Color(0xffdae8ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa9cdff),
      onPrimaryFixedVariant: Color(0xff00172e),
      secondaryFixed: Color(0xffe7e7e7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcacbcb),
      onSecondaryFixedVariant: Color(0xff151717),
      tertiaryFixed: Color(0xffe8e6e6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcbcaca),
      onTertiaryFixedVariant: Color(0xff151617),
      surfaceDim: Color(0xff101419),
      surfaceBright: Color(0xff363940),
      surfaceContainerLowest: Color(0xff0b0e14),
      surfaceContainerLow: Color(0xff181c22),
      surfaceContainer: Color(0xff1c2026),
      surfaceContainerHigh: Color(0xff262a30),
      surfaceContainerHighest: Color(0xff31353b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
