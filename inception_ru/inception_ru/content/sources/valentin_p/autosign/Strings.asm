comment ^

;; Text macros collection

;; Written by Four-F (four-f@mail.ru)
;; Last updated 01-September-2004
;; Your improvements, suggestions and bugfixes are welcomed.

;; Tested for compatibility with windows.inc v.1.25e

STRINGA / STRINGW are internal macros. Basically you don't need to use them.



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:                                     S Y N T A X                                                  :
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    MacroName quotedtext [,lebel] [,alignment]
    or
    MacroName quotedtext [,alignment] [,lebel]

    $MacroName(quotedtext [,lebel] [,alignment])
    or
    $MacroName(quotedtext [,alignment] [,lebel])

----------------------------------------------------------------------------------------------------

- MacroName / $MacroName from the following list:

TA / TW / T
CTA / CTW / CT

$TA / $TW / $T
$CTA / $CTW / $CT

TA0 / TW0 / T0
CTA0  / CTW0 / CT0

$TA0 / $TW0 / $T0
$CTA0 / $CTW0 / $CT0

The interpritation of the macro names is quite simple and based on the following:

T - all macros have 'T' char in its names. It means Text.
C - constant string. String is defined in read-only data section ( .const ).
    macros without 'C' in its name define string in read-write data section ( .data ).
A - macro defines ASCII string.
W - macro defines Wide (Unicode) string. The size of each character is 2 bytes.
0 - zero character not 'O'. Defined string is terminated by zero byte (ASCII) or zero word (Unicode).
$ - macro function. Returns offset to defined text.


Each macro has corresponding macro function which name is prepended with '$' character.

All macro functions return offset to defined text.
All macros return nothing.

If macro name doesn't contain neither 'A' nor 'W' character,
its behaviour depends on definition of global variable UNICODE.
If UNICODE is undefined or equal to 0, that macro defines ASCII string.
If UNICODE is defined and doesn't equal to 0, that macro defines Unicode string.

You can define UNICODE global variable two ways:
    - in command line to ml.exe
        \DUNICODE=1
    - in source code
        UNICODE = 1
            or
        UNICODE equ 1


----------------------------------------------------------------------------------------------------

-   quotedtext:

The first parameter is "quoted text" you want to define.
It is required and MUST be in quotation marks.

You can use escape characters.

    esc. char.     code         symbol
    --------------------------------------------------
        \:         21h            '!'
        \{         28h            '('
        \}         29h            ')'
        \[         3Ch            '<'
        \]         3Eh            '>'
        \=         22h            '"'
        \-         27h            "'"
        \\         5Ch            '\'
        \*          -              -   ;; To workaround "CopyFile" -> CopyFileA problem
        \0          0             zero byte/word
        \a          7             alert (BEL)
        \b          8             backspace
        \t          9             horizontal tabulation
        \n         0Dh, 0Ah       new line
        \l         0Ah            line feed
        \v         0Bh            verticalal tabulation
        \f         0Ch            formfeed
        \r         0Dh            carrige return

----------------------------------------------------------------------------------------------------

-   lebel, alignment:

The second and third parameters are optional.
It can be either label or alignment.
The macros recognize is it a label or an alignment automatically.

Later you can reference defined text by this label.

Alignment can be immediate value of 1 (byte), 2 (word) or 4 (dword).
By default alignment is:
    - 1 for ascii string
    - 2 for unicode string

The structure UNICODE_STRING, defined with the following macros is always DWORD alignmented.
COUNTED_UNICODE_STRING / $COUNTED_UNICODE_STRING / CCOUNTED_UNICODE_STRING / $CCOUNTED_UNICODE_STRING
You can set alignment for the string  pointed by UNICODE_STRING.Buffer.



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:                  E L I M I N A T E    D U P L I C A T E    S T R I N G S                         :
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

The following macros try to eliminate duplicate strings. So only a single copy of identical strings
will present in the program image, resulting in smaller programs.

$TA / $CTA / $TW / $CTW / $T / $CT
$TA0 / $CTA0 / $TW0 / $CTW0 / $T0 / $CT0

Every time you define a string using one of the above listed macros the string is stored in database.
If somewhere later in your code you use the very same macro to define the very same string, the macro
will remember its offset from the database instead of defining it second time.

Consider example.

invoke MessageBox, NULL, $CTA0("OK"), $CTA0("Success"), MB_OK
. . .
invoke MessageBox, NULL, $CTA0("OK"), $CTA0("Success"), MB_OK

The above two strings are compiled as if you use this code:

.const
szOK      db "OK", 0
szSuccess db "Success", 0
.code
invoke MessageBox, NULL, addr szOK, addr szSuccess, MB_OK
. . .
invoke MessageBox, NULL, addr szOK, addr szSuccess, MB_OK


---
Bear in mind that each macro has its own database. So, for example, $CTA0 searches only
among the strings previously defined with the very same macro!

This optimization works only for unlabeled strings. So, if you explicity pass the label
to the macro it will not serch in database for that string.

Consider example.

invoke MessageBox, NULL, $CTA0("OK"), $CTA0("Success"), MB_OK
. . .
invoke MessageBox, NULL, $CTA0("OK", szOK), $CTA0("Success", szSuccess), MB_OK

The above two strings are compiled as if you use this code:

.const
???1      db "OK", 0
???2      db "Success", 0
szOK      db "OK", 0
szSuccess db "Success", 0
.code
invoke MessageBox, NULL, addr ???1, addr ???2, MB_OK
. . .
invoke MessageBox, NULL, addr szOK, addr szSuccess, MB_OK


---
Also remember that if you explicity pass alignment that is greater then the alignment of previously
defined string the macro will use offset to the string from database and warn you with the message:

mov eax, $CTA0("Alignment", 2)
mov eax, $CTA0("Alignment", 4)

C:\masm32\macros\xxx.asm(xxx) : $CTA0 macro WARNING! Alignment is greater then
previous instance of "Alignment".


---
To disable string pooling feature define somewhere in you code before any string macro this line:

DISABLE_STRING_POOLING equ 1

