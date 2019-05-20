;followings are the important memory address
;0x2000 - 0x36FF: memory-mapped display
;0x3700: lower digit of player 1 score
;0x3701: higher digit of player 1 score
;0x3702: lower digit of player 2 score
;0x3703: higher digit of player 2 score
;0x3710: upper part of player 1 paddle
;0x3711: lower part of player 1 paddle
;0x3712: x position of player 1 paddle (scoring line)
;0x3713: upper part of player 2 paddle
;0x3714: lower part of player 2 paddle
;0x3715: x position of player 1 paddle (scoring line)
;0x3720: x position of ball
;0x3721: y position of ball
;0x3722: x speed of ball
;0x3723: y speed of ball
;0x37F0 - 0x37FF: key press state (please tell me what slot you use)
;0x37F0: scan code for keyboard input; only support one key press at a time
;0x37E0: game state, 0=game screen / 1=game started
; 
            .ORG    0 
START:               
            JP      boot 
; 
BOOT:                
; Set the stack pointer
            LD      sp,16384 ; 16 Kb of RAM
; Set up for interrupt testing: see Z80\cpu\toplevel\test_top.sv
; IMPORTANT: To test IM0, Verilog test code needs to put 0xFF on the bus
;            To test IM2, the test code needs to put a vector of 0x80 !!
;            This is done in tb_iorq.sv
            IM      2 
            LD      a,0 
            LD      i,a 
            EI       
;halt
; Jump into the executable at 100h
            JP      100h 
; 
            .ORG    100h 
PRE_LOOP:            
            LD      BC,0ffffh 
OUTER_PRE_LOOP:      
            LD      DE,0ffffh 
INNER_PRE_LOOP:      
            LD      A,0 
            CALL    key_loop 
            LD      HL,37f0h 
            LD      A,(HL) 
            CP      0 
            JP      NZ,start_game 
            DEC     DE 
            LD      A,D 
            OR      E 
            JP      NZ,inner_pre_loop 
            LD      A,B 
            OR      C 
            JP      NZ,outer_pre_loop 
            HALT     
; 
; 
KEY_LOOP:            
            EXX      
            LD      BC,100h 
OUTER_KEY_LOOP:      
            LD      DE,100h 
INNER_KEY_LOOP:      
            DEC     DE 
            LD      A,D 
            OR      E 
            JP      NZ,inner_key_loop 
            DEC     BC 
            LD      A,B 
            OR      C 
            JP      NZ,outer_key_loop 
            EXX      
            RET      
; 
;'start game logic here
START_GAME:          
;initialize variable
INITIALIZE_SCORE:    
            LD      A,0 
            LD      (3700h),A 
            LD      (3701h),A 
            LD      (3702h),A 
            LD      (3703h),A 
INITIALIZE:          
            LD      A,35 
            LD      HL,3710h 
            LD      (HL),A 
            LD      HL,3713h 
            LD      (HL),A 
            LD      A,10 
            LD      HL,3712h 
            LD      (HL),A 
            LD      A,70 
            LD      HL,3715h 
            LD      (HL),A 
            LD      A,40 
            LD      HL,3720h 
            LD      (HL),A 
            LD      A,37 
            LD      HL,3721h 
            LD      (HL),A 
            LD      A,1 
            LD      HL,3722h 
            LD      (HL),A 
            LD      A,1 
            LD      HL,3723h 
            LD      (HL),A 
            LD      HL,37e0h 
            LD      (HL),1 
            CALL    clear_screen 
GAME_LOOP:           
            CALL    clear_screen 
            CALL    input_loop 
            CALL    check_collide_paddle_1 
            CALL    check_collide_paddle_2 
            CALL    check_collide_top 
            CALL    check_collide_bottom 
            CALL    move_ball 
            CALL    check_win_1 
            CALL    check_win_2 
            CALL    print_score 
            CALL    draw_paddle 
            CALL    draw_ball 
            JP      game_loop 
; 
CLEAR_SCREEN:        
            PUSH    IX 
            PUSH    HL 
            LD      HL,16ffh 
            LD      IX,36ffh 
CLEAR_SCREEN_LOOP:   
            LD      (IX),0 
            DEC     IX 
            DEC     HL 
            LD      A,H 
            OR      L 
            JP      NZ,clear_screen_loop 
            POP     HL 
            POP     IX 
            RET      
; 
INITIALIZE_BALL:     
            PUSH    HL 
            LD      A,40 
            LD      HL,3720h 
            LD      (HL),A 
            LD      A,37 
            LD      HL,3721h 
            LD      (HL),A 
            POP     HL 
            RET      
; 
INPUT_LOOP:          
            PUSH    BC 
            LD      B,10 
