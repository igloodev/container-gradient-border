## 0.1.2

- Reduced archive size: converted screenshot from PNG (140 KB) to JPEG (74 KB)

---

## 0.1.1

- Added `screenshots` field to `pubspec.yaml` for pub.dev gallery display

---

## 0.1.0

- **Breaking**: Replaced nested-container implementation with `CustomPaint` for accurate gradient stroke rendering
- **Breaking**: Removed `colorList`, `start`, `end`, `height`, `width`, `childAlignment` parameters
- **New**: `gradient` parameter accepts any `Gradient` type (`LinearGradient`, `RadialGradient`, `SweepGradient`)
- **New**: Widget sizes to its child automatically — no fixed `height`/`width` required
- **New**: `padding` parameter for inner content spacing
- Fixed: Inner corner radius is now geometrically correct
- Fixed: All parameters are non-nullable; removed unsafe force-unwraps (`!`)
- Fixed: Negative inner dimensions no longer possible
- Updated Dart SDK constraint to `>=3.0.0 <4.0.0`
- Updated `flutter_lints` to `^4.0.0`
- Added dartdoc comments to all public API members
- Expanded test coverage from 0 to 27 tests

## 0.0.2

Update README

## 0.0.1

Initial release