NOTE: The value you specify doesn't matter. It can be any value. So defining it equal to 0 disables
string pooling also. The macros just seek if it defined or not. So, if you want to enable string
pooling back again remove or comment out DISABLE_STRING_POOLING definition.



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:                                    L I M I T A T I O N S                                         :
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Unicode string can be up to 47 characters long.
Otherwise you'll get assembler error:
     : error A2042: statement too complex

Hope I'll fix this later.



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:                              K N O W N    P R O B L E M S                                        :
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CTA0("CopyFile") produce CopyFileA because of:
CopyFile equ <CopyFileA>

Its because of native masm behavior.

You can workaround this placing '\*' somewhere in simbol name like this:
$CTA0("Copy\*File")
'\*' escape sequence expands to hothing. So you will get "CopyFile" instead of "CopyFileA".

Or you can use unrecognizeable character escape sequence. For example, like this:
$CTA0("C\opyFile")
You will get "WARNING!: 'o' : unrecognized character escape sequence" from macro
but 'o' char will be added to string. So you will also get "CopyFile" instead of "CopyFileA".


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:                                      E X A M P L E S                                             :
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

The most usable macros are: $CTA0, $CTW0, CTA0, CTW0

----------------------------------------------------------------------------------------------------
To define empty string use any zero-terminating macro this way:
    mov eax, $TA0()
or
    mov eax, $TA0('')
or
    mov eax, $TA0("")


DON'T TRY TO DEFINE EMPTY STRINGS WITH NON-ZERO TERMINATING MACROS: 
TA / TW / T / CTA / CTW / CT / $TA / $TW / $T / $CTA / $CTW / $CT



::::::::::::::::::::::::::::::::::::::::::::: Ex 1 :::::::::::::::::::::::::::::::::::::::::::::::::

invoke AppendMenu, hMenuPopupFile, MF_STRING, IDM_OPEN, $CTA0("&Open...\tCtrl+O")

    Expands to:

.const
??? db "&Open...", 9, "Ctrl+O", 0
.code
invoke AppendMenu, hMenuPopupFile, MF_STRING, IDM_OPEN, offset ???



::::::::::::::::::::::::::::::::::::::::::::: Ex 2 :::::::::::::::::::::::::::::::::::::::::::::::::

TA0 "http://board.win32asmcommunity.net/", szUrl, 4
invoke MessageBox, NULL, offset szUrl, $TA0("Go To", 4), MB_OK

    Expands to:

.data
align 4
szUrl db "http://board.win32asmcommunity.net/", 0
align 4
??? db "Go To", 0
.code
invoke MessageBox, NULL, offset szUrl, offset ???, MB_OK



::::::::::::::::::::::::::::::::::::::::::::: Ex 3 :::::::::::::::::::::::::::::::::::::::::::::::::

invoke MessageBox, NULL, $CTA0("\[ Well done\: :-\} \]"), $CTA0("Congratulations"), MB_OK

    Expands to:

.const
??1 db "< Well done! :-) >", 0
??2 db "Congratulations", 0
.code	
invoke MessageBox, NULL, offset ??1, ??2, MB_OK



::::::::::::::::::::::::::::::::::::::::::::: Ex 4 :::::::::::::::::::::::::::::::::::::::::::::::::

invoke IoCreateDevice, pDriverObject, 0, \
			$CCOUNTED_UNICODE_STRING("\\Device\\DevName", g_usDeviceName, 4), \
			FILE_DEVICE_UNKNOWN, 0, FALSE, addr g_pDeviceObject


    Expands to:


.const
align 4
??? dw "\" ,"D" ,"e" ,"v" ,"i" ,"c" ,"e" ,"\" ,"D" ,"e" ,"v" ,"N" ,"a" ,"m" ,"e" , 0
align 4	         ; The UNICODE_STRING structure itself is always DWORD alignmented
g_usDeviceName   dw (sizeof ???) - 2   ; UNICODE_STRING.Length
                 dw (sizeof ???)       ; UNICODE_STRING.MaximumLength
                 dd offset ???         ; UNICODE_STRING.Buffer
.code
invoke IoCreateDevice, pDriverObject, 0, offset g_usDeviceName, \
			FILE_DEVICE_UNKNOWN, 0, FALSE, addr g_pDeviceObject




::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:                   R E A D Y    T O    C O M P I L E    E X A M P L E S                           :
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::: Ready To Compile Ex 1 :::::::::::::::::::::::::::::::::::::::

.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

include \masm32\Macros\Strings.mac

.data
ms MEMORYSTATUS <>
buffer db 100 dup(0)
TA  "Percent of memory in use:\t\t%d\n", szFormat
TA  "Bytes of physical memory:\t\t%d\n"
TA  "Free physical memory bytes:\t\t%d\n"
TA  "Bytes of paging file:\t\t%d\n"
TA  "Free bytes of paging file:\t\t%d\n"
TA  "User bytes of address space:\t\t%d\n"
TA0 "Free user bytes:\t\t\t%d\n"

.code
start:
invoke GlobalMemoryStatus, addr ms
invoke wsprintf, addr buffer, addr szFormat, \
								ms.dwMemoryLoad, \
								ms.dwTotalPhys, \
								ms.dwAvailPhys, \
								ms.dwTotalPageFile, \
								ms.dwAvailPageFile, \
								ms.dwTotalVirtual, \
								ms.dwAvailVirtual
invoke MessageBox, NULL, addr buffer, $CTA0("Memory Info"), MB_OK
invoke ExitProcess, 0
end start


:::::::::::::::::::::::::::::::::::::: Ready To Compile Ex 2 :::::::::::::::::::::::::::::::::::::::

.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
include \masm32\Macros\Strings.mac

.code
start:
invoke WinHelp, NULL, $CTA0("\\masm32\\help\\masm32.hlp", 4), HELP_CONTENTS, 0
invoke ExitProcess, 0
end start


:::::::::::::::::::::::::::::::::::::: Ready To Compile Ex 3 :::::::::::::::::::::::::::::::::::::::

.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
include \masm32\Macros\Strings.mac

.code
start:
invoke MessageBox, NULL, $CTA0("Cool program v1.0\nCopyright � Cool Coder, 2005"), $CTA0("About"), MB_OK
invoke ExitProcess, 0
end start


