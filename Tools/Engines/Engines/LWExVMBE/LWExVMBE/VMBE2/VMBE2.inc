; VMBE 2.1
;
; (c) Indy, 2013
;
; o IA32, UM, MI
;
RGP struct
rEdi		DWORD ?
rEsi		DWORD ?
rEbp		DWORD ?
rEsp		DWORD ?
rEbx		DWORD ?
rEdx		DWORD ?
rEcx		DWORD ?
rEax		DWORD ?
RGP ends
PRGP typedef ptr RGP

TSTATE struct
Rgp		RGP <>
EFlags	DWORD ?
Ip		DWORD ?
TSTATE ends
PTSTATE typedef ptr TSTATE

; typedef ULONG (*PENTRY)(
;	IN PVOID BufferRWE,
;	IN PVOID Ip,
;	IN PCALLBACK Callback OPTIONAL,
;	IN PVOID CallbackArg,
;	IN ULONG ArgN,
;	IN PVOID Args
;	)
;
; typedef struct _TSTATE {
;	ULONG rEdi
;	ULONG rEsi
;	ULONG rEbp
;	ULONG rEsp
;	ULONG rEbx
;	ULONG rEdx
;	ULONG rEcx
;	ULONG rEax
;	ULONG rEFlags
; } TSTATE
;
; typedef NTSTATUS (*PCALLBACK)(
;	IN PVOID CallbackArg,
;	IN PVOID Ip,
;	IN PTSTATE State
;	)
;
MI:
; __________________ Autogenerated dump _____________________
DB 0E9H, 069H, 004H, 000H, 000H, 060H, 068H, 010H, 015H, 000H
DB 000H, 068H, 0FFH, 001H, 001H, 010H, 068H, 055H, 0FFH, 0FFH
DB 0FFH, 06AH, 0F8H, 068H, 0A0H, 07FH, 0FFH, 0F8H, 068H, 00DH
DB 0C4H, 00EH, 00FH, 068H, 004H, 010H, 055H, 007H, 068H, 0FFH
DB 005H, 0D0H, 001H, 068H, 055H, 05DH, 00DH, 055H, 068H, 088H
DB 00FH, 05FH, 055H, 068H, 0FFH, 0FFH, 0F3H, 0F3H, 068H, 054H
DB 011H, 00CH, 00AH, 08BH, 0D6H, 08BH, 0F4H, 06AH, 019H, 068H
DB 080H, 00BH, 0ACH, 0B0H, 068H, 03EH, 0F3H, 0B1H, 0BFH, 068H
DB 058H, 0EAH, 011H, 000H, 08BH, 0DCH, 083H, 0ECH, 070H, 08BH
DB 0FCH, 0FCH, 06AH, 064H, 059H, 00FH, 0A3H, 00BH, 0D6H, 073H
DB 001H, 0ACH, 0AAH, 0E2H, 0F6H, 08BH, 0F2H, 06AH, 002H, 05BH
DB 08BH, 0D3H, 0ACH, 050H, 050H, 03CH, 066H, 00FH, 044H, 0D9H
DB 03CH, 067H, 00FH, 044H, 0D1H, 03CH, 0EAH, 074H, 005H, 03CH
DB 09AH, 075H, 005H, 046H, 08DH, 074H, 033H, 003H, 03CH, 0C8H
DB 074H, 006H, 024H, 0F7H, 03CH, 0C2H, 075H, 002H, 046H, 046H
DB 024H, 0E7H, 03CH, 026H, 058H, 074H, 014H, 03CH, 0F1H, 074H
DB 00EH, 024H, 0FCH, 03CH, 0A0H, 075H, 004H, 08DH, 074H, 032H
DB 002H, 03CH, 0F0H, 074H, 002H, 03CH, 064H, 058H, 074H, 0BCH
DB 08BH, 0FCH, 052H, 050H, 03CH, 00FH, 075H, 001H, 0ACH, 09CH
DB 0D4H, 010H, 086H, 0CCH, 098H, 099H, 033H, 0EDH, 09DH, 075H
DB 016H, 083H, 0C7H, 035H, 0E3H, 00DH, 00FH, 0A3H, 02FH, 073H
DB 001H, 042H, 045H, 0E2H, 0F7H, 072H, 002H, 0D6H, 099H, 0D1H
DB 0E2H, 0EBH, 018H, 080H, 0E9H, 004H, 079H, 004H, 0B1H, 00CH
DB 024H, 007H, 0E3H, 00BH, 080H, 0D2H, 001H, 045H, 00FH, 0A3H
DB 02FH, 0E2H, 0F7H, 072H, 002H, 0D0H, 0E8H, 086H, 0C8H, 08DH
DB 014H, 0D1H, 059H, 05DH, 00FH, 0A3H, 057H, 002H, 073H, 03BH
DB 0ACH, 0D4H, 008H, 0C0H, 0E4H, 004H, 073H, 002H, 078H, 01FH
DB 09CH, 085H, 0EDH, 075H, 006H, 02CH, 006H, 075H, 009H, 0B0H
DB 005H, 03CH, 004H, 075H, 003H, 0ACH, 024H, 007H, 09DH, 072H
DB 006H, 078H, 007H, 03CH, 005H, 075H, 004H, 003H, 0F5H, 046H
DB 046H, 0F6H, 0C4H, 060H, 075H, 00DH, 091H, 03CH, 0F6H, 074H
DB 007H, 03CH, 0F7H, 075H, 004H, 003H, 0F3H, 046H, 046H, 0D1H
DB 0E2H, 00FH, 0A3H, 057H, 013H, 073H, 00AH, 042H, 00FH, 0A3H
DB 057H, 013H, 073H, 002H, 013H, 0F3H, 046H, 081H, 0C4H, 0B0H
DB 000H, 000H, 000H, 02BH, 074H, 024H, 004H, 089H, 074H, 024H
DB 01CH, 061H, 0C3H, 055H, 08BH, 0ECH, 083H, 0C4H, 0F0H, 053H
DB 056H, 057H, 0C7H, 045H, 0F0H, 010H, 000H, 000H, 000H, 0C7H
DB 045H, 0F4H, 0F0H, 0F2H, 0F3H, 02EH, 0C7H, 045H, 0F8H, 03EH
DB 036H, 026H, 064H, 0C7H, 045H, 0FCH, 065H, 066H, 067H, 000H
DB 08BH, 075H, 008H, 0FCH, 08DH, 055H, 0F4H, 033H, 0DBH, 0FFH
DB 04DH, 0F0H, 075H, 006H, 033H, 0C0H, 033H, 0C9H, 0EBH, 025H
DB 0ACH, 08BH, 0FAH, 03CH, 067H, 0B9H, 00BH, 000H, 000H, 000H
DB 075H, 003H, 080H, 0CBH, 001H, 0F2H, 0AEH, 074H, 0E2H, 04EH
DB 033H, 0C0H, 00FH, 0B6H, 04EH, 0FFH, 02BH, 075H, 008H, 075H
DB 004H, 033H, 0C9H, 0EBH, 002H, 08BH, 0C6H, 08BH, 0D3H, 05FH
DB 05EH, 05BH, 0C9H, 0C2H, 004H, 000H, 055H, 08BH, 0ECH, 053H
DB 056H, 057H, 08BH, 05DH, 008H, 033H, 0FFH, 00FH, 0B6H, 003H
DB 08BH, 075H, 010H, 08BH, 0D0H, 0F6H, 0D0H, 0C0H, 0C2H, 002H
DB 024H, 007H, 080H, 0E2H, 003H, 074H, 00DH, 0FEH, 0CAH, 074H
DB 026H, 0FEH, 0CAH, 074H, 046H, 08BH, 004H, 086H, 0EBH, 066H
DB 03CH, 003H, 074H, 011H, 03CH, 002H, 074H, 005H, 08BH, 004H
DB 086H, 0EBH, 04CH, 08BH, 043H, 001H, 083H, 0C7H, 004H, 0EBH
DB 044H, 0E8H, 055H, 000H, 000H, 000H, 047H, 0EBH, 03CH, 03CH
DB 003H, 074H, 018H, 08BH, 004H, 086H, 00FH, 0B6H, 054H, 01FH
DB 001H, 047H, 00FH, 0BAH, 0F2H, 007H, 073H, 005H, 02DH, 080H
DB 000H, 000H, 000H, 003H, 0C2H, 0EBH, 020H, 0E8H, 031H, 000H
DB 000H, 000H, 047H, 0EBH, 0E3H, 03CH, 003H, 074H, 00CH, 08BH
DB 004H, 086H, 003H, 044H, 01FH, 001H, 083H, 0C7H, 004H, 0EBH
DB 008H, 0E8H, 019H, 000H, 000H, 000H, 047H, 0EBH, 0EFH, 083H
DB 07DH, 00CH, 064H, 075H, 005H, 064H, 08BH, 000H, 0EBH, 002H
DB 08BH, 000H, 08BH, 0CFH, 05FH, 05EH, 05BH, 0C9H, 0C2H, 00CH
DB 000H, 00FH, 0B6H, 043H, 001H, 08BH, 0C8H, 0F6H, 0D0H, 050H
DB 0C0H, 0C1H, 002H, 0D1H, 0E8H, 080H, 0E1H, 003H, 024H, 01CH
DB 08BH, 004H, 030H, 0D3H, 0E0H, 059H, 080H, 0E1H, 007H, 080H
DB 0F9H, 002H, 075H, 00CH, 00AH, 0D2H, 075H, 008H, 003H, 043H
DB 002H, 083H, 0C7H, 004H, 0EBH, 003H, 003H, 004H, 08EH, 0C3H
DB 055H, 08BH, 0ECH, 083H, 065H, 008H, 00FH, 08BH, 045H, 008H
DB 08BH, 04DH, 00CH, 083H, 065H, 008H, 001H, 0E8H, 00AH, 000H
DB 000H, 000H, 00FH, 092H, 0C0H, 031H, 045H, 008H, 0C9H, 0C2H
DB 008H, 000H, 0D1H, 0E8H, 083H, 0E0H, 007H, 074H, 038H, 0FEH
DB 0C8H, 074H, 039H, 0FEH, 0C8H, 074H, 03AH, 0FEH, 0C8H, 074H
DB 045H, 0FEH, 0C8H, 074H, 037H, 0FEH, 0C8H, 074H, 038H, 0FEH
DB 0C8H, 074H, 009H, 0FEH, 0C8H, 00FH, 0BAH, 0E1H, 006H, 073H
DB 001H, 0C3H, 0F7H, 0C1H, 080H, 000H, 000H, 000H, 00FH, 0BAH
DB 0E1H, 00BH, 075H, 004H, 072H, 007H, 0EBH, 002H, 073H, 003H
DB 033H, 0C0H, 0C3H, 0F9H, 0C3H, 00FH, 0BAH, 0E1H, 00BH, 0C3H
DB 00FH, 0BAH, 0E1H, 000H, 0C3H, 00FH, 0BAH, 0E1H, 006H, 0C3H
DB 00FH, 0BAH, 0E1H, 007H, 0C3H, 00FH, 0BAH, 0E1H, 002H, 0C3H
DB 0F7H, 0C1H, 041H, 000H, 000H, 000H, 075H, 0DDH, 0C3H, 055H
DB 08BH, 0ECH, 053H, 08BH, 05DH, 008H, 00FH, 0B6H, 003H, 03CH
DB 00FH, 074H, 03FH, 03CH, 070H, 00FH, 082H, 09BH, 000H, 000H
DB 000H, 03CH, 07FH, 077H, 058H, 0FFH, 075H, 00CH, 050H, 0E8H
DB 05CH, 0FFH, 0FFH, 0FFH, 075H, 009H, 00FH, 0B6H, 043H, 001H
DB 083H, 0C3H, 002H, 0EBH, 01DH, 00FH, 0B6H, 043H, 001H, 00FH
DB 0BAH, 0F0H, 007H, 073H, 005H, 02DH, 080H, 000H, 000H, 000H
DB 08DH, 05CH, 003H, 002H, 00BH, 0D2H, 074H, 006H, 081H, 0E3H
DB 0FFH, 0FFH, 000H, 000H, 0EBH, 05DH, 00FH, 0B6H, 043H, 001H
DB 03CH, 080H, 072H, 05CH, 03CH, 08FH, 077H, 058H, 0FFH, 075H
DB 00CH, 050H, 0E8H, 01DH, 0FFH, 0FFH, 0FFH, 075H, 005H, 083H
DB 0C3H, 006H, 0EBH, 007H, 08BH, 043H, 002H, 08DH, 05CH, 003H
DB 006H, 0EBH, 038H, 08BH, 04DH, 010H, 02CH, 0E0H, 072H, 038H
DB 03CH, 003H, 077H, 034H, 075H, 00BH, 00FH, 0BAH, 065H, 00CH
DB 006H, 0FFH, 009H, 077H, 0A6H, 0EBH, 01DH, 048H, 075H, 00CH
DB 00FH, 0BAH, 065H, 00CH, 006H, 0FFH, 009H, 0F5H, 077H, 097H
DB 0EBH, 00EH, 048H, 075H, 006H, 0FFH, 009H, 075H, 08EH, 0EBH
DB 005H, 083H, 039H, 000H, 074H, 087H, 083H, 0C3H, 002H, 08BH
DB 0C3H, 05BH, 0C9H, 0C2H, 00CH, 000H, 033H, 0C0H, 0EBH, 0F7H
DB 055H, 08BH, 0ECH, 053H, 08BH, 05DH, 008H, 00FH, 0B6H, 003H
DB 03CH, 0EBH, 075H, 015H, 00FH, 0B6H, 043H, 001H, 00FH, 0BAH
DB 0F0H, 007H, 073H, 005H, 02DH, 080H, 000H, 000H, 000H, 08DH
DB 044H, 003H, 002H, 0EBH, 02FH, 03CH, 0E9H, 075H, 009H, 08BH
DB 043H, 001H, 08DH, 044H, 003H, 005H, 0EBH, 022H, 03CH, 0FFH
DB 075H, 01CH, 00FH, 0B6H, 043H, 001H, 024H, 038H, 0C0H, 0E8H
DB 003H, 03CH, 004H, 075H, 00FH, 043H, 0FFH, 075H, 010H, 0FFH
DB 075H, 00CH, 053H, 0E8H, 0B0H, 0FDH, 0FFH, 0FFH, 0EBH, 002H
DB 033H, 0C0H, 05BH, 0C9H, 0C2H, 00CH, 000H, 055H, 08BH, 0ECH
DB 053H, 08BH, 05DH, 008H, 00FH, 0B6H, 00BH, 080H, 0F9H, 0E8H
DB 075H, 00CH, 08DH, 048H, 005H, 08BH, 053H, 001H, 08DH, 044H
DB 013H, 005H, 0EBH, 02BH, 080H, 0F9H, 0FFH, 075H, 024H, 00FH
DB 0B6H, 04BH, 001H, 080H, 0E1H, 038H, 0C0H, 0E9H, 003H, 080H
DB 0F9H, 002H, 075H, 015H, 050H, 043H, 0FFH, 075H, 010H, 0FFH
DB 075H, 00CH, 053H, 0E8H, 06AH, 0FDH, 0FFH, 0FFH, 05AH, 08DH
DB 04CH, 00AH, 002H, 0EBH, 002H, 033H, 0C0H, 05BH, 0C9H, 0C2H
DB 00CH, 000H, 058H, 0C3H, 055H, 08BH, 0ECH, 083H, 0C4H, 0F4H
DB 053H, 056H, 057H, 08BH, 04DH, 018H, 064H, 0A1H, 004H, 000H
DB 000H, 000H, 089H, 068H, 0FCH, 089H, 065H, 0FCH, 08BH, 045H
DB 01CH, 00BH, 0C9H, 074H, 007H, 0FFH, 074H, 088H, 0FCH, 049H
DB 075H, 0F9H, 0E8H, 00DH, 000H, 000H, 000H, 061H, 09DH, 08DH
DB 064H, 024H, 004H, 05FH, 05EH, 05BH, 0C9H, 0C2H, 018H, 000H
DB 06AH, 000H, 09CH, 060H, 083H, 06DH, 0FCH, 028H, 083H, 07DH
DB 010H, 000H, 0FCH, 074H, 016H, 054H, 0FFH, 075H, 00CH, 0FFH
DB 075H, 014H, 0FFH, 055H, 010H, 00BH, 0C0H, 074H, 008H, 08BH
DB 065H, 0FCH, 083H, 0C4H, 028H, 0EBH, 0D4H, 08BH, 075H, 00CH
DB 0E8H, 032H, 0FBH, 0FFH, 0FFH, 08BH, 0D8H, 001H, 045H, 00CH
DB 056H, 0E8H, 083H, 0FCH, 0FFH, 0FFH, 089H, 04DH, 0F4H, 08DH
DB 03CH, 030H, 054H, 0FFH, 075H, 0F4H, 057H, 0E8H, 0DCH, 0FEH
DB 0FFH, 0FFH, 085H, 0C0H, 00FH, 085H, 067H, 001H, 000H, 000H
DB 08DH, 044H, 024H, 018H, 050H, 0FFH, 074H, 024H, 024H, 057H
DB 0E8H, 010H, 0FEH, 0FFH, 0FFH, 085H, 0C0H, 00FH, 085H, 050H
DB 001H, 000H, 000H, 054H, 0FFH, 075H, 0F4H, 057H, 0E8H, 00AH
DB 0FFH, 0FFH, 0FFH, 085H, 0C0H, 074H, 017H, 08BH, 055H, 00CH
DB 050H, 08BH, 0FCH, 08DH, 077H, 004H, 0B9H, 00AH, 000H, 000H
DB 000H, 0F3H, 0A5H, 089H, 017H, 0E9H, 02BH, 001H, 000H, 000H
DB 080H, 03EH, 0EAH, 075H, 01BH, 066H, 083H, 07EH, 005H, 033H
DB 075H, 014H, 08BH, 04CH, 024H, 00CH, 0E8H, 01EH, 001H, 000H
DB 000H, 087H, 041H, 004H, 089H, 045H, 00CH, 0E9H, 090H, 000H
DB 000H, 000H, 080H, 03FH, 0C3H, 075H, 017H, 08BH, 044H, 024H
DB 028H, 08DH, 074H, 024H, 024H, 08DH, 07EH, 004H, 0FDH, 0B9H
DB 00AH, 000H, 000H, 000H, 0F3H, 0A5H, 05AH, 0FCH, 0EBH, 022H
DB 080H, 03FH, 0C2H, 075H, 02BH, 08BH, 044H, 024H, 028H, 00FH
DB 0B7H, 057H, 001H, 0FDH, 08DH, 074H, 024H, 024H, 08DH, 07CH
DB 032H, 004H, 0B9H, 00AH, 000H, 000H, 000H, 0F3H, 0A5H, 08DH
DB 064H, 014H, 004H, 0FCH, 039H, 065H, 0FCH, 00FH, 086H, 000H
DB 0FFH, 0FFH, 0FFH, 0E9H, 0BFH, 000H, 000H, 000H, 080H, 03FH
DB 00FH, 075H, 01DH, 080H, 07FH, 001H, 034H, 075H, 017H, 08BH
DB 04CH, 024H, 014H, 0E8H, 0B3H, 000H, 000H, 000H, 087H, 001H
DB 089H, 045H, 00CH, 08BH, 044H, 024H, 014H, 083H, 0C0H, 008H
DB 0EBH, 026H, 080H, 03FH, 0CDH, 075H, 078H, 080H, 07FH, 001H
DB 02DH, 075H, 011H, 08BH, 07DH, 008H, 0C7H, 007H, 0CDH, 02DH
DB 090H, 090H, 0FFH, 045H, 00CH, 083H, 0C7H, 004H, 0EBH, 068H
DB 080H, 07FH, 001H, 02EH, 075H, 05BH, 08BH, 044H, 024H, 014H
DB 064H, 08BH, 00DH, 004H, 000H, 000H, 000H, 039H, 044H, 024H
DB 00CH, 08BH, 07DH, 008H, 077H, 047H, 03BH, 0C1H, 073H, 043H
DB 083H, 078H, 008H, 001H, 08BH, 010H, 075H, 03BH, 039H, 054H
DB 024H, 00CH, 077H, 035H, 03BH, 0D1H, 073H, 031H, 081H, 03AH
DB 006H, 000H, 001H, 040H, 075H, 029H, 083H, 07AH, 010H, 002H
DB 075H, 023H, 08BH, 050H, 004H, 039H, 054H, 024H, 00CH, 077H
DB 01AH, 03BH, 0D1H, 073H, 016H, 081H, 03AH, 007H, 000H, 001H
DB 000H, 075H, 00EH, 0E8H, 031H, 000H, 000H, 000H, 087H, 082H
DB 0B8H, 000H, 000H, 000H, 089H, 045H, 00CH, 08BH, 0CBH, 08BH
DB 07DH, 008H, 0F3H, 0A4H, 0E8H, 01CH, 000H, 000H, 000H, 08BH
DB 04DH, 008H, 0C6H, 007H, 068H, 089H, 047H, 001H, 0C6H, 047H
DB 005H, 0C3H, 089H, 04CH, 024H, 024H, 061H, 09DH, 0C3H, 089H
DB 045H, 00CH, 0E9H, 049H, 0FEH, 0FFH, 0FFH, 0E8H, 002H, 0FEH
DB 0FFH, 0FFH, 06AH, 000H, 09CH, 060H, 064H, 08BH, 02DH, 004H
DB 000H, 000H, 000H, 08BH, 06DH, 0FCH, 0E9H, 031H, 0FEH, 0FFH
DB 0FFH
; __________________________ 0x67D __________________________