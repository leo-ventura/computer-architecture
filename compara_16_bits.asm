; Programa para o primeiro trabalho de programação no SimuS
; Alunos: Daniel La Rubia Rolim
;         Leonardo Ventura
;         Maria Eduarda Lucena
;
; Grupo B
;-------------------------------------------------------------

; A ideia principal do programa é subtrair um número do outro
; usando primeiro a parte alta de cada um
; se a parte alta for maior de algum dos lados
; já sabemos qual número é maior
; senão, teremos que comparar a parte baixa


ORG 400
    OP1:  DW 0
    OP2:  DW 0
    PT:   DW 0

ORG 300
COMPARA:
; começo lendo os valores e salvando nas variaveis declaradas acima
    POP
    STA  OP2+1 ; salvo parte alta em OP1
    POP
    STA  OP2   ; salvo parte baixa em OP1 + 1

    POP
    STA  OP1+1 ; salvo parte alta em OP2
    POP
    STA  OP1   ; salvo parte baixa em OP2 + 1

    LDA  OP1
    SUB  OP2
    JP   POSITIVO
    JN   NEGATIVO

    ; LDA OP1+1
    ; SUB OP2+1
    LDA OP2+1
    NOT
    STA OP2+1       ; salvo em OP2
    LDA OP1+1       ; coloco parte baixa de op1 no acumulador
    ADD OP2+1       ; faço OP1 + ~OP2
    ADD #1          ; somo 1 para o complemento à 2
    JP  POSITIVO
    JN  NEGATIVO
; operando 1 = operando 2, retornamos 0
    LDA #ZERO
    OUT BANNER
    HLT

POSITIVO:
    LDA #UM      ; operando 1 > operando 2
    OUT BANNER
    HLT
NEGATIVO:        ; operando 2 > operando 1, coloco -1 no banner
    LDA #MENOS   ; ascii de -
    OUT BANNER
    LDA #UM      ; ascii de 1
    OUT BANNER
    HLT


ORG 100
    OPERANDO1: DW 15
    OPERANDO2: DW 15


ORG 0
MAIN:
    OUT CLEARBANNER
    LDA OPERANDO1
    PUSH
    LDA OPERANDO1+1
    PUSH
    LDA OPERANDO2
    PUSH
    LDA OPERANDO2+1
    PUSH
    JMP COMPARA


;----------
; valores de acordo com a tabela ascii
ZERO  EQU 30H
UM    EQU 31H
MENOS EQU 2DH

;------------------------------------------------------
; constantes de hardware
CLEARBANNER   EQU 3
BANNER        EQU 2
STATUS        EQU 1
PARTEALTA     EQU 0
; constantes de trap
CONSOLEWRITE  EQU 2
;------------------------------------------------------
