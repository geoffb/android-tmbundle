#!/bin/bash

# Android.tmbundle build script
# Finds Ant build.xml files and builds the project
# (re)Installs *-debug.apk files to a running Android emulator using adb

printError() {
	echo "<span class=\"error\">Error: $1</span>"
}

printStyles() {
	cat <<'HTML'
		<style type="text/css">
			html, body {
				margin:0;
				background:#D4E9A9;
			} 
			#body {
				padding:10px;
			} 
			h1 {
				background:#AACA46;
				color:#fff;
				padding:10px;
				border-bottom:solid 3px #aaa;
			} 
			.error {
				color:#f00;
				font-weight:bold;
				display:block;
			} 
			pre {
				background:#ddd;
				border:solid 1px #000;
				padding:10px;
				overflow:auto;
			}
		</style>
HTML
}

printFooter() {
	echo "</div><!-- #body --></body></html>"
}

cleanupAndExit() {
	printFooter
	exit
}

if [ "$1" = "install" ]; then
	TITLE="Android: Build & Install"
else
	TITLE="Android: Build"
fi

echo "<html><head><title>$TITLE</title>"
printStyles
echo "</head><body><h1>$TITLE</h1><div id=\"body\">"

#######################################
## Build with Ant #####################
#######################################

ANT=`which ant`
if [ "$ANT" = "" ]; then
	printError "Couldn't find Ant!"
	cleanupAndExit
fi

cd "$TM_DIRECTORY"

while [ "$PWD" != "/" ]; do
	if test -e "$PWD/build.xml"; then
		BUILD_DIR="$PWD"
		break
	fi
	cd ..
done

if [ "$BUILD_DIR" = "" ]; then
	printError "Couldn't find build.xml!"
	cleanupAndExit
fi

cd $BUILD_DIR

echo "Building from $BUILD_DIR<br>"
echo "Building with Ant...<br>"
echo "<pre>"
$ANT
echo "</pre>"

#######################################
## Install with adb ###################
#######################################

if [ "$1" = "install" ]; then

	ADB=`which adb`
	if [ "$ADB" = "" ]; then
		printError "Couldn't find adb!"
		cleanupAndExit
	fi

	cd bin

	echo "Installing with adb<br>"
	echo "Looking for *-debug.apk files in $PWD<br>"
	for FILE in $PWD/*-debug.apk; do
		echo "Found debug apk: $FILE<br>"
		CMD="$ADB install -r $FILE"
		echo "Installing...<br>"
		echo "<pre>"
		$CMD
		echo "</pre>"
	done

	osascript -e "tell application \"emulator\" to activate"

fi

cleanupAndExit
