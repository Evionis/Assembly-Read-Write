extrn ExitProcess : proc
extrn MessageBoxA : proc
extrn CreateFileA : proc	; A = ANSI
extrn ReadFile : proc
extrn WriteFile : proc
extrn CloseHandle : proc
extrn GetLastError : proc	; troubleshooting

.DATA
num QWORD 22
inputFile BYTE "readonlyfile.txt",0
outputFile BYTE "readwritefile.txt",0
caption BYTE "File Copied", 0
buffer BYTE 23 DUP (0)

FD1 QWORD ?
FD2 QWORD ?
read QWORD ?
written QWORD ?
charsRead QWORD 0
button QWORD ?
closed1 QWORD ?
closed2 QWORD ?

.CODE
main PROC

	sub rsp, 10h
	sub rsp, 18h
	sub rsp, 20h

	lea rcx, inputFile
	mov rdx, 80000000h
	xor r8, r8
	xor r9, r9
	mov QWORD PTR [rsp+48h-28h], 3
	mov QWORD PTR [rsp+48h-20h], 80h
	mov QWORD PTR [rsp+48h-18h], 0
	call CreateFileA
	mov FD1, rax
	
	mov rcx, FD1
	lea rdx, buffer
	mov r8, num
	lea r9, charsRead
	mov QWORD PTR [rsp+48h-28h], 0
	call ReadFile
	mov read, rax

	lea rcx, outputFile
	mov rdx, 0C0000000h
	xor r8, r8
	xor r9, r9
	mov QWORD PTR [rsp+48h-28h], 2
	mov QWORD PTR [rsp+48h-20h], 80h
	mov QWORD PTR [rsp+48h-18h], 0
	call CreateFileA
	mov FD2, rax

	mov rcx, FD2
	lea rdx, buffer
	mov r8, num
	lea r9, read
	mov QWORD PTR [rsp+48h-28h], 0
	call WriteFile
	mov written, rax

	xor rcx, rcx
	lea rdx, buffer
	lea r8, caption
	xor r9, r9
	call MessageBoxA
	mov button, rax	

	mov rcx, FD1
	call CloseHandle
	mov closed1, rax

	mov rcx, FD2
	call CloseHandle
	mov closed2, rax

	;add rsp, 48h							; Does cause an issue on my device

	mov rcx, 0
	call ExitProcess

main ENDP
END