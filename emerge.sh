#!/bin/bash
EIX_LIMIT_COMPACT=0 eix -uc && \
#&& quickpkg --include-config=y $(eix -uc --only-names) &&
emerge @world -uvaDN --with-bdeps=y --autounmask-write --exclude gentoo-sources \
	&& emerge -v @preserved-rebuild @module-rebuild && revdep-rebuild
