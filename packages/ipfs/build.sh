TERMUX_PKG_HOMEPAGE=https://ipfs.io/
TERMUX_PKG_DESCRIPTION="A peer-to-peer hypermedia distribution protocol"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL=https://github.com/ipfs/go-ipfs/releases/download/v${TERMUX_PKG_VERSION}/go-ipfs-source.tar.gz
TERMUX_PKG_SHA256=00d96f0983dea0170bf61351a0a0ab39f1515b919a0a7ff5055eca25a4c06f91

termux_step_make() {
	termux_setup_golang

	export GOPATH=${TERMUX_PKG_BUILDDIR}
	export GOARCH=${TERMUX_ARCH}

	if [ "${TERMUX_ARCH}" = "aarch64" ]; then
		GOARCH="arm64"
	elif [ "${TERMUX_ARCH}" = "i686" ]; then
		GOARCH="386"
	elif [ "${TERMUX_ARCH}" = "x86_64" ]; then
		GOARCH="amd64"
	fi

	mkdir -p "${GOPATH}/src/github.com/ipfs"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ipfs/go-ipfs"
	cd "${GOPATH}/src/github.com/ipfs/go-ipfs"

	make build

	# Fix folders without write permissions preventing which fails repeating builds:
	cd $TERMUX_PKG_BUILDDIR
	find . -type d -exec chmod u+w {} \;
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "${TERMUX_PKG_BUILDDIR}/src/github.com/ipfs/go-ipfs/cmd/ipfs/ipfs"
}
