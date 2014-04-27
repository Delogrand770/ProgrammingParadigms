/*
 * File:   pontifex.h
 * Author: Gavin Delphia
 *
 * Description: Declarations of methods used to implement the Pontifex encryption scheme.
 *              http://www.schneier.com/solitaire.html
 */

#ifndef PONTIFEX_H_
#define PONTIFEX_H_

#define ALPHABET_SIZE 26  // This could be changed if used with a different language/alphabet.
card_ptr triple_cut(card_ptr); //Performs the triple cut
card_ptr move_jokers(card_ptr); //Moves the jokers appropriately
card_ptr count_cut(card_ptr); //Performs the count cut
card_ptr get_outputCard(card_ptr); //Gets the output card in a deck
int card_mod(card_ptr); //Returns the value of a card modded by the alphabet size
card_ptr move_jokerA(card_ptr); //Moves jokerA
card_ptr move_jokerB(card_ptr); //Moves jokerB
int isJoker(card_ptr); //Determines if a card is a joker or not
void keyStream(card_ptr, int); //Generates a keystream based on a deck
void encrypt(card_ptr, char*, char*); //Encrypts data with a deck and saves it
void decrypt(card_ptr, char*, char*); //Decrypts data with a deck and saves it
int charToInt(char); //Converts a character to an integer equivalent

#endif /* PONTIFEX_H_ */
