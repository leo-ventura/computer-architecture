; Programa para o primeiro trabalho de programação no SimuS
; Alunos: Daniel La Rubia Rolim
;         Leonardo Ventura
;         Maria Eduarda Lucena
;
; Grupo B
;-------------------------------------------------------------

ORG 300
    Fib:    DB  0
    CURR:   DB  0
    N:      DB  0

; rotina que recebe N pelo acumulador e calcula seu fibonacci recursivamente
Fibonacci:
    STA CURR    ; salvo N em curr
    SUB #2      ; comparo com 2
    JN  FIM     ; retorno se for menor que 2, termina
; se for diferente de 1 e 0, calculo fib(n-1) + fib(n-2)
    LDA CURR    ; acumulador = n
    PUSH        ; salvo N na pilha
    SUB #1      ; acumulador = n-1
    JSR Fibonacci   ; Fibonacci(n-1)
    STA CURR    ; curr = Fibonacci(n-1)
    ; ADD Fib     ; Fib = Fib + Fibonacci(n-1), lembrando que o retorno vem no acumulador
    POP         ; carrego n no acumulador
    STA N
    LDA CURR    ; acumulador = Fibonacci(n-1)
    PUSH        ; coloco Fibonacci(n-1) na pilha
    LDA N
    SUB #2      ; acumulador = n-2
    JSR Fibonacci   ; Fibonacci(n-2)
    STA Fib     ; salvo Fibonacci(n-2) em Fib
    POP         ; pego Fibonacci(n-1) salvo na pilha
    ADD Fib     ; faço Fibonacci(n-1) + Fibonacci(n-2)
    RET         ; retorno
FIM:
    LDA CURR    ; carrego valor dele no acumulador
    RET         ; e retorno


ORG 100
    F:      DB  0
    ATUAL:  DB  0

ORG 0
MAIN:
    OUT LIMPA
LOOP:
    IN  KBSTATUS 
    ADD #0
    JZ  LOOP
INPUT:
    IN  KEYBOARD    ; leio do teclado
    STA ATUAL       ; salvo em atual
    SUB #23H        ; comparo com #
    JZ  CalculaFib  ; se for #, calculo Fib
    LDA ATUAL       ; caso contrario, carrego F no acumulador
    JSR TraduzAsciiPraNumero ; pego F em decimal
    STA ATUAL       ; salvo tradução em ATUAL
    LDA F           ; coloco F no acumulador
    JSR MultiplicaPorDez    ; e multiplico por 10 (ando uma posição pra esquerda em decimal)
    ADD ATUAL       ; somo com atual
    STA F           ; salvo em F
    JMP LOOP        ; volto pro loop
CalculaFib:
    LDA F           ; carrego F no acumulador
    JSR Fibonacci   ; e chamo Fibonacci dele
    JSR Print
    HLT

ORG 200
    X:  DB  0
    Y:  DB  0

MultiplicaPorDez:   ; recebe x no acumulador
    STA X       ; X = x
    SHL         ; acumulador = x*2
    SHL         ; acumulador = x*4
    ADD X       ; acumulador = x*4 + x (x = x*5)
    SHL         ; acumulador = x*10
    RET
TraduzAsciiPraNumero:    ; recebe um numero em ascii no acumulador e retorna seu decimal
    SUB #30H
    RET
TraduzNumeroPraAscii:
    ADD #30H
    RET

Print:
    STA Y           ; salvo número em Y
    AND #0F0H       ; pego a parte alta do número (1111 0000)
    SHR
    SHR
    SHR
    SHR             ; e dou shift 4 vezes pra colocar a parte alta na parte baixa
    JSR GetAscii    ; desvio pra rotina GetAscii
    LDA Y           ; carrego Y no acumulador
    AND #0FH        ; pego a parte baixa
    JSR GetAscii    ; chamo rotina GetAscii
    RET             ; retorno
GetAscii:
    STA X           ; salvo número em X
    ADD #0F7H       ; comparo com complemento à 2 de 9 (0000 1001): (1111 0110) + 1
    JN  Numero      ; se nao for negativo, é numero
Letra:
    ADD #40H        ; somo o que ficou no acumulador com #40H para chegar na posição da tabela onde ficam as letras
    JMP PBanner     ; coloco no banner
Numero:
    LDA X           ; carrego X no acumulador
    ADD #30H        ; usando macete da tabela ascii
PBanner:
    OUT BANNER
    RET

;------ variaveis de e/s
BANNER    EQU 2
LIMPA     EQU 3
KBSTATUS  EQU 3
KEYBOARD  EQU 2