# [LibYAML](https://github.com/eschnett/LibYAML)

A Julia library wrapping the
(LibYAML)[https://github.com/yaml/libyaml] C library.

[![Build Status (Travis)](https://travis-ci.org/eschnett/LibYAML.jl.svg?branch=master)](https://travis-ci.org/eschnett/LibYAML.jl)
[![Build status (Appveyor)](https://ci.appveyor.com/api/projects/status/h9h61g8lpoyw20r4/branch/master?svg=true)](https://ci.appveyor.com/project/eschnett/libyaml-jl/branch/master) [unfortunately, Windows is not yet supported]
[![Coverage Status (Coveralls)](https://coveralls.io/repos/github/eschnett/LibYAML.jl/badge.svg?branch=master)](https://coveralls.io/github/eschnett/LibYAML.jl?branch=master)
[![DOI](https://zenodo.org/badge/175033209.svg)](https://zenodo.org/badge/latestdoi/175033209)

# Note: This package is abandoned

It turns out that wrapping LibYAML directly in Julia is not
feasible since LibYAML uses unions in its types. It is unclear to me
how to create respective Julia types that have the correct size. It
might be necessary to create C wrappers that allocate or free
LibYAML's objects, and provide Julia accessors that don't use C
unions.
