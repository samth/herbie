# Herbie's native egg library

This Rust crate builds `egg_math`, the native library used by the
[`egg-herbie`](https://github.com/herbie-fp/egg-herbie) Racket package.
Its Racket module now lives in that package.

The release workflow uses `package-native.rkt` to stage the shared library
in a platform-specific package such as `egg-herbie-linux`. Local
`make install` builds and installs that native package, then installs
the shared wrapper. Set `EGG_HERBIE_WRAPPER_SOURCE` to a local checkout
when testing a wrapper change that is not yet in the package catalog.
