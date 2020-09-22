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
    STA  OP1+1      ; salvo parte BAIXA em OP1+1
    POP
    STA  OP1        ; salvo parte ALTA em OP1

    POP
    STA  OP2+1      ; salvo parte BAIXA em OP2+1
    POP
    STA  OP2        ; salvo parte ALTA em OP2

    LDA  OP1+1      ; comparo as partes altas
    SUB  OP2+1      ; usando subtração
    JP   POSITIVO   ; op1 > op2
    JN   NEGATIVO   ; op2 > op1

    LDA OP2         ; carregando parte baixa de OP2 no acumulador
    NOT             ; complemento
    STA OP2         ; salvo em OP2
    LDA OP1         ; coloco parte baixa de op1 no acumulador
    ADD OP2         ; faço OP1 + ~OP2
    ADD #1          ; somo 1 para o complemento à 2
    JP  POSITIVO
    JN  NEGATIVO
; operando 1 = operando 2, retornamos 0
    LDA #0
    JMP CALLBACK_Compara

POSITIVO:           ; operando 1 > operando 2
    LDA #1          ; retornando 1
    JMP CALLBACK_Compara
NEGATIVO:           ; operando 2 > operando 1
    LDA OP2+1
    LDA #-1         ; retornando -1    
    JMP CALLBACK_Compara

;---------- variaveis da subrotina PercorreVetor
ORG 700
    VSIZE:      DB  0
    POINTER:    DW  0
    ITERATOR:   DB  0
    MAIOR:      DW  0
    INDEX:      DB  0
    CURR:       DW  0

;---------- subrotina PercorreVetor
ORG 400
PercorreVetor:
    SHL                 ; como tenho valor em 16 bits, preciso multiplicar por 2
    STA     VSIZE       ; salvando em VSIZE o tamanho do vetor * 2
    POP                 ; pegando a parte alta do endereço de V[0]
    STA     POINTER
    POP
    STA     POINTER
    LDS     POINTER     ; aponto pra V[0]
    POP                 ; 
    STA     CURR        ; curr = parte (alta|baixa) de V[0]
    STA     MAIOR       ;
    POP                 ;
    STA     CURR+1      ; curr = parte (alta|baixa) de V[0]
    STA     MAIOR+1     ; maior = V[0]
    STS     POINTER     ; salvo sp em pointer
    LDA     #0          ; acc = 0
    STA     ITERATOR    ; iterator = 0
LOOP:
    ; incrementando iterator
    LDA     ITERATOR
    ADD     #2
    STA     ITERATOR
    LDA     VSIZE       ; carrega VSIZE no acc
    SUB     ITERATOR    ; comparo com tamanho do ITERATOR
    JZ      FIM         ; se VSIZE - ITERATOR = 0, termino
    LDS     POINTER
    POP
    STA     CURR
    POP
    STA     CURR+1
    STS     POINTER     ; salvando apontador de pilha em POINTER
    LDS     #0FF00H     ; indo para um endereço de memória nao utilizado para realizar a rotina
    LDA     MAIOR       ; coloca parte baixa de MAIOR no acc
    PUSH                ; coloca parte baixa de MAIOR na pilha
    LDA     MAIOR+1     ; coloca parte alta de maior no acc
    PUSH                ; coloca parte alta de MAIOR na pilha
    LDA     CURR        ; coloco parte baixa de maior na pilha
    PUSH
    LDA     CURR+1      ; coloco parte alta de maior na pilha
    PUSH
    JMP     Compara     ; chama rotina Compara
CALLBACK_Compara:
; após comparação, devo decidir se achei um número maior do que já tenho ou não
    XOR     #1          ; comparo com 1
    JNZ     LOOP        ; se não for igual a 1, volta pro início do loop
; se for igual a 1, achei um novo maior, atualizo
    LDA     CURR
    STA     MAIOR
    LDA     CURR+1
    STA     MAIOR+1
    LDA     ITERATOR    ; e por fim
    STA     INDEX       ; salvo o index dele em INDEX
    JMP     LOOP        ; e volto pro inicio do loop

FIM:                    ; no final do programa, devo colocar INDEX no acumulador e sair
    LDA     INDEX
    JMP     CALLBACK_MAIN


;--------- variaveis da Main
ORG 100
    PT:     DW VETOR
    ; VETOR:  DW -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
    VETOR:  DW 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
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
    ADD #1
    STA PT
    LDA @PT
    JSR Print
    LDA PT
    SUB #1
    STA PT
    LDA @PT
    JSR Print
    HLT

ORG 1100
    X:  DB  0
    Y:  DB  0

ORG 1200
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


;------------------------------------------------------
; constantes de hardware
CLEARBANNER   EQU 3
BANNER        EQU 2
STATUS        EQU 1
; constantes de trap
CONSOLEWRITE  EQU 2
;------------------------------------------------------
