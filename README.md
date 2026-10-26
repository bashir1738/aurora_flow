# Aurora Flow

A small Flutter playground for beautiful, hand-built motion. Every effect is drawn from scratch with `CustomPainter`, implicit animations and a handful of well-behaved animation controllers — no animation packages required.

## The worlds

| World | What happens |
| --- | --- |
| **Home** | Drifting aurora, twinkling stars, a morphing liquid blob, shimmering type, staggered reveals and count-up stats. |
| **Motion** | 80 particles drift forever; toggle constellation lines to connect nearby stars. |
| **Pulse** | A breathing orb with layered sine-wave trails, live BPM stats and a pause/resume session control. |
| **Depth** | Parallax mountain layers and a moon inside a 3D card that tilts toward your pointer or drag. |
| **Liquid lab** | Morphing blob loaders, a sweep-gradient progress ring and switchable colour palettes. |

## Details

- Pure Flutter — only `cupertino_icons` is added on top of the SDK.
- Frosted glass cards (`BackdropFilter`), a morphing floating bottom nav, and a custom fade/slide/scale page transition.
- Repaint-boundary-friendly custom painters so the animated background stays isolated.
- Runs on Android, iOS and the web.

## Run it

```bash
flutter pub get
flutter run
```

To try it in a browser:

```bash
flutter run -d chrome
```

## Verify

```bash
flutter analyze
flutter test
```

## Structure

```
lib/
  app.dart                 # MaterialApp + theme
  main.dart                # entry point
  theme/app_theme.dart     # palette, gradients, type scale
  screens/                 # shell + Home, Motion, Pulse, Depth, Liquid
  widgets/                 # aurora, starfield, particles, blobs, glass, nav...
  utils/motion_route.dart  # custom page transition
```
