@echo off
setlocal EnableDelayedExpansion
::����JAVA·��
set JAVA_HOME=D:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2019.1.1\jbr
path %path%;%JAVA_HOME%\bin
set luafile=bot.lua
set miraifile=lua-mirai-2.0.9.jar
::����
java -jar %miraifile% exec %luafile%
