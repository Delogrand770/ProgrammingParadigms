/*
 * stack.c
 *
 *  Created on: Aug 7, 2012
 *      Author: Randall.Bower
 */

#include <stdlib.h>
#include "stack.h"

/*
 * Description: Creates a new, empty stack.
 * Input:       None.
 * Result:      Returns a pointer to a new, empty stack.
 * PRE:         None.
 * POST:        The pointer returned will be to a new, empty stack.
 */
stack_ptr new_stack()
{
  stack_ptr stackPtr = (stack_ptr) malloc( sizeof(struct Stack) );
  stackPtr->top = NULL;
  return stackPtr;
}

/*
 * Description: Pushes an item onto a stack.
 * Input:       A pointer to the stack on which to push the item and the item.
 * Result:      Nothing returned; the item will be pushed onto the stack.
 * PRE:         The stack pointer must point to a valid stack.
 * POST:        The stack pointer will point to a valid stack with item on top
 *              and all previous items underneath.
 */
void push( stack_ptr stackPtr, int item )
{
  stack_node_ptr nodePtr = (stack_node_ptr) malloc( sizeof(struct StackNode) );
  nodePtr->item = item;
  nodePtr->next = stackPtr->top;
  stackPtr->top = nodePtr;
}

/*
 * Description: Pops an item off a stack.
 * Input:       A pointer to the stack from which to pop an item.
 * Result:      The top item on the stack will be returned.
 * PRE:         The stack pointer must point to a valid, non-empty stack.
 * POST:        The top item on the stack will be returned and the stack
 *              will be one item smaller with the top referring to the
 *              item previously directly underneath the top.
 */
int pop( stack_ptr stackPtr )
{
  stack_node_ptr temp = stackPtr->top;
  int item = temp->item;
  stackPtr->top = temp->next;
  free( temp );
  return item;
}

/*
 * Description: Peeks at the top item on the stack without changing the stack.
 * Input:       A pointer to the stack to be peeked upon.
 * Result:      The top item on the stack will be returned.
 * PRE:         The stack pointer must point to a valid, non-empty stack.
 * POST:        The top item on the stack will be returned adn the stack
 *              will remain unchanged.
 */
int peek( stack_ptr stackPtr )
{
  return stackPtr->top->item;
}

/*
 * Description: Determines if a stack is empty.
 * Input:       A pointer to the stack to be checked for emptiness.
 * Result:      True if the stack is empty; false otherwise.
 * PRE:         The tack pointer must point to a valid stack.
 * POST:        The stack will remain unchanged.
 */
int is_empty( stack_ptr stackPtr )
{
  return stackPtr->top == NULL;
}
