FROM ghcr.io/unb-libraries/unbscholar.dspace.lib.unb.ca:prod

COPY ./build/config/dspace/local.cfg $DSPACE_INSTALL/config/local.cfg
COPY ./build/scripts/pre-init.d/*.sh /scripts/pre-init.d/
