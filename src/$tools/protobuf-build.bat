@echo off
::http://code.google.com/p/protobuf/
::https://code.google.com/p/protoc-gen-as3/

set flexPath=D:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0\bin

protoc --plugin=protoc-gen-as3="protoc-gen-as3.bat" --as3_out=as3-src --cpp_out=cpp-src proto-src/*
"%flexPath%\compc" -output as3-bin/NetLib.swc -source-path as3-src -library-path+=protobuf.swc -include-sources as3-src
::"%flexPath%\mxmlc" -static-link-runtime-shared-libraries=true -output bin-debug\TankGame.swf -source-path src -library-path+=E:\tank\client\tank\libs\loginShell.swc -library-path+=E:/engine/client_as3/libraries/engine.swc -library-path+=E:/tank/client/libraries/tank_library__script.swc -library-path+=E:/tank/client/libraries/tank_library__protocol.swc -library-path+=E:/tank/client/libraries/tank_library__static_table.swc -library-path+=E:/tank/client/libraries/tank_library__base.swc -include-libraries+=E:/engine/client_as3/libraries/engine.swc -include-libraries+=E:/tank/client/libraries/tank_library__script.swc -include-libraries+=E:/tank/client/libraries/tank_library__protocol.swc -include-libraries+=E:/tank/client/libraries/tank_library__static_table.swc -include-libraries+=E:/tank/client/libraries/tank_library__base.swc src\TankGame.as
pause