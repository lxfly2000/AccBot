@echo off
setlocal EnableDelayedExpansion
::����JAVA·��
set JAVA_HOME=D:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2019.1.1\jbr
path %path%;%JAVA_HOME%\bin
for %%i in (*.lua) do set luafile=%%i
for %%i in (lua-mirai*.jar) do set miraifile=%%i
::����
java -jar %miraifile% exec %luafile%
