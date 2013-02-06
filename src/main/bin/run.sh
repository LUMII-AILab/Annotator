#!/bin/sh
# Works on MacOSX; not tested on Linux
eval `swipl -dump-runtime-variables`
JPLSO="$PLBASE/lib/$PLARCH/libjpl.$PLSOEXT"
JPLJAR="$PLBASE/lib/jpl.jar"

export SWI_HOME_DIR=$PLBASE
export CLASSPATH=$JPLJAR:lib/annotator.jar:lib/morphology.jar:lib/chunker.jar:lib/cpdetector.jar:lib/CRF.jar
export JAVA_LIB=/usr/lib/jvm/java-6-sun/jre/lib/i386
export JAVA_SO=$JAVA_LIB/libjava.so:$JAVA_LIB/libverify.so:$JAVA_LIB/client/libjvm.so
export DYLD_LIBRARY_PATH="$PLBASE/lib/$PLARCH"

env LD_PRELOAD=$JPLSO:$JAVA_SO java -Xmx2g lv.semti.annotator.AnnotatorApplication