INNER_INPUT_LOOP:    
            LD      A,(37f01) 
            CP      1ch 
            CALL    Z,paddle_1_up 
            CP      1bh 
            CALL    Z,paddle_1_down 
            CP      42h 
            CALL    Z,paddle_2_up 
            CP      4bh 
            CALL    Z,paddle_2_down 
            DJNZ    inner_input_loop 
            POP     BC 
            RET      
; 
CHECK_WIN_1:         
            PUSH    IX 
            LD      A,(3720h) 
            CP      75 
            JP      C,player_1_not_got_score 
            LD      IX,3700h 
            CALL    inc_score 
            CALL    initialize_ball 
PLAYER_1_NOT_GOT_SCORE:  
            POP     IX 
            RET      
; 
CHECK_WIN_2:         
            PUSH    IX 
            LD      A,(3720h) 
            CP      6 
            JP      NC,player_2_not_got_score 
            LD      IX,3702h 
            CALL    inc_score 
            CALL    initialize_ball 
PLAYER_2_NOT_GOT_SCORE:  
            POP     IX 
            RET      
; 
CHECK_COLLIDE_PADDLE_1:  
            PUSH    HL 
            PUSH    BC 
            LD      HL,3720h 
            LD      A,(HL) 
            CP      11 
            JP      NZ,not_collide_paddle_1 
            LD      HL,3721h 
            LD      A,(HL) 
            LD      HL,3710h 
            LD      B,(HL) 
            LD      HL,3711h 
            LD      C,(HL) 
            INC     C 
            CP      B 
            JP      C,not_collide_paddle_1 
            CP      C 
            JP      NC,not_collide_paddle_1 
            LD      HL,3722h 
            LD      (HL),1 
NOT_COLLIDE_PADDLE_1:  
            POP     BC 
            POP     HL 
            RET      
; 
CHECK_COLLIDE_PADDLE_2:  
            PUSH    HL 
            PUSH    BC 
            LD      HL,3720h 
            LD      A,(HL) 
            CP      69 
            JP      NZ,not_collide_paddle_2 
            LD      HL,3721h 
            LD      A,(HL) 
            LD      HL,3713h 
            LD      B,(HL) 
            LD      HL,3714h 
            LD      C,(HL) 
            INC     C 
            CP      B 
            JP      C,not_collide_paddle_2 
            CP      C 
            JP      NC,not_collide_paddle_2 
            LD      HL,3722h 
            LD      (HL),-1 
NOT_COLLIDE_PADDLE_2:  
            POP     BC 
            POP     HL 
            RET      
; 
CHECK_COLLIDE_TOP:   
            PUSH    HL 
            PUSH    BC 
            LD      HL,3721h 
            LD      A,(HL) 
            CP      25 
            JP      NZ,not_collide_top 
            LD      HL,3723h 
            LD      (HL),1 
NOT_COLLIDE_TOP:     
            POP     BC 
            POP     HL 
            RET      
; 
CHECK_COLLIDE_BOTTOM:  
            PUSH    HL 
            PUSH    BC 
            LD      HL,3721h 
            LD      A,(HL) 
            CP      49 
            JP      NZ,not_collide_bottom 
            LD      HL,3723h 
            LD      (HL),-1 
NOT_COLLIDE_BOTTOM:  
            POP     BC 
            POP     HL 
            RET      
; 
MOVE_BALL:           
            PUSH    HL 
            LD      A,(3720h) 
            LD      HL,3722h 
            ADD     A,(HL) 
            LD      (3720h),A 
            LD      A,(3721h) 
            LD      HL,3723h 
            ADD     A,(HL) 
            LD      (3721h),A 
            POP     HL 
            RET      
; 
PADDLE_1_UP:         
            PUSH    HL 
            LD      HL,3710h 
            LD      A,(HL) 
            CP      26 
            JP      C,not_paddle_1_up 
            DEC     (HL) 
NOT_PADDLE_1_UP:     
            POP     HL 
            RET      
; 
PADDLE_2_UP:         
            PUSH    HL 
            LD      HL,3713h 
            LD      A,(HL) 
            CP      26 
            JP      C,not_paddle_2_up 
            DEC     (HL) 
NOT_PADDLE_2_UP:     
            POP     HL 
            RET      
; 
PADDLE_1_DOWN:       
            PUSH    HL 
            LD      HL,3710h 
            LD      A,(HL) 
            CP      46 
            JP      NC,not_paddle_1_down 
            INC     (HL) 
NOT_PADDLE_1_DOWN:   
            POP     HL 
            RET      
; 
PADDLE_2_DOWN:       
            PUSH    HL 
            LD      HL,3713h 
            LD      A,(HL) 
            CP      46 
            JP      NC,not_paddle_2_down 
            INC     (HL) 
