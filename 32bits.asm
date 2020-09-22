; Programa para o primeiro trabalho de progrmação no Simus
; Alunos: Daniel La Rubia Rolim
;         Leonardo Ventura
;         Maria Eduarda Lucena
;
; Grupo B
;-------------------------------------------------------------

; Como nosso acumulador tem apenas 8 bits, precisaremos de 4 leituras
; para lermos todos os 4 bits passados

ORG 400
    ZEROS:   DB 0     ; define um byte para contar a quantidade de zeros
    UNS:     DB 0     ; define um byte para contar a quantidade de uns
    LIDOS:   DB 0     ; quantidade de bytes lidos
    BLIDOS:  DB 0     ; quantidade de bits lidos
    CURRENT: DB 0     ; numero sendo tratado atualmente

ORG 200
ContaUnsZeros:        ; rotina que irá receber 32 bits na pilha
                      ; e um operando no acumulador dizendo o que contar

    XOR    #0         ; testa se acumulador é zero
    JZ     ZERO       ; desvia se for zero

UM:                   ; rotina para contar uns
    LDA    #0
    STA    BLIDOS     ; colocando 0 na quantidade de bits lidos
    POP               ; salva primeiro byte no acumulador
    STA    CURRENT    ; salva numero que vai ser analisado
UMLEBIT:
    LDA    CURRENT    ; carrega numero que vai ser analisado
    SHR               ; faz shift para direita (se for 1, vai acender carry)
    STA    CURRENT    ; salva numero depois do shift
    JC     INCUM      ; incrementa o contador UNS se tiver carry
UMINCRET:
    LDA    #1       
    ADD    BLIDOS     ; incrementa 1 em BLIDOS, salva no acc
    STA    BLIDOS     ; salva em BLIDOS
    LDA    #8         ; carrega 8 no acumulador
    XOR    BLIDOS     ; compara 8 com B_LIDOS para acender as flags
    JNZ    UMLEBIT    ; se BLIDOS nao for igual a 8, ainda tem bits para ler
                      ; caso contrario, vai para comparação de bytes lidos
    LDA    #1         ; carrega 1 no acumulador
    ADD    LIDOS      ; soma com LIDOS, salva no acc
    STA    LIDOS      ; incrementa 1 em LIDOS
    LDA    #4         ; 32 bits em bytes
    XOR    LIDOS      ; compara 4 com a quantidade de bytes lidos
    JZ     FIM        ; se lidos == 4, acaba o programa
    JMP    UM         ; lê proximo byte


ZERO:                 ; rotina para contar zeros
    LDA    #0
    STA    BLIDOS     ; colocando 0 na quantidade de bits lidos
    POP               ; salva primeiro byte no acumulador
    STA    CURRENT    ; salva numero que vai ser analisado
ZEROLEBIT:
    LDA    CURRENT    ; carrega numero que vai ser analisado
    SHR               ; faz shift para direita (se for 0, não vai acender carry)
    STA    CURRENT    ; salva numero depois do shift
    JNC    INCZERO    ; incrementa o contador ZEROS se não tiver carry
ZINCRET:
    LDA    #1       
    ADD    BLIDOS     ; incrementa 1 em BLIDOS
    STA    BLIDOS     ; salva em BLIDOS
    LDA    #8         ; carrega 8 no acumulador
    XOR    BLIDOS     ; compara 8 com B_LIDOS para acender as flags
    JNZ    ZEROLEBIT  ; se B_LIDOS nao for igual a 8, ainda tem bits para ler
                      ; caso contrario, vai para comparação de bytes lidos
    LDA    #1         ; carrega 1 no acc
    ADD    LIDOS      ; soma 1 a LIDOS
    STA    LIDOS      ; salva em LIDOS: incrementa 1 em LIDOS
    LDA    #4         ; 32 bits em bytes
    XOR    LIDOS      ; compara 4 com a quantidade de bytes lidos
    JZ     FIM        ; se lidos == 4, acaba o programa
    JMP    ZERO       ; lê proximo byte

INCUM:                ; rotina para incrementar contador UNS
    LDA    #1
    ADD    UNS
    STA    UNS
    JMP    UMINCRET

INCZERO:              ; rotina para incrementar contador ZEROS
    LDA    #1
    ADD    ZEROS
    STA    ZEROS
    JMP    ZINCRET

FIM:
    HLT
    END    0


ORG 100
    P: DW A
    A: DB 254, 254, 255, 255

ORG 0
MAIN:
    LDA    #0         ; quero calcular quantidade de 1
    LDS    P          ; aponta sp pra P
    JMP ContaUnsZeros ; pula pra rotina