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
; Para o exercício 3 do trabalho, devemos receber um vetor e 
; utilizar a lógica do exercício 2 para resolver a comparação

;-------- variaveis da subrotina Compara
ORG 1000
    OP1:  DW 0
    OP2:  DW 0

ORG 900
Compara:
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

    LDA OP1+1
    SUB OP2+1
    JP  POSITIVO
    JN  NEGATIVO
; operando 1 = operando 2, retornamos 0
    LDA #0
    JMP CALLBACK_Compara

POSITIVO:           ; operando 1 > operando 2
    LDA #1          ; retornando 1
    JMP CALLBACK_Compara
NEGATIVO:           ; operando 2 > operando 1
    LDA #-1         ; retornando -1
    JMP CALLBACK_Compara

;---------- variaveis da subrotina PercorreVetor
ORG 700
    VSIZE:      DB  0
    POINTER:    DW  0
    ITERATOR:   DB  0
    MAIOR:      DW  0
    INDEX:      DB  0

;---------- subrotina PercorreVetor
ORG 400
PercorreVetor:
    SHL                 ; como tenho valor em 16 bits, preciso multiplicar por 2
    STA     VSIZE       ; salvando em VSIZE o tamanho do vetor * 2
    POP                 ; pegando a parte alta do endereço de V[0]
    STA     POINTER+1   ; guardando o valor em POINTER
    POP                 ; pegando a parte baixa do endereço de V[0]
    STA     POINTER     ; guardando O valor em POINTER+1

    LDA     @POINTER    ; carregando V[0] no acc
    STA     MAIOR       ;
    LDA     @POINTER+1  ; carregando parte baixa de V[0]
    STA     MAIOR+1     ; maior = V[0]
    LDA     #2          ; acc = 2
    STA     ITERATOR    ; iterator = 2
LOOP:
    LDA     VSIZE       ; carrega VSIZE no acc
    SUB     ITERATOR    ; comparo com tamanho do ITERATOR
    JZ      FIM         ; se VSIZE - ITERATOR = 0, termino
    LDA     POINTER
    ADD     #2          ; ando uma posição no vetor pra frente
    STA     POINTER     ; salvo essa posição em POINTER
    LDA     @POINTER    ; pego bits mais altos V[i]
    PUSH                ; e coloco na pilha
    LDA     @POINTER+1  ; carrega parte baixa de V[i] no acc
    PUSH                ; e coloco na pilha
    LDA     MAIOR       ; coloca parte baixa de MAIOR no acc
    PUSH                ; coloca parte baixa de MAIOR na pilha
    LDA     MAIOR+1     ; coloca parte alta de maior no acc
    PUSH                ; coloca parte alta de MAIOR na pilha
    ; incrementando iterator
    LDA     ITERATOR
    ADD     #2
    STA     ITERATOR
    JMP     Compara     ; chama rotina Compara
CALLBACK_Compara:
; após comparação, devo decidir se achei um número maior do que já tenho ou não
    XOR     #1          ; comparo com 1
    JNZ     LOOP        ; se não for igual a 1, volta pro início do loop
    LDA     @POINTER
    STA     MAIOR       ; e salvo em maior
    LDA     @POINTER+1
    STA     MAIOR+1     ; e salvo em maior+1
    LDA     ITERATOR    ; e por fim
    SUB     #2          ; tiro os 2 que usei para incrementar essa rodada
    STA     INDEX       ; salvo o index dele em INDEX
    JMP     LOOP        ; e volto pro inicio do loop

FIM:                    ; no final do programa, devo colocar INDEX no acumulador e sair
    LDA     INDEX
    JMP     CALLBACK_MAIN


;--------- variaveis da Main
ORG 100
    PT:     DW VETOR
    VETOR:  DW 2,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
    SIZE:   DB 20

;--------- main
ORG 0
MAIN:
    OUT CLEARBANNER
    LDA PT
    PUSH
    LDA PT+1
    PUSH
    LDA SIZE
    JMP PercorreVetor
CALLBACK_MAIN:
    ADD PT          ; somado ao index, tenho o endereço de onde está a maior variavel do vetor
    STA PT
    LDA @PT+1
    JSR Print
    LDA @PT
    JSR Print
    HLT

ORG 1100
    X:  DB  0

ORG 1200
Print:
    STA X           ; salvo número em N
    SUB 9           ; comparo com 9
    JNZ Numero      ; se nao for negativo, é numero
Letra:
    ADD #40H        ; somo o que ficou no acumulador com #40H para chegar na posição da tabela onde ficam as letras
    JMP PBanner      ; coloco no banner
Numero:
    LDA X           ; carrego X no acumulador
    ADD #30H        ; usando macete da tabela ascii
PBanner:
    OUT BANNER
    RET




;------------------------------------------------------
; valores de acordo com a tabela ascii
ZERO  EQU 30H
UM    EQU 31H
MENOS EQU 2DH

;------------------------------------------------------
; constantes de hardware
CLEARBANNER   EQU 3
BANNER        EQU 2
STATUS        EQU 1
; constantes de trap
CONSOLEWRITE  EQU 2
;------------------------------------------------------
