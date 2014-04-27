/*
 *   File: string_demo.c
 * Author: Randall.Bower
 *
 * Description: Demonstrating three ways to create a string and the null character.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // Need the strlen function.

// If you put this and the pointer_demo.c in the same project,
// only one can define main at a time.
void string_demo()
{
  printf( "\n\nString Demo\n===========\n" );

  // A string in C is just an array of characters.
  // char who[] = "World";

  // Arrays in C can also be thought of as pointers.
  // This notation is most common with strings.
  // char* who = "World";

  // This example further illustrates a string is just an array of characters.
   char who[ 5 ];
   who[ 0 ] = 'W';
   who[ 1 ] = 'o';
   who[ 2 ] = 'r';
   who[ 3 ] = 'l';
   who[ 4 ] = 'd';

  // The above code will not generate any compiler warnings, but it may
  // not work when it runs. Strings are just arrays of characters, but
  // the last character must be a null or terminating character, '\0'.
  // This also requires an extra space in the array, so the declaration
  // above would need to be char who[ 6 ] to make room for the '\0'.
  // and then the last spot be assigned as follows:
  //   who[ 5 ] = '\0';
  // The two declarations on lines 17 and 21 automatically include the null.

  printf( "Hello, %s!\n", &who);

  // No matter how the string is declared, the length will be up to but
  // not including the null character.
  printf( "length = %d\n", strlen( who ) );
}
