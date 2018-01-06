        section .bss
w:      resb 4
h:      resb 4
T:      resb 8

        section .text
        global run, start

start:
        mov  [w], rdi
        mov  [h], rsi
        mov  [T], rdx

        ret

;; numer of steps in rdi
run:
        push rbx
        push r12
        push r13

        mov rbx, [T]    ; get array base address

;; calculate the new state
l1:                     ; loop over steps
        xor esi, esi    ; initialize height counter (x)
l2:                     ; loop over height
        xor ecx, ecx    ; initialize width counter (y)
l3:                     ; loop over width
        call evolve

        inc ecx         ; width counter (y)
        cmp ecx, [w]
        jl l3

        inc esi         ; height counter (x)
        cmp esi, [h]
        jl l2

;; shift the cells to discard the old state
        xor esi, esi    ; initialize height counter (x)
l4:                     ; loop over height
        xor ecx, ecx    ; initialize width counter (y)
l5:                     ; loop over width
        call shift

        inc ecx         ; width counter (y)
        cmp ecx, [w]
        jl l5

        inc esi         ; height counter (x)
        cmp esi, [h]
        jl l4

        dec edi         ; step counter
        jnz l1

        pop  r13
        pop  r12
        pop  rbx
        ret

evolve:
        xor r8d, r8d    ; neighbour counter

        mov r9d, esi    ; x1
        dec r9d         ; x - 1 (l6 counter)
        mov r10d, esi   ; x
        inc r10d        ; x + 1 (l6 bound)
l6:                     ; loop over x
        mov r11d, ecx   ; y1
        dec r11d        ; y - 1 (l7 counter)
        mov r12d, ecx   ; y
        inc r12d        ; y + 1 (l7 bound)
l7:
        cmp r9d, 0      ; x1 < 0
        jl l7_done

        cmp r9d, [h]    ; x1 >= h
        jge l7_done

        cmp r11d, 0     ; y1 < 0
        jl l7_done

        cmp r11d, [w]   ; y1 >= w
        jge l7_done

        mov eax, [w]    ; put the argument for mul
        mul r9d         ; eax now stores w*x1
        add eax, r11d   ; eax now stores w*x1 + y1

        mov r13b, [rbx + rax]   ; get the neighbour's state
        and r13b, 1     ; check if neighbour is alive
        jz l7_done      ; don't increment if neighbour is dead
        inc r8d
l7_done:
        inc r11d        ; l7
        cmp r11d, r12d
        jle l7

        inc r9d         ; l6
        cmp r9d, r10d
        jle l6

        mov eax, [w]    ; put the argument for mul
        mul esi         ; eax = w*x
        add eax, ecx    ; eax = w*x + y

        mov r13b, [rbx + rax]   ; get my state
        and r13b, 1     ; check if I am alive
        jz test         ; don't decrement if I'm dead
        dec r8d         ; decrement counter if I'm alive
test:
        cmp r8d, 3      ; n == 3
        je revive

        cmp r8d, 2      ; n == 2...
        jne evolve_done
        and r13b, 1     ; ...&& I'm alive
        jz evolve_done
revive:
        or r13b, 2 ;    x |= (1 << 1)
        mov [rbx + rax], r13b
evolve_done:
        ret

shift:
        mov eax, [w]    ; put the argument for mul
        mul esi         ; eax now stores w*x
        add eax, ecx    ; eax now stores w*x + y

        mov r8b, [rbx + rax]    ; get cell value
        shr r8b, 1              ; discard old state
        mov [rbx + rax], r8b    ; update cell value

        ret
