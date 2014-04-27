/*
 * stack.h
 *
 *  Created on: Aug 7, 2012
 *      Author: Randall.Bower
 */

#ifndef STACK_H_
#define STACK_H_

struct StackNode
{
  int item;
  struct StackNode* next;
};

typedef struct StackNode* stack_node_ptr; // Convenient shorthand.

struct Stack
{
  stack_node_ptr top;
};

typedef struct Stack* stack_ptr; // Convenient shorthand.

// Basic stack operations.
stack_ptr new_stack();
void push( stack_ptr, int );
int pop( stack_ptr );
int peek( stack_ptr );
int is_empty( stack_ptr );

#endif /* STACK_H_ */
