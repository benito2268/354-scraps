# if you want to run on CSL machines
# assemble using 'gcc -no-pic -m32 test.s -o test'
.code32

.section .data
fmt: .asciz "result: %d\n"

.section .text

recursive:
   pushl %ebp
   movl %esp,%ebp
   pushl %ebx
   subl $0x14,%esp
   cmpl $0x1,0x8(%ebp)
   je .L1
   cmpl $0x2,0x8(%ebp)
   jne .L2

.L1:
   movl 0x8(%ebp),%eax
   subl $1,%eax
   jmp .L3

.L2:
   movl 0x8(%ebp),%eax
   subl $0x1,%eax
   movl %eax,(%esp)
   call recursive
   movl %eax,%ebx
   movl 0x8(%ebp),%eax
   subl $0x2,%eax
   movl %eax,(%esp)
   call recursive
   addl %ebx,%eax

.L3:
   addl $0x14,%esp
   popl %ebx
   popl %ebp
   ret 

.global	main
.type main, @function
main:
    pushl $0x5
    call recursive
    addl $4, %esp

    pushl %eax             
    pushl $fmt            
    call printf           
    addl $8, %esp         

    xorl %eax, %eax 
    ret
