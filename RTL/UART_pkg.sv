

package UART_pkg;

parameter DATA_WIDTH = 8 ,ADDRESS_WIDTH =4,ALU_Function_width=4,DIV_RATIO =8 ;

typedef enum bit [2:0] {IDLE,START_BIT,SENDING,PARTIY,END_BIT} UART_TX_e ;


typedef enum bit [3:0] {Addition,Subtraction,Multiplication,Division
                        ,AND_e,OR_e,NAND_e,NOR_e,XOR_e,XNOR_e,CMPH,CMPL,SHIFTR,SHIFTL} Alu_op_e ;



typedef enum bit [3:0] {IDLE_e,WR_CMD,WR_ADD,WR_DATA,RD_CMD,RD_ADD,ALU_OP4,READ_OP1,READ_OP2,ALU_FUN1,ALU_OP2,ALU_FUN2} SYS_CTRL_e ;


endpackage