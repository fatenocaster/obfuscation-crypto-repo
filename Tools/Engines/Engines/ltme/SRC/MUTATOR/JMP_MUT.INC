;께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께�
;
; Jmp Mutation Module
;
;IN:	EBX = list
;
;께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께�

		lea edi,m__temp

		mov esi,[ebx.list_first]

		xor edx,edx
		inc edx

jmp_mut_main:
		cmp esi,[ebx.list_last]				; last?
		je jmp_mut_exit

		cmp 2 ptr[esi.one_data.ltmed_desc.lc_mask1],800Fh 
		jne jmp_mut_next

;-----------------------------------------------------------------------------

		mov eax,[esi.one_next]				; JCC+1

		cmp [eax.one_data.ltmed_desc.lc_mask1],0E9h	; <JMP> ?
		jne jmp_mut_inverse				;

		cmp eax,[ebx.list_last]
		je jmp_mut_inverse

		mov ecx,[eax.one_next]				; JCC+2

		mov ecx,[ecx.one_data.ltmed_label]
		mov eax,[eax.one_data.ltmed_link]

		cmp [esi.one_data.ltmed_link],ecx		; mutated ?
		jne jmp_mut_inverse

;� REPAIR 같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같

;------------------------------------------------------------------------------
		push eax

                push 30                                         ;커
		push m__seed					; �
                call m__rnd                                     ; � RANDOMIZE
                add esp,8                                       ; �    1/30 
                or eax,eax                                      ;켸

		pop eax
                jnz jmp_mut_next                                
;------------------------------------------------------------------------------

		xor [esi.one_data.ltmed_command+1],1
		mov [esi.one_data.ltmed_link],eax

		inc edx
		call list_kill

		dec edx
		jmp jmp_mut_next


;� MUTATE 같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같
jmp_mut_inverse:

;------------------------------------------------------------------------------
                push 5                                          ;커
		push m__seed					; �
                call m__rnd                                     ; �
                add esp,8                                       ; � RANDOMIZE
                or eax,eax                                      ; �    1/5
                jnz jmp_mut_next                                ;켸
;------------------------------------------------------------------------------

;같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같�

		xor [esi.one_data.ltmed_command+1],1            ; inverse condition

		lea eax,[esi.one_data.ltmed_link]		; EAX =ofs. link
		mov ecx,[eax]                                   ; ECX =link

		push edx
		inc edx
		call verify_label
		mov [eax],edx
		pop edx

;-----------------------------------------------------------------------------
		call data_clear

		mov AL,0E9h					; 
		mov 1 ptr[edi.ltmed_command],AL                 ;
		mov [edi.ltmed_desc.lc_mask1],AL                ;
		                                                ;
		mov [edi.ltmed_desc.lc_soperand],4              ;    <JMP>
		mov [edi.ltmed_desc.lc_size],5                  ;
		mov [edi.ltmed_link],ecx                        ;
		call list_add					;


		inc edx
		mov esi,[esi.one_next]				; esi= jmp ofst.

;같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같�

jmp_mut_next:

		inc edx
		mov esi,[esi.one_next]
		jmp jmp_mut_main

jmp_mut_exit:
