
#!/bin/bash
THISDIR=$PWD
ROM=${1}
UNATTENDED=${2}
TOPDIR="$THISDIR/../../../../"
if [[ "$ROM" == "" ]]; then
	echo "ROM not specified, assuming cm!"
	sleep 1
	ROM="cm"
fi
echo $TOPDIR
cd $ROM
for LINE in $(find -name *.patch -printf "%P\n"| sort )
do
	echo "------------------------------------------------------------------------"
	echo "patch = $THISDIR/$ROM/$LINE"
	echo "------------------------------------------------------------------------"
	PATCH=$THISDIR/$ROM/$LINE
	REPO=$(dirname $LINE)
	echo "repo = $REPO"
	cd $TOPDIR
	if [[ ! -e $REPO ]]; then
		echo "WARNING: $REPO does not exist; skipping..."
		cd $THISDIR
		continue
fi
	cd $REPO
	RESULT=$(patch -p1 --follow-symlinks --no-backup-if-mismatch < $PATCH)
	echo -e "${RESULT}"
	if [[ $(echo $RESULT | grep -c FAILED) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Failed!" yn
		fi
	fi
	if [[ $(echo $RESULT | grep -c "saving rejects to file") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Rejects!" yn
		fi
	fi
	if [[ $(echo $RESULT | grep -c "Skip this patch") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Skipped!" yn
			break;
		fi
	fi
	cd $THISDIR
done