:::::::::::::::::::::::::::::::::::::: Ready To Compile Ex 4 :::::::::::::::::::::::::::::::::::::::

.386
.model flat, stdcall
option casemap:none

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

include \masm32\Macros\Strings.mac


; under NT define 1
; under w9x define 0

UNICODE = 0

LoadLibraryA proto :DWORD
LoadLibraryW proto :DWORD

IF UNICODE EQ 1
	LoadLibrary equ <LoadLibraryW>
ELSE
	LoadLibrary equ <LoadLibraryA>
ENDIF

GetProcAddress proto :DWORD, :DWORD
ExitProcess proto :DWORD
MessageBoxA proto :DWORD, :DWORD, :DWORD, :DWORD
MessageBoxW proto :DWORD, :DWORD, :DWORD, :DWORD

IF UNICODE EQ 1
	MessageBox equ <MessageBoxW>
ELSE
	MessageBox equ <MessageBoxA>
ENDIF

wsprintfA proto C :DWORD, :DWORD, :VARARG
wsprintfW proto C :DWORD, :DWORD, :VARARG

IF UNICODE EQ 1
	wsprintf equ <wsprintfW>
ELSE
	wsprintf equ <wsprintfA>
ENDIF

proto04 TYPEDEF proto :DWORD, :DWORD, :DWORD, :DWORD
pproto04 TYPEDEF PTR proto04

.data?
pfnMassageBox	DWORD		?
hinstUser32		DWORD		?
buffer			BYTE 32 dup(?)

.code
start:

invoke LoadLibrary, $CT0("user32.dll", 4)
mov hinstUser32, eax

;; Exported functions names is always ASCII
IF UNICODE EQ 1
	invoke GetProcAddress, hinstUser32, $CTA0("MessageBoxW", 4)
ELSE
	invoke GetProcAddress, hinstUser32, $CTA0("MessageBoxA", 4)
ENDIF

mov pfnMassageBox, eax

invoke wsprintf, addr buffer, $CT0("%08X"), pfnMassageBox

invoke pproto04 ptr [pfnMassageBox], 0, addr buffer, $CT0("MessageBox", 4), 0

invoke ExitProcess, 0

end start


^

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;;IFDEF UNICODE
;;	UNICODE = 1
;;ENDIF

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                            T E X T   M A C R O S   S T A R T                                      
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

SSS_TemporaryString TEXTEQU <>


SSS_NumStringsInConstAnsi = 0
SSS_NumStringsInDataAnsi = 0
SSS_NumStringsInConstUnicode = 0
SSS_NumStringsInDataUnicode = 0

SSS_NumStringsInConstAnsi0 = 0
SSS_NumStringsInDataAnsi0 = 0
SSS_NumStringsInConstUnicode0 = 0
SSS_NumStringsInDataUnicode0 = 0


SSS_ConstAnsi0ZeroString TEXTEQU <>
SSS_DataAnsi0ZeroString TEXTEQU <>
SSS_ConstUnicode0ZeroString TEXTEQU <>
SSS_DataUnicode0ZeroString TEXTEQU <>

SSS_ConstAnsi0ZeroStringAlignment TEXTEQU <0>
SSS_DataAnsi0ZeroStringAlignment TEXTEQU <0>
SSS_ConstUnicode0ZeroStringAlignment TEXTEQU <0>
SSS_DataUnicode0ZeroStringAlignment TEXTEQU <0>


;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                                               STRINGA                                             
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

IFDEF UNICODE
	IF UNICODE NE 0
		STRING equ STRINGW
	ELSE
		STRING equ STRINGA
	ENDIF
ELSE
	;STRING equ STRINGA ;wtf ������ ��������
ENDIF

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

STRINGA MACRO _s_
local txt, str, c, bslash, lq, sc
txt TEXTEQU <>
bslash = 0						;; backslash reached

lq = 0							;; leading quotation mark ( "...... )
sc = 0							;; separating comma ( ...,... )

	str SUBSTR <_s_>, 1

	% FORC cha, <str>
		IF bslash
			bslash = 0
			IF "&cha" EQ "\"
				IF sc
					txt CATSTR txt, <,>
					sc = 0
				ENDIF

				IF lq
					txt CATSTR txt, <&cha>
				ELSE
					txt CATSTR txt, <">, <&cha>			;; add ( " )
					lq = 1								;; set flag
				ENDIF
			ELSE

				IF lq
					txt CATSTR txt, <">					;;"
					lq = 0
					sc = 1
				ENDIF

				IF sc
					txt CATSTR txt, <,>
				ENDIF

				sc = 1

				IF "&cha" EQ "n"			;;  \n   = CR, LF
					txt CATSTR txt, <0Dh,0Ah>
				ELSEIF "&cha" EQ "r"		;;  \r   = CR
					txt CATSTR txt, <0Dh>
				ELSEIF "&cha" EQ "l"		;;  \l   = LF
					txt CATSTR txt, <0Ah>
				ELSEIF "&cha" EQ ":"		;;  \:   = !
					txt CATSTR txt, <21h>
				ELSEIF "&cha" EQ "{"		;;  \{   = (
					txt CATSTR txt, <28h>
				ELSEIF "&cha" EQ "}"		;;  \}   = )
					txt CATSTR txt, <29h>
				ELSEIF "&cha" EQ "["		;;  \[   = <
					txt CATSTR txt, <3Ch>
				ELSEIF "&cha" EQ "]"		;;  \]   = >
					txt CATSTR txt, <3Eh>
				ELSEIF "&cha" EQ "="		;;  \=   = "
					txt CATSTR txt, <22h>
				ELSEIF "&cha" EQ "-"		;;  \-   = '
					txt CATSTR txt, <27h>
				ELSEIF "&cha" EQ "0"		;;  \0   = 0
					txt CATSTR txt, <0h>
				ELSEIF "&cha" EQ "a"		;;  \a   = BEL
					txt CATSTR txt, <7h>
				ELSEIF "&cha" EQ "b"		;;  \b   = BS
					txt CATSTR txt, <8h>
				ELSEIF "&cha" EQ "t"		;;  \t   = HT
					txt CATSTR txt, <9h>
				ELSEIF "&cha" EQ "v"		;;  \v   = VT
					txt CATSTR txt, <0Bh>
				ELSEIF "&cha" EQ "f"		;;  \f   = FF
					txt CATSTR txt, <0Ch>
				ELSEIF "&cha" EQ "*"		;;  \*   = *nothing*
					;; Add nothing. Workaround against "CreateFile" -> "CreateFileA" problem.
					;; See above KNOWN PROBLEMS for details.
					sc = 0
				ELSE
					txt CATSTR txt, <"&cha">
					echo WARNING!: '&cha' : unrecognized character escape sequence
					;; This also can be used to workaround against "CreateFile" -> "CreateFileA" problem.
					;; See above KNOWN PROBLEMS for details.
				ENDIF
			ENDIF
		ELSE
			IF "&cha" EQ "\"
				bslash = 1
			ELSE
				IF sc
					txt CATSTR txt, <,>
					sc = 0
				ENDIF
				IF lq
					txt CATSTR txt, <&cha>
				ELSE
					txt CATSTR txt, <">, <&cha>			;; add leading ( " )
					lq = 1								;; set flag
				ENDIF
			ENDIF
		ENDIF

	ENDM

	IF lq
		txt CATSTR txt, <">					;;"
	ENDIF

	EXITM <txt>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                                               STRINGW                                             
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

