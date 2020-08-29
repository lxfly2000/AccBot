@echo off
setlocal EnableDelayedExpansion
::设置JAVA路径
set JAVA_HOME=D:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2019.1.1\jbr
path %path%;%JAVA_HOME%\bin
for %%i in (*.lua) do set luafile=%%i
for %%i in (lua-mirai*.jar) do set miraifile=%%i
::运行
java -jar %miraifile% exec %luafile%
