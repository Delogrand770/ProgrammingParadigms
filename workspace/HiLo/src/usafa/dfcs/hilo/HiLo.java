package usafa.dfcs.hilo;

import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.*;

/**
 * File: HiLo.java 
 * 
 * Description: A very simple High Low number guessing game.
 * 
 * Challenges:
 * - Add a guess counter and indicate the user loses the game after 7 incorrect guesses.
 *   - Disable widgets as appropriate!
 * - Display the guess counter in a new TextView somewhere on the screen.
 * - Display all previous guesses in a new TextView somewhere on the screen.
 * - Make the EditText widget for the user's guess a single line and process
 *   the guess when the user presses Enter on the keyboard. (Challenging!)
 * - Add functionality to the Settings menu to:
 *   - Start a new game (yes, redundant).
 *   - Change the default range of the game (initially 1-100).
 * 
 * @author Randall.Bower
 */
public class HiLo extends Activity
{
  private EditText guessEditor;
  private TextView messageText;
  private Button guessButton;
  private int number;

  /** Called when the activity is first created. */
  @Override
  public void onCreate( Bundle savedInstanceState )
  {
    Log.d( "HILO", "onCreate()..." );
    super.onCreate( savedInstanceState );
    setContentView( R.layout.activity_hi_lo );

    this.guessEditor = (EditText) findViewById( R.id.guess );
    this.messageText = (TextView) findViewById( R.id.message );
    this.guessButton = (Button) findViewById( R.id.guess_button );
    
    this.guessEditor.setEnabled( false );
    this.guessButton.setEnabled( false );
    
    findViewById( R.id.newgame_button ).requestFocus();
  }

  public void newGame( View v )
  {
    Log.d( "HILO", "newGame()..." );
    this.guessButton.setEnabled( true );
    this.guessEditor.setEnabled( true );
    this.guessEditor.requestFocus();
    
    this.number = (int)(Math.random() * 100 + 1);
    Log.d( "HILO", "number = " + this.number );
  }
  
  public void guess( View v )
  {
    Log.d( "HILO", "guess()..." );
    int guess = Integer.parseInt( guessEditor.getText().toString() );
    guessEditor.setText( "" );
    if( guess < this.number )
    {
      messageText.setText( guess + " is " + getString( R.string.too_low ) );
    }
    else if( guess > this.number )
    {
      messageText.setText( guess + " is " + getString( R.string.too_high ) );
    }
    else
    {
      messageText.setText( R.string.you_win );
      this.guessEditor.setEnabled( false );
      this.guessButton.setEnabled( false );
    }
  }

  @Override
  public boolean onCreateOptionsMenu( Menu menu )
  {
    getMenuInflater().inflate( R.menu.activity_hi_lo, menu );
    return true;
  }
}