STRINGW MACRO _s_
local txt, str, bslash, lq, sc
txt TEXTEQU <>
bslash = 0						;; backslash reached

lq = 0							;; leading quotation mark ( "...... )
sc = 0							;; separating comma ( ...,... )

	str SUBSTR <_s_>, 1

	% FORC cha, <str>
		IF bslash
			bslash = 0
			IF "&cha" EQ "\"

				IF sc
					txt CATSTR txt, <,>
					sc = 0
				ENDIF
				txt CATSTR txt, <"&cha">
				sc = 1
			ELSE
			
				IF lq
					txt CATSTR txt, <">					;;"
					lq = 0
					sc = 1
				ENDIF
	
				IF sc
					txt CATSTR txt, <,>
				ENDIF

				sc = 1

				IF "&cha" EQ "n"			;;  \n   = CR, LF
					txt CATSTR txt, <0Dh,0Ah>
				ELSEIF "&cha" EQ "r"		;;  \r   = CR
					txt CATSTR txt, <0Dh>
				ELSEIF "&cha" EQ "l"		;;  \l   = LF
					txt CATSTR txt, <0Ah>
				ELSEIF "&cha" EQ ":"		;;  \:   = !
					txt CATSTR txt, <21h>
				ELSEIF "&cha" EQ "{"		;;  \{   = (
					txt CATSTR txt, <28h>
				ELSEIF "&cha" EQ "}"		;;  \}   = )
					txt CATSTR txt, <29h>
				ELSEIF "&cha" EQ "["		;;  \[   = <
					txt CATSTR txt, <3Ch>
				ELSEIF "&cha" EQ "]"		;;  \]   = >
					txt CATSTR txt, <3Eh>
				ELSEIF "&cha" EQ "="		;;  \=   = "
					txt CATSTR txt, <22h>
				ELSEIF "&cha" EQ "-"		;;  \-   = '
					txt CATSTR txt, <27h>
				ELSEIF "&cha" EQ "0"		;;  \0   = 0
					txt CATSTR txt, <0h>
				ELSEIF "&cha" EQ "a"		;;  \a   = BEL
					txt CATSTR txt, <7h>
				ELSEIF "&cha" EQ "b"		;;  \b   = BS
					txt CATSTR txt, <8h>
				ELSEIF "&cha" EQ "t"		;;  \t   = HT
					txt CATSTR txt, <9h>
				ELSEIF "&cha" EQ "v"		;;  \v   = VT
					txt CATSTR txt, <0Bh>
				ELSEIF "&cha" EQ "f"		;;  \f   = FF
					txt CATSTR txt, <0Ch>
				ELSEIF "&cha" EQ "*"		;;  \*   = *nothing*
					;; Add nothing. Workaround against "CreateFile" -> "CreateFileA" problem.
					;; See above LIMITATIONS for details.
					sc = 0
				ELSE
					txt CATSTR txt, <"&cha">
					echo WARNING!: '&cha' : unrecognized character escape sequence
					;; This also can be used to workaround against "CreateFile" -> "CreateFileA" problem.
					;; See above LIMITATIONS for details.
				ENDIF
			ENDIF
		ELSE
			IF "&cha" EQ "\"
				bslash = 1
			ELSE
				IF sc
					txt CATSTR txt, <,>
					sc = 0
				ENDIF
				txt CATSTR txt, <"&cha">
				sc = 1
			ENDIF
		ENDIF
	ENDM

	EXITM <txt>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                              MACROS NOT TERMINATING STRING WITH ZERO                              
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                                       TA /CTA / TW / CTW                                          
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

TA MACRO txt, lora, aorl
	local d, aln, sn, line

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	sn TEXTEQU @CurSeg

	.data
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d db STRINGA(%SSS_TemporaryString)
	ELSE
		;;ALIGN aln
		;;d db 0
		;; Do not let define empty string with TA macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : TA macro ERROR! To define empty string use TA0
		.ERR
	ENDIF
	
	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CTA MACRO txt, lora, aorl
	local d, aln, sn, line

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	sn TEXTEQU @CurSeg

	.const
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d db STRINGA(%SSS_TemporaryString)
	ELSE
		;;ALIGN aln
		;;d db 0
		;; Do not let define empty string with CTA macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : CTA macro ERROR! To define empty string use CTA0
		.ERR
	ENDIF

	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

TW MACRO txt, lora, aorl
	local d, aln, sn, line

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : TW macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	sn TEXTEQU @CurSeg

	.data
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d dw STRINGW(%SSS_TemporaryString)
	ELSE
		;;ALIGN aln
		;;d dw 0
		;; Do not let define empty string with TW macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : TW macro ERROR! To define empty string use TW0
		.ERR		
	ENDIF
	
	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CTW MACRO txt, lora, aorl
	local d, aln, sn, line

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : CTW macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	sn TEXTEQU @CurSeg

	.const
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d dw STRINGW(%SSS_TemporaryString)
	ELSE
		;;ALIGN aln
		;;d dw 0
		;; Do not let define empty string with CTW macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : CTW macro ERROR! To define empty string use CTW0
		.ERR	
	ENDIF
	
	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

T MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		TW txt, lora, aorl
	ELSE
		TA txt, lora, aorl
	ENDIF
ELSE
	TA txt, lora, aorl
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CT MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		CTW txt, lora, aorl
	ELSE
		CTA txt, lora, aorl
	ENDIF
ELSE
	CTA txt, lora, aorl
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                                      $TA / $CTA / $TW / $CTW                                      
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CTA MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len, line
	
	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	IF len EQ 0
		;; Do not let define empty string with $TA macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $CTA macro ERROR! To define empty string use $CTA0
		.ERR
	ENDIF
			
	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		count = 1
		WHILE count LE SSS_NumStringsInConstAnsi

			IF len EQ @SizeStr(%@CatStr(<SSS_ConstAnsiStringNo>, %(count)))
				;; Lenght the same. Let's compare.
				IF @InStr(1, %@CatStr(<SSS_ConstAnsiStringNo>, %(count)), %SSS_TemporaryString) EQ 1 
					;; This string was found in base
					defineit = 0		;; Don't add it in base
					d TEXTEQU @CatStr(<SSS_ConstAnsiOffsetNo>, %(count))

					IF aln GT @CatStr(<SSS_ConstAnsiAlignmentNo>, %(count))
						line TEXTEQU %@Line
						% ECHO @FileCur(line) : $CTA macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
					ENDIF

					;; Break the loop
					count = SSS_NumStringsInConstAnsi
				ENDIF
			ENDIF
			count = count + 1
		ENDM

	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.const
		ALIGN aln
		d db STRINGA(%SSS_TemporaryString)

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInConstAnsi = SSS_NumStringsInConstAnsi + 1

		@CatStr(<SSS_ConstAnsiStringNo>, %(SSS_NumStringsInConstAnsi)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_ConstAnsiOffsetNo>, %(SSS_NumStringsInConstAnsi)) TEXTEQU <d>
		@CatStr(<SSS_ConstAnsiAlignmentNo>, %(SSS_NumStringsInConstAnsi)) TEXTEQU <aln>
		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CTW MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len, line
	
	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	IF len EQ 0
		;; Do not let define empty string with $TA macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $CTW macro ERROR! To define empty string use $CTW0
		.ERR
	ENDIF
			
	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $CTW macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		count = 1
		WHILE count LE SSS_NumStringsInConstUnicode

			IF len EQ @SizeStr(%@CatStr(<SSS_ConstUnicodeStringNo>, %(count)))
				;; Lenght the same. Let's compare.
				IF @InStr(1, %@CatStr(<SSS_ConstUnicodeStringNo>, %(count)), %SSS_TemporaryString) EQ 1 
					;; This string was found in base
					defineit = 0		;; Don't add it in base
					d TEXTEQU @CatStr(<SSS_ConstUnicodeOffsetNo>, %(count))

					IF aln GT @CatStr(<SSS_ConstUnicodeAlignmentNo>, %(count))
						line TEXTEQU %@Line
						% ECHO @FileCur(line) : $CTW macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
					ENDIF

					;; Break the loop
					count = SSS_NumStringsInConstUnicode
				ENDIF
			ENDIF
			count = count + 1
		ENDM

	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.const
		ALIGN aln
		d dw STRINGW(%SSS_TemporaryString)

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInConstUnicode = SSS_NumStringsInConstUnicode + 1

		@CatStr(<SSS_ConstUnicodeStringNo>, %(SSS_NumStringsInConstUnicode)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_ConstUnicodeOffsetNo>, %(SSS_NumStringsInConstUnicode)) TEXTEQU <d>
		@CatStr(<SSS_ConstUnicodeAlignmentNo>, %(SSS_NumStringsInConstUnicode)) TEXTEQU <aln>
		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CT MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		EXITM $CTW(txt, lora, aorl)
	ELSE
		EXITM $CTA(txt, lora, aorl)
	ENDIF
ELSE
	EXITM $CTA(txt, lora, aorl)
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$TA MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len, line
	
	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	IF len EQ 0
		;; Do not let define empty string with $TA macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $TA macro ERROR! To define empty string use $TA0
		.ERR
	ENDIF
			
	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		count = 1
		WHILE count LE SSS_NumStringsInDataAnsi

			IF len EQ @SizeStr(%@CatStr(<SSS_DataAnsiStringNo>, %(count)))
				;; Lenght the same. Let's compare.
				IF @InStr(1, %@CatStr(<SSS_DataAnsiStringNo>, %(count)), %SSS_TemporaryString) EQ 1 
					;; This string was found in base
					defineit = 0		;; Don't add it in base
					d TEXTEQU @CatStr(<SSS_DataAnsiOffsetNo>, %(count))

					IF aln GT @CatStr(<SSS_DataAnsiAlignmentNo>, %(count))
						line TEXTEQU %@Line
						% ECHO @FileCur(line) : $TA macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
					ENDIF

					;; Break the loop
					count = SSS_NumStringsInDataAnsi
				ENDIF
			ENDIF
			count = count + 1
		ENDM

	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.data
		ALIGN aln
		d db STRINGA(%SSS_TemporaryString)

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInDataAnsi = SSS_NumStringsInDataAnsi + 1

		@CatStr(<SSS_DataAnsiStringNo>, %(SSS_NumStringsInDataAnsi)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_DataAnsiOffsetNo>, %(SSS_NumStringsInDataAnsi)) TEXTEQU <d>
		@CatStr(<SSS_DataAnsiAlignmentNo>, %(SSS_NumStringsInDataAnsi)) TEXTEQU <aln>
		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$TW MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len, line
	
	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	IF len EQ 0
		;; Do not let define empty string with $TW macro
		;; because it defines non-zero terminating strings.
		;; So, empty non-zero terminating string... What's this for?
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $TW macro ERROR! To define empty string use $TW0
		.ERR
	ENDIF
			
	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $TW macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF
	
	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		count = 1
		WHILE count LE SSS_NumStringsInDataUnicode

			IF len EQ @SizeStr(%@CatStr(<SSS_DataUnicodeStringNo>, %(count)))
				;; Lenght the same. Let's compare.
				IF @InStr(1, %@CatStr(<SSS_DataUnicodeStringNo>, %(count)), %SSS_TemporaryString) EQ 1 
					;; This string was found in base
					defineit = 0		;; Don't add it in base
					d TEXTEQU @CatStr(<SSS_DataUnicodeOffsetNo>, %(count))

					IF aln GT @CatStr(<SSS_DataUnicodeAlignmentNo>, %(count))
						line TEXTEQU %@Line
						% ECHO @FileCur(line) : $TW macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
					ENDIF

					;; Break the loop
					count = SSS_NumStringsInDataUnicode
				ENDIF
			ENDIF
			count = count + 1
		ENDM

	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.data
		ALIGN aln
		d dw STRINGW(%SSS_TemporaryString)

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInDataUnicode = SSS_NumStringsInDataUnicode + 1

		@CatStr(<SSS_DataUnicodeStringNo>, %(SSS_NumStringsInDataUnicode)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_DataUnicodeOffsetNo>, %(SSS_NumStringsInDataUnicode)) TEXTEQU <d>
		@CatStr(<SSS_DataUnicodeAlignmentNo>, %(SSS_NumStringsInDataUnicode)) TEXTEQU <aln>
		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$T MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		EXITM $TW(txt, lora, aorl)
	ELSE
		EXITM $TA(txt, lora, aorl)
	ENDIF
ELSE
	EXITM $TA(txt, lora, aorl)
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                               MACROS TERMINATING STRING WITH ZERO                                 
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                                     TA0 / CTA0 / TW0 / CTW0                                       
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

TA0 MACRO txt, lora, aorl
	local d, aln, sn

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	sn TEXTEQU @CurSeg

	.data
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d db STRINGA(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		d db 0		
	ENDIF

	@CurSeg ENDS
	sn SEGMENT
	
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

TW0 MACRO txt, lora, aorl
	local d, aln, sn, line

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : TW0 macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	sn TEXTEQU @CurSeg

	.data
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d dw STRINGW(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		d dw 0		
	ENDIF

	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

T0 MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		TW0 txt, lora, aorl
	ELSE
		TA0 txt, lora, aorl
	ENDIF
ELSE
	TA0 txt, lora, aorl
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CTA0 MACRO txt, lora, aorl
	local d, aln, sn

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	sn TEXTEQU @CurSeg

	.const
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d db STRINGA(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		d db 0		
	ENDIF
	
	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CTW0 MACRO txt, lora, aorl
	local d, aln, sn, line

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : CTW0 macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	sn TEXTEQU @CurSeg

	.const
	IF @SizeStr(%SSS_TemporaryString)
		ALIGN aln
		d dw STRINGW(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		d dw 0		
	ENDIF
	
	@CurSeg ENDS
	sn SEGMENT

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CT0 MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		CTW0 txt, lora, aorl
	ELSE
		CTA0 txt, lora, aorl
	ENDIF
ELSE
	CTA0 txt, lora, aorl
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                                     $TA0 / $CTA0 / $TW0 / $CTW0                                   
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$TA0 MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len

	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		IF len NE 0
			count = 1
			WHILE count LE SSS_NumStringsInDataAnsi0

				IF len EQ @SizeStr(%@CatStr(<SSS_DataAnsi0StringNo>, %(count)))
					;; Lenght the same. Let's compare.
					IF @InStr(1, %@CatStr(<SSS_DataAnsi0StringNo>, %(count)), %SSS_TemporaryString) EQ 1 
						;; This string was found in base
						defineit = 0		;; Don't add it in base
						d TEXTEQU @CatStr(<SSS_DataAnsi0OffsetNo>, %(count))

						IF aln GT @CatStr(<SSS_DataAnsi0AlignmentNo>, %(count))
							line TEXTEQU %@Line
							% ECHO @FileCur(line) : $TA0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
						ENDIF

						;; Break the loop
						count = SSS_NumStringsInDataAnsi0
					ENDIF
				ENDIF
				count = count + 1
			ENDM
		ELSE
			;; Empty string
			IF @SizeStr(%SSS_DataAnsi0ZeroString)
				d TEXTEQU SSS_DataAnsi0ZeroString
				defineit = 0		;; Don't add it in base
			
				IF aln GT SSS_DataAnsi0ZeroStringAlignment
					line TEXTEQU %@Line
					% ECHO @FileCur(line) : $TA0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
				ENDIF

			ENDIF
		ENDIF
	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.data
		IF len NE 0
			ALIGN aln
			d db STRINGA(%SSS_TemporaryString), 0
		ELSE
			ALIGN aln
			d db 0							;; empty str
		ENDIF

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInDataAnsi0 = SSS_NumStringsInDataAnsi0 + 1

		@CatStr(<SSS_DataAnsi0StringNo>, %(SSS_NumStringsInDataAnsi0)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_DataAnsi0OffsetNo>, %(SSS_NumStringsInDataAnsi0)) TEXTEQU <d>
		@CatStr(<SSS_DataAnsi0AlignmentNo>, %(SSS_NumStringsInDataAnsi0)) TEXTEQU <aln>

		IFE @SizeStr(%SSS_TemporaryString)
			SSS_DataAnsi0ZeroString TEXTEQU <d>
			SSS_DataAnsi0ZeroStringAlignment TEXTEQU <aln>
		ENDIF

		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$TW0 MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len, line

	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $TW0 macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		IF len NE 0
			count = 1
			WHILE count LE SSS_NumStringsInDataUnicode0

				IF len EQ @SizeStr(%@CatStr(<SSS_DataUnicode0StringNo>, %(count)))
					;; Lenght the same. Let's compare.
					IF @InStr(1, %@CatStr(<SSS_DataUnicode0StringNo>, %(count)), %SSS_TemporaryString) EQ 1 
						;; This string was found in base
						defineit = 0		;; Don't add it in base
						d TEXTEQU @CatStr(<SSS_DataUnicode0OffsetNo>, %(count))

						IF aln GT @CatStr(<SSS_DataUnicode0AlignmentNo>, %(count))
							line TEXTEQU %@Line
							% ECHO @FileCur(line) : $TW0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
						ENDIF

						;; Break the loop
						count = SSS_NumStringsInDataUnicode0
					ENDIF
				ENDIF
				count = count + 1
			ENDM
		ELSE
			;; Empty string
			IF @SizeStr(%SSS_DataUnicode0ZeroString)
				d TEXTEQU SSS_DataUnicode0ZeroString
				defineit = 0		;; Don't add it in base
			
				IF aln GT SSS_DataUnicode0ZeroStringAlignment
					line TEXTEQU %@Line
					% ECHO @FileCur(line) : $TW0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
				ENDIF

			ENDIF
		ENDIF
	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.data
		IF len NE 0
			ALIGN aln
			d dw STRINGW(%SSS_TemporaryString), 0
		ELSE
			ALIGN aln
			d dw 0							;; empty str
		ENDIF

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInDataUnicode0 = SSS_NumStringsInDataUnicode0 + 1

		@CatStr(<SSS_DataUnicode0StringNo>, %(SSS_NumStringsInDataUnicode0)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_DataUnicode0OffsetNo>, %(SSS_NumStringsInDataUnicode0)) TEXTEQU <d>
		@CatStr(<SSS_DataUnicode0AlignmentNo>, %(SSS_NumStringsInDataUnicode0)) TEXTEQU <aln>

		IFE @SizeStr(%SSS_TemporaryString)
			SSS_DataUnicode0ZeroString TEXTEQU <d>
			SSS_DataUnicode0ZeroStringAlignment TEXTEQU <aln>
		ENDIF

		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$T0 MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		EXITM $TW0(txt, lora, aorl)
	ELSE
		EXITM $TA0(txt, lora, aorl)
	ENDIF
ELSE
	EXITM $TA0(txt, lora, aorl)
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CTA0 MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len

	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <1>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		IF len NE 0
			count = 1
			WHILE count LE SSS_NumStringsInConstAnsi0

				IF len EQ @SizeStr(%@CatStr(<SSS_ConstAnsi0StringNo>, %(count)))
					;; Lenght the same. Let's compare.
					IF @InStr(1, %@CatStr(<SSS_ConstAnsi0StringNo>, %(count)), %SSS_TemporaryString) EQ 1 
						;; This string was found in base
						defineit = 0		;; Don't add it in base
						d TEXTEQU @CatStr(<SSS_ConstAnsi0OffsetNo>, %(count))

						IF aln GT @CatStr(<SSS_ConstAnsi0AlignmentNo>, %(count))
							line TEXTEQU %@Line
							% ECHO @FileCur(line) : $CTA0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
						ENDIF

						;; Break the loop
						count = SSS_NumStringsInConstAnsi0
					ENDIF
				ENDIF
				count = count + 1
			ENDM
		ELSE
			;; Empty string
			IF @SizeStr(%SSS_ConstAnsi0ZeroString)
				d TEXTEQU SSS_ConstAnsi0ZeroString
				defineit = 0		;; Don't add it in base
			
				IF aln GT SSS_ConstAnsi0ZeroStringAlignment
					line TEXTEQU %@Line
					% ECHO @FileCur(line) : $CTA0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
				ENDIF

			ENDIF
		ENDIF
	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.const
		IF len NE 0
			ALIGN aln
			d db STRINGA(%SSS_TemporaryString), 0
		ELSE
			ALIGN aln
			d db 0							;; empty str
		ENDIF

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInConstAnsi0 = SSS_NumStringsInConstAnsi0 + 1

		@CatStr(<SSS_ConstAnsi0StringNo>, %(SSS_NumStringsInConstAnsi0)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_ConstAnsi0OffsetNo>, %(SSS_NumStringsInConstAnsi0)) TEXTEQU <d>
		@CatStr(<SSS_ConstAnsi0AlignmentNo>, %(SSS_NumStringsInConstAnsi0)) TEXTEQU <aln>

		IFE @SizeStr(%SSS_TemporaryString)
			SSS_ConstAnsi0ZeroString TEXTEQU <d>
			SSS_ConstAnsi0ZeroStringAlignment TEXTEQU <aln>
		ENDIF

		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CTW0 MACRO txt, lora, aorl
	local d, aln, sn, count, defineit, len, line

	;; defineit - flag: 1 - define this string
	;;                  0 - do not define

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	;; If DISABLE_STRING_POOLING defined, disable double-definition tracking

	IFDEF DISABLE_STRING_POOLING
		defineit = 1
	ELSE
		defineit = 0
	ENDIF

	;;
	;; What about label and alignment
	;;
	
	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			d TEXTEQU <lora>
			defineit = 1
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			d TEXTEQU <aorl>
			defineit = 1
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $CTW0 macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	;;
	;; Search in base for this string
	;;

	IF defineit EQ 0
	
		defineit = 1

		IF len NE 0
			count = 1
			WHILE count LE SSS_NumStringsInConstUnicode0

				IF len EQ @SizeStr(%@CatStr(<SSS_ConstUnicode0StringNo>, %(count)))
					;; Lenght the same. Let's compare.
					IF @InStr(1, %@CatStr(<SSS_ConstUnicode0StringNo>, %(count)), %SSS_TemporaryString) EQ 1 
						;; This string was found in base
						defineit = 0		;; Don't add it in base
						d TEXTEQU @CatStr(<SSS_ConstUnicode0OffsetNo>, %(count))

						IF aln GT @CatStr(<SSS_ConstUnicode0AlignmentNo>, %(count))
							line TEXTEQU %@Line
							% ECHO @FileCur(line) : $CTW0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
						ENDIF

						;; Break the loop
						count = SSS_NumStringsInConstUnicode0
					ENDIF
				ENDIF
				count = count + 1
			ENDM
		ELSE
			;; Empty string
			IF @SizeStr(%SSS_ConstUnicode0ZeroString)
				d TEXTEQU SSS_ConstUnicode0ZeroString
				defineit = 0		;; Don't add it in base
			
				IF aln GT SSS_ConstUnicode0ZeroStringAlignment
					line TEXTEQU %@Line
					% ECHO @FileCur(line) : $CTW0 macro WARNING! Alignment is greater then previous instance of "&SSS_TemporaryString&".
				ENDIF

			ENDIF
		ENDIF
	ENDIF	;; IF defineit EQ 0

	;;
	;; To be or not to be?
	;;

	IF defineit EQ 1

		;; If string previously defined but label for this text passed to macro define it anyway

		sn TEXTEQU @CurSeg

		.const
		IF len NE 0
			ALIGN aln
			d dw STRINGW(%SSS_TemporaryString), 0
		ELSE
			ALIGN aln
			d dw 0							;; empty str
		ENDIF

		@CurSeg ENDS
		sn SEGMENT

		IFNDEF DISABLE_STRING_POOLING		;; If DISABLE_STRING_POOLING defined, disable double-definition tracking
		;;
		;; Add string and its offset to database
		;;

		SSS_NumStringsInConstUnicode0 = SSS_NumStringsInConstUnicode0 + 1

		@CatStr(<SSS_ConstUnicode0StringNo>, %(SSS_NumStringsInConstUnicode0)) TEXTEQU SSS_TemporaryString
		@CatStr(<SSS_ConstUnicode0OffsetNo>, %(SSS_NumStringsInConstUnicode0)) TEXTEQU <d>
		@CatStr(<SSS_ConstUnicode0AlignmentNo>, %(SSS_NumStringsInConstUnicode0)) TEXTEQU <aln>

		IFE @SizeStr(%SSS_TemporaryString)
			SSS_ConstUnicode0ZeroString TEXTEQU <d>
			SSS_ConstUnicode0ZeroStringAlignment TEXTEQU <aln>
		ENDIF

		ENDIF

	ENDIF

	EXITM <offset d>
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CT0 MACRO txt, lora, aorl
IFDEF UNICODE
	IF UNICODE NE 0
		EXITM $CTW0(txt, lora, aorl)
	ELSE
		EXITM $CTA0(txt, lora, aorl)
	ENDIF
ELSE
	EXITM $CTA0(txt, lora, aorl)
ENDIF
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                     COUNTED_UNICODE_STRING / $COUNTED_UNICODE_STRING                              
;                    CCOUNTED_UNICODE_STRING / $CCOUNTED_UNICODE_STRING                             
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

IFNDEF UNICODE_STRING
	UNICODE_STRING STRUCT
		woLength		WORD	?		; len of string in bytes (not chars)
		MaximumLength	WORD	?		; len of Buffer in bytes (not chars)
		Buffer			DWORD	?		; pointer to string
	UNICODE_STRING ENDS
	PUNICODE_STRING	typedef	PTR UNICODE_STRING
ENDIF

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

COUNTED_UNICODE_STRING MACRO txt, lora, aorl

	local dum, segn, us, line, len

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			us TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			us TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : COUNTED_UNICODE_STRING macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	segn TEXTEQU @CurSeg

	.data
	IF len NE 0
		ALIGN aln
		dum dw STRINGW(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		dum dw 0		
	ENDIF

	ALIGN 4

	us UNICODE_STRING {(sizeof dum)-2, sizeof dum, offset dum}

	@CurSeg ENDS
	segn SEGMENT
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CCOUNTED_UNICODE_STRING MACRO txt, lora, aorl

	local dum, segn, us, line, len
	
	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			us TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			us TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : CCOUNTED_UNICODE_STRING macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	segn TEXTEQU @CurSeg

	.const
	IF len NE 0
		ALIGN aln
		dum dw STRINGW(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		dum dw 0		
	ENDIF

	ALIGN 4

	us UNICODE_STRING {(sizeof dum)-2, sizeof dum, offset dum}

	@CurSeg ENDS
	segn SEGMENT
ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$COUNTED_UNICODE_STRING MACRO txt, lora, aorl

	local dum, segn, us, line, len

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			us TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			us TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $COUNTED_UNICODE_STRING macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	segn TEXTEQU @CurSeg

	.data
	IF len NE 0
		ALIGN aln
		dum dw STRINGW(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		dum dw 0		
	ENDIF

	ALIGN 4

	us UNICODE_STRING {(sizeof dum)-2, sizeof dum, offset dum}
	@CurSeg ENDS
	segn SEGMENT
	EXITM <offset us>

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

$CCOUNTED_UNICODE_STRING MACRO txt, lora, aorl

	local dum, segn, us, line, len

	;; remove quotation marks if not empty string

	IFNB <txt>
		SSS_TemporaryString SUBSTR <txt>, 2, @SizeStr(<txt>) - 2
	ELSE
		SSS_TemporaryString TEXTEQU <>
	ENDIF

	len TEXTEQU @SizeStr(%SSS_TemporaryString)

	aln TEXTEQU <2>

	IFNB <lora>
		IF (OPATTR (lora)) AND 00000100y	;; immediate value ?
			;; yes -> lora is alignment
			aln TEXTEQU %lora
		ELSE
			;; no -> lora is label
			us TEXTEQU <lora>
		ENDIF
	ENDIF

	IFNB <aorl>
		IF (OPATTR (aorl)) AND 00000100y	;; immediate value ?
			;; yes -> aorl is alignment
			aln TEXTEQU %aorl
		ELSE
			;; no -> aorl is label
			us TEXTEQU <aorl>
		ENDIF
	ENDIF

	IF aln LT 2
		line TEXTEQU %@Line
		% ECHO @FileCur(line) : $CCOUNTED_UNICODE_STRING macro WARNING! Alignment for Unicode string must be at least 2 bytes.
	ENDIF

	segn TEXTEQU @CurSeg

	.const
	IF len NE 0
		ALIGN aln
		dum dw STRINGW(%SSS_TemporaryString), 0
	ELSE
		ALIGN aln
		dum dw 0		
	ENDIF

	ALIGN 4

	us UNICODE_STRING {(sizeof dum)-2, sizeof dum, offset dum}
	@CurSeg ENDS
	segn SEGMENT
	EXITM <offset us>

ENDM

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;                              T E X T   M A C R O S   E N D                                        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
