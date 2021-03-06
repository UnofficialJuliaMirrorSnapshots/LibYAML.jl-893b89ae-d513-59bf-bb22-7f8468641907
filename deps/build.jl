using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libyaml"], :libyaml),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/eschnett/libyaml-binaries/releases/download/v1.0.0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/libyaml.v0.2.1.aarch64-linux-gnu.tar.gz", "d2247731b401c96d61995966422d24edf6e3ab06428ddec3f4ed4c12074c4661"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/libyaml.v0.2.1.aarch64-linux-musl.tar.gz", "67a745cbfc238b505fd6a1c677b5fd34177e51472867704a0464e52421454631"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/libyaml.v0.2.1.arm-linux-gnueabihf.tar.gz", "7f43ce82a5c039c7bec13c001631812ca9510131c06b13211dfc6679514559cd"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/libyaml.v0.2.1.arm-linux-musleabihf.tar.gz", "ad7dd7464dd1df2b6438484a6dc82e889c222f7ec3688afed54c16875bbcd38a"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/libyaml.v0.2.1.i686-linux-gnu.tar.gz", "27448c16b705d58ae903be76e7997045f73a8f28b8dbe52773d3794f73322379"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/libyaml.v0.2.1.i686-linux-musl.tar.gz", "c448e95e8ce0f2cc3826779c9086addea6fa78ac007bb958d41127ba90818481"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/libyaml.v0.2.1.powerpc64le-linux-gnu.tar.gz", "47d27b1287f93a8aa33ac1570c7660a4ac6529f12006a6cc726f22d2f206428e"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/libyaml.v0.2.1.x86_64-linux-gnu.tar.gz", "1410f0ffc3206433f30999d051a917fc19301006cadbef5679ef1619c2830002"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/libyaml.v0.2.1.x86_64-linux-musl.tar.gz", "0100c096ab78a7084d21ca84af23d0b2b318d11bef1fdbc31c5df0adb8cb8ca9"),
    FreeBSD(:x86_64) => ("$bin_prefix/libyaml.v0.2.1.x86_64-unknown-freebsd11.1.tar.gz", "bd8fb84eca65fb20ef5cc493184e5adf17ab89476e9012e7c5ada86b1d8a3b24"),
    MacOS(:x86_64) => ("$bin_prefix/libyaml.v0.2.1.x86_64-apple-darwin14.tar.gz", "49165350ac38b475fba21a76328bf9725e9de0dca60195249ab3fe73d5e11c4a"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
