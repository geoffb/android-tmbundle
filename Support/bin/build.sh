#!/bin/bash
echo "<style type=\"text/css\">body{margin:0;} #body{padding:10px;} h1{background:#AACA46;color:#fff;padding:10px} .error{color:#f00;font-weight:bold;} pre{background:#ddd;height:150px;border:solid 1px #000;padding:10px;overflow:auto;}</style>"
echo "<h1>Android: Building with Ant</h1>"
echo "<div id=\"body\">"

ANT=`which ant`
if [ "$ANT" = "" ]; then
	echo "<span class=\"error\">Couldn't find Ant!</span><br>"
	exit
fi

cd $TM_DIRECTORY

while [ $PWD != "/" ]; do
	if test -e $PWD/build.xml; then 
		BUILD_DIR="$PWD"
		break
	fi
	cd ..
done

if [ "$BUILD_DIR" = "" ]; then
	echo "<span class=\"error\">Couldn't find build.xml!</span><br>"
	exit
fi

cd $BUILD_DIR

echo "<h2>Ant output:</h2>"
echo "<pre>"
$ANT $BUILD_XML
echo "</pre>"

ADB=`which adb`
if [ "$ADB" = "" ]; then
	echo "<span class=\"error\">Couldn't find adb!</span><br>"
	exit
fi

cd bin

echo "<h2>adb ouput:</h2>"
echo "<pre>"
for FILE in $PWD/*.apk; do
	CMD="$ADB install -r $FILE"
	$CMD
done
echo "</pre>"

echo "</div><!-- #body -->"

exit
