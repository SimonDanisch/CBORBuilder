# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder
using BinaryProvider

name = "CBOR"
version = v"0.5.0"
# Collection of sources required to build Harfbuzz
sources = [
    "https://github.com/PJK/libcbor/archive/v0.5.0.tar.gz" =>
    "9bbec94bb385bad3cd2f65482e5d343ddb97e9ffe261123ea0faa3bfea51d320",
]


# Bash recipe for building across all platforms
script = raw"""
cd libcbor-0.5.0/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCBOR_CUSTOM_ALLOC=ON
make -j8
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcbor", :libcbor),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
