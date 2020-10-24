@echo off
cls
"C:\Program Files\NASM\nasm" -f bin boot.asm -o boot.bin&&"C:\Program Files\qemu\qemu-system-x86_64" -drive file=boot.bin,format=raw,index=0,media=disk&&del *.bin
