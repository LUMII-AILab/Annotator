@echo off
rem set PATH=.;chunker\pl\bin;%PATH%
rem set SWI_HOME_DIR=chunker\pl
set LD_LIBRARY_PATH=%PATH%
@echo on

java -classpath "lib\annotator.jar;lib\morphology.jar;lib\chunker.jar;chunker\pl\lib\jpl.jar;lib\cpdetector.jar;lib\CRF.jar" -Xmx1g lv.semti.annotator.AnnotatorApplication
pause