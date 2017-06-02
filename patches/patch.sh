#!/bin/bash
. internal/patch.sh common
mon. internal/patch.sh janice
. internal/patch.sh selinux

echo ""
echo "Don't forget to run '. internal/patch.sh omni' for Omni!"
echo "or '. internal/patch.sh microg' for microG! (only for ROMs without microG support eg. LOS)"
