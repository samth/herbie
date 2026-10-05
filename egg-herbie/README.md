# Herbie's FFI to egraphs-good/egg

This is a small Rust+Racket package co-developed with Herbie so that
Herbie can bind to and use the [egg](https://egraphs-good.github.io)
equality saturation library.

The Racket side is in [`main.rkt`](main.rkt). It does only two things:
find the `libegg_math` shared library and expose its main functions to
Racket. It has a bit of logic for detecting architecture mismatches
due to Rosetta Apple Silicon.

The Rust side is implemented in standard Rust using the `egg` library.
The `math` module contains math-specific implementation work while the
`lib` module contains code to interface with Racket.

The main Herbie repository's GitHub Actions build and publish
platform-specific packages containing the native Rust library.

The local package keeps a development copy of `main.rkt` for `make install`.
Release archives are built by `package-native.rkt` and contain only the
native library. The published `egg-herbie` package owns the Racket module.
