# container_gradient_border

A Flutter widget that applies a gradient border to any child widget using `CustomPaint` for pixel-accurate stroke rendering — now with **dashed**, **glow**, and **animated** borders.

<p align="center">
  <a href="https://pub.dev/packages/container_gradient_border"><img src="https://img.shields.io/pub/v/container_gradient_border?logo=dart&color=0175C2" alt="pub version"></a>
  <a href="https://pub.dev/packages/container_gradient_border/score"><img src="https://img.shields.io/pub/points/container_gradient_border?color=2EA44F" alt="pub points"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://github.com/igloodev/container-gradient-border/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="license"></a>
</p>

## Preview

![Example screenshot](https://raw.githubusercontent.com/igloodev/container-gradient-border/master/screenshots/example.jpg)

## Features

- **Any gradient type** — `LinearGradient`, `RadialGradient`, `SweepGradient`
- **Sizes to child automatically** — no fixed `height`/`width` required
- **True stroke border** — drawn with `CustomPaint`, not a background bleed-through
- **Focused input fields** — swap gradient on focus using `Focus` widget
- **Pill / fully-rounded shapes** — set `borderRadius: 999`
- **Transparent or solid background** — control via `containerColor`
- **Inner padding** — `padding` parameter spaces content away from the border
- **Multi-stop gradients** — pass as many colors as needed
- **Dashed borders** — `dashPattern: [dash, gap]`
- **Glow** — outer glow via `glowColor` / `glowBlurRadius`
- **Animated borders** — `animate: true` rotates the gradient (stunning with `SweepGradient`)
- Works on Android, iOS, Web, Windows, macOS, and Linux

## Installation

```yaml
dependencies:
  container_gradient_border: ^0.2.0
```

## Usage

### Linear gradient — card

```dart
ContainerGradientBorder(
  borderWidth: 3,
  borderRadius: 16,
  gradient: const LinearGradient(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  containerColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  child: const Text('Hello, Gradient Border!'),
)
```

### Radial gradient — avatar / icon

```dart
ContainerGradientBorder(
  borderWidth: 4,
  borderRadius: 60,
  gradient: const RadialGradient(
    colors: [Colors.orange, Colors.red],
  ),
  containerColor: Colors.grey.shade100,
  child: const SizedBox(
    width: 100,
    height: 100,
    child: Icon(Icons.person, size: 56),
  ),
)
```

### Sweep gradient — rainbow pill button

```dart
ContainerGradientBorder(
  borderWidth: 2,
  borderRadius: 999,
  gradient: const SweepGradient(
    colors: [
      Colors.red, Colors.orange, Colors.yellow,
      Colors.green, Colors.blue, Colors.purple, Colors.red,
    ],
  ),
  containerColor: Colors.black,
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  child: const Text('Rainbow Button', style: TextStyle(color: Colors.white)),
)
```

### TextField with focus state

Wrap in a `StatefulWidget`, track focus with a `bool`, and swap the gradient on `onFocusChange`:

```dart
// inside State<...>.build:
bool _focused = false;

Focus(
  onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
  child: ContainerGradientBorder(
    borderWidth: 2,
    borderRadius: 10,
    gradient: LinearGradient(
      colors: _focused
          ? [Colors.deepPurple, Colors.pink]
          : [Colors.grey.shade300, Colors.grey.shade400],
    ),
    containerColor: Colors.white,
    child: const TextField(
      decoration: InputDecoration(
        hintText: 'Tap to focus...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
  ),
)
```

### Dashed border

```dart
ContainerGradientBorder(
  borderWidth: 2,
  borderRadius: 12,
  dashPattern: const [8, 5], // 8px dash, 5px gap
  gradient: const LinearGradient(colors: [Colors.teal, Colors.cyan]),
  child: const SizedBox(width: 140, height: 60),
)
```

### Glowing border

```dart
ContainerGradientBorder(
  borderWidth: 2,
  borderRadius: 16,
  glowColor: Colors.purpleAccent,
  glowBlurRadius: 14,
  gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
  child: const SizedBox(width: 140, height: 60),
)
```

### Animated (rotating) border

```dart
ContainerGradientBorder(
  borderWidth: 3,
  borderRadius: 999,
  animate: true,
  animationDuration: const Duration(seconds: 2),
  gradient: const SweepGradient(
    colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.red],
  ),
  containerColor: Colors.black,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  child: const Text('Shimmering', style: TextStyle(color: Colors.white)),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget displayed inside the border |
| `gradient` | `Gradient` | white→black linear | Gradient applied to the border stroke |
| `borderWidth` | `double` | `2.0` | Thickness of the border in logical pixels |
| `borderRadius` | `double` | `0.0` | Corner radius |
| `containerColor` | `Color` | `Colors.transparent` | Background color inside the border |
| `padding` | `EdgeInsets` | `EdgeInsets.zero` | Padding around child, inside the border |
| `dashPattern` | `List<double>?` | `null` | Dash pattern `[dash, gap, …]`; null = solid |
| `glowColor` | `Color?` | `null` | Outer glow color; null = no glow |
| `glowBlurRadius` | `double` | `8.0` | Blur radius of the glow |
| `animate` | `bool` | `false` | Continuously rotate the gradient |
| `animationDuration` | `Duration` | `3s` | Duration of one rotation when `animate` is true |