NOT_PADDLE_2_DOWN:   
            POP     HL 
            RET      
; 
;following function find the memory block refers by the x value in register d and y value in register e, result store in IX
CONV_TO_MEM:         
            PUSH    HL 
            LD      H,D 
            LD      L,E 
            PUSH    DE 
            LD      IX,1fc4h 
            LD      DE,80 
            LD      B,L 
            INC     B 
CONV_LOOP:           
            ADD     IX,DE 
            DJNZ    conv_loop 
            LD      DE,0 
            LD      E,H 
            ADD     IX,DE 
            POP     DE 
            POP     HL 
            RET      
; 
;the following function print score on the screen
PRINT_SCORE:         
            LD      A,(3700h) 
            LD      D,10 
            LD      E,5 
            CALL    print_num 
            LD      A,(3701h) 
            LD      D,5 
            CALL    print_num 
            LD      A,(3702h) 
            LD      D,68 
            CALL    print_num 
            LD      A,(3703h) 
            LD      D,73 
            CALL    print_num 
            RET      
; 
; 
;print number on the register A on the posision D,E
PRINT_NUM:           
            PUSH    IX 
            CALL    conv_to_mem 
            CP      9 
            JP      Z,print_nine 
            POP     IX 
            RET      
            CP      8 
            JP      Z,print_eight 
            POP     IX 
            RET      
            CP      7 
            JP      Z,print_seven 
            POP     IX 
            RET      
            CP      6 
            JP      Z,print_six 
            POP     IX 
            RET      
            CP      5 
            JP      Z,print_five 
            POP     IX 
            RET      
            CP      4 
            JP      Z,print_four 
            POP     IX 
            RET      
            CP      3 
            JP      Z,print_three 
            POP     IX 
            RET      
            CP      2 
            JP      Z,print_two 
            POP     IX 
            RET      
            CP      1 
            JP      Z,print_one 
            POP     IX 
            RET      
            CP      0 
            JP      Z,print_zero 
            POP     IX 
            RET      
; 
PRINT_ZERO:          
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_ONE:           
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_TWO:           
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_THREE:         
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_FOUR:          
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_FIVE:          
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_SIX:           
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_SEVEN:         
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_EIGHT:         
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
PRINT_NINE:          
            PUSH    IX 
            PUSH    DE 
            LD      DE,80 
            LD      (IX+1),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX+2),0ffh 
            ADD     IX,DE 
            LD      (IX),0ffh 
            LD      (IX+1),0ffh 
            LD      (IX+2),0ffh 
            POP     DE 
            POP     IX 
            RET      
; 
;increase score at position IX
INC_SCORE:           
            LD      A,(IX) 
            ADD     A,1 
            CP      10 
            JP      Z,carry_to_next 
            JP      not_carry 
CARRY_TO_NEXT:       
            LD      (IX),0 
            LD      A,(IX+1) 
            ADD     A,1 
            LD      (IX+1),A 
            RET      
NOT_CARRY:           
            LD      (IX),A 
            RET      
; 
;clear score at position IX
CLEAR_SCORE:         
            LD      (IX),0 
            LD      (IX+1),0 
            RET      
; 
DRAW_PADDLE:         
            PUSH    HL 
            PUSH    DE 
            PUSH    BC 
            PUSH    IX 
            LD      HL,3710h 
            LD      BC,80 
            LD      E,(HL) 
            LD      A,E 
            ADD     A,3 
            LD      HL,3711h 
            LD      (HL),A 
            LD      HL,3712h 
            LD      D,(HL) 
            CALL    conv_to_mem 
            LD      (IX),0ffh 
            ADD     IX,BC 
            LD      (IX),0ffh 
            ADD     IX,BC 
            LD      (IX),0ffh 
            ADD     IX,BC 
            LD      (IX),0ffh 
            LD      HL,3713h 
            LD      E,(HL) 
            LD      A,E 
            ADD     A,3 
            LD      HL,3714h 
            LD      (HL),A 
            LD      HL,3715h 
            LD      D,(HL) 
            CALL    conv_to_mem 
            LD      (IX),0ffh 
            ADD     IX,BC 
            LD      (IX),0ffh 
            ADD     IX,BC 
            LD      (IX),0ffh 
            ADD     IX,BC 
            LD      (IX),0ffh 
            POP     IX 
            POP     BC 
            POP     DE 
            POP     HL 
            RET      
; 
DRAW_BALL:           
            PUSH    HL 
            PUSH    DE 
            LD      HL,3720h 
            LD      D,(HL) 
            INC     HL 
            LD      E,(HL) 
            CALL    conv_to_mem 
            LD      (IX),0ffh 
            POP     DE 
            POP     HL 
            RET      
; 
            END      
