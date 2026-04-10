# container_gradient_border

A Flutter widget that applies a gradient border to any child widget using `CustomPaint` for pixel-accurate stroke rendering.

## Preview

![Example screenshot](https://raw.githubusercontent.com/igloodev/container-gradient-border/master/screenshots/example.png)

## Features

- **Any gradient type** — `LinearGradient`, `RadialGradient`, `SweepGradient`
- **Sizes to child automatically** — no fixed `height`/`width` required
- **True stroke border** — drawn with `CustomPaint`, not a background bleed-through
- **Focused input fields** — swap gradient on focus using `Focus` widget
- **Pill / fully-rounded shapes** — set `borderRadius: 999`
- **Transparent or solid background** — control via `containerColor`
- **Inner padding** — `padding` parameter spaces content away from the border
- **Multi-stop gradients** — pass as many colors as needed
- Works on Android, iOS, Web, Windows, macOS, and Linux

## Installation

```yaml
dependencies:
  container_gradient_border: ^0.1.0
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

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget displayed inside the border |
| `gradient` | `Gradient` | white→black linear | Gradient applied to the border stroke |
| `borderWidth` | `double` | `2.0` | Thickness of the border in logical pixels |
| `borderRadius` | `double` | `0.0` | Corner radius |
| `containerColor` | `Color` | `Colors.transparent` | Background color inside the border |
| `padding` | `EdgeInsets` | `EdgeInsets.zero` | Padding around child, inside the border |
