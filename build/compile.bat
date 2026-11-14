@echo off
cd ..\
d:\masm.exe src\hola.asm, hola.obj; > build\masm.log
d:\link.exe hola.obj, hola.exe; > build\link.log