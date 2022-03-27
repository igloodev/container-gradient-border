<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A Widget which provide gradient border to container.

## Features

There are number of properties that you can modify.
- Gradient color list
- height
- width
- BorderWidth
- GradientStart
- GradientEnd
- ContainerColor
- BorderRadius
- child
- childAlignment
- padding


## Dart Code Usage

```
ContainerGradientBorder(
            height: 200,
            width: 300,
            borderWidth: 7,
            colorList: const [Colors.blue, Colors.green, Colors.yellow],
            containerColor: Colors.red.shade400,
            borderRadius: 40,
            start: Alignment.topCenter,
            end: Alignment.bottomCenter,
            child: const Text("Test"),
            childAlignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
```
