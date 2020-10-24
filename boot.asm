section .text
	[bits 16]
	[org 0x7c00]
	boot16:
		mov ax,0x2401
		int 0x15
		mov ax,0x03
		int 0x10
		mov [disk],dl
		mov ah,0x02
		mov al,0x01
		mov ch,0x00
		mov dh,0x00
		mov cl,0x02
		mov dl,[disk]
		mov bx,boot32_sector
		int 0x13
		cli
		lgdt [gdt_pointer]
		mov eax,cr0
		or eax,0x01
		mov cr0,eax
		mov ax,(gdt_data-gdt_start)
		mov ds,ax
		mov es,ax
		mov fs,ax
		mov gs,ax
		mov ss,ax
		jmp (gdt_code-gdt_start):boot_main



	gdt:
		gdt_start:
			dq 0x00
		gdt_code:
			dw 0xffff
			dw 0x00
			db 0x00
			db 0x9a
			db 0xcf
			db 0x00
		gdt_data:
			dw 0xffff
			dw 0x00
			db 0x00
			db 0x92
			db 0xcf
			db 0x00
		gdt_end:
		gdt_pointer:
			dw gdt_end-gdt_start
			dd gdt_start
		disk:
			db 0x00



	times 510-($-$$) db 0
	dw 0xaa55



	[bits 32]
	boot32_sector:
		boot32_str:
			db "Booted in 32-bit Protected Mode...",0
		boot_main:
			mov esi,boot32_str
			mov ebx,0xb8000
			_boot32_loop:
				lodsb
				or al,al
				jz _boot32_end
				or eax,0x0f00
				mov word [ebx],ax
				add ebx,0x02
				jmp _boot32_loop
			_boot32_end:
				cli
				hlt



	times 1024-($-$$) db 0



global boot16
