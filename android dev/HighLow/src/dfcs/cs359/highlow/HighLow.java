package dfcs.cs359.highlow;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

/**
 * File: HighLow.java
 *
 * Description: A version of the High-Low guessing game that uses multiple screens.
 *
 * @author Randall.Bower
 */
public class HighLow extends Activity implements OnClickListener
{
  private final static int HIGHLOW = 37; // Unique value to use as the request code. Why 37? Why not?!
  private int min, max, randomNumber;

  /** Called when the activity is first created. */
  @Override
  public void onCreate( Bundle savedInstanceState )
  {
    Log.d( "HighLow", "onCreate()..." + this.randomNumber );

    // Start with the main layout screen.
    super.onCreate( savedInstanceState );
    setContentView( R.layout.activity_high_low );

    // Have this activity listen for clicks on either button.
    Button b = (Button) findViewById( R.id.guessButton );
    b.setOnClickListener( this );
    b = (Button) findViewById( R.id.newGame );
    b.setOnClickListener( this );
    
    this.randomNumber = (int) ( Math.random() * 100 ) + 1; // [1,100]
    this.min = 1;   // Lowest allowable guess.
    this.max = 100; // Highest allowable guess.
    
    Log.d( "HighLow", "randomNumber = " + this.randomNumber );
  }

  /**
   * Since this activity is listening for click events on both buttons,
   * the view object is used to determine if it was the new game button,
   * which resets the local variables.
   * 
   * @param v View object that generated this event.
   */
  public void onClick( View v )
  {
    Log.d( "HighLow", "onClick()..." );
    if( v.getId() == R.id.newGame )
    {
      // Random number between 1 and 100;
      this.randomNumber = (int) ( Math.random() * 100 ) + 1;
      this.min = 1;
      this.max = 100;
      Log.d( "HighLow", "randomNumber = " + this.randomNumber );
    }

    // Create a new Intent with this application context and the GetNumber class.
    Intent intent = new Intent( getApplicationContext(), dfcs.cs359.highlow.GetNumber.class );
    // Put a couple extra bits of information in the bundle for the GetNumber class to use.
    intent.putExtra( "min", this.min );
    intent.putExtra( "max", this.max );
    // Start the activity and indicate that this activity should be notified when
    // there is a result; use the unique identifier HIGHLOW so we can determine
    // between several activities that might be sending results.
    startActivityForResult( intent, HIGHLOW );
  }

  /**
   * Called when an activity you launched exits, giving you the requestCode you
   * started it with, the resultCode it returned, and any additional data from it.
   * 
   * @param requestCode The integer request code originally supplied to
   *                    startActivityForResult(), allowing you to identify
   *                    who this result came from.
   * @param resultCode The integer result code returned by the child activity
   *                   through its setResult().
   * @param data An Intent, which can return result data to the caller
   *             (various data can be attached to Intent "extras").
   */
  @Override
  protected void onActivityResult( int requestCode, int resultCode, Intent data )
  {
    Log.d( "HighLow", "onActivityResult()..." );
    if( requestCode == HIGHLOW )
    {
      if( resultCode == RESULT_OK )
      {
        TextView message = (TextView) findViewById( R.id.message );

        int number = data.getIntExtra( "number", -1 );

        if( number < this.randomNumber )
        {
          message.setText( number + " " + getString( R.string.toolow ) );
          this.min = number;
        }
        else if( number > this.randomNumber )
        {
          message.setText( number + " " + getString( R.string.toohigh ) );
          this.max = number;
        }
        else
        {
          message.setText( number + " " + getString( R.string.correct ) );
          this.min = this.randomNumber;
          this.max = this.randomNumber;
        }
      }
    }
  }
}
