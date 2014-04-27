package dfcs.cs359.highlow;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

/**
 * File: GetNumber.java
 * 
 * Description: Separate screen used to enter a number between low and high
 * bounds.
 * 
 * @author Randall.Bower
 */
public class GetNumber extends Activity implements OnClickListener
{
  private int min, max;

  /** Called when the activity is first created. */
  @Override
  public void onCreate( Bundle savedInstanceState )
  {
    Log.d( "GetNumber", "onCreate()..." );
    super.onCreate( savedInstanceState );
    setContentView( R.layout.activity_get_number );

    Bundle extras = getIntent().getExtras();
    if( extras != null )
    {
      this.min = extras.getInt( "min" );
      this.max = extras.getInt( "max" );
      TextView prompt = (TextView) findViewById( R.id.prompt );
      prompt.setText( this.min + " " + getString( R.string.and ) + " " + this.max );
    }

    Button b = (Button) findViewById( R.id.enterButton );
    b.setOnClickListener( this );
  }

  /**
   * Called when the user clicks on the Enter button.
   * 
   * @param v View object that generated this event.
   */
  public void onClick( View v )
  {
    Log.d( "GetNumberBetween", "onClick()..." );

    EditText e = (EditText) findViewById( R.id.number );
    try
    {
      int number = Integer.parseInt( e.getText().toString() );
      if( number < this.min || number > this.max )
      {
        TextView error = (TextView) findViewById( R.id.error );
        error.setText( getString( R.string.range ) );
      }
      else
      {
        Intent intent = getIntent(); // The intent that started this activity.
        intent.putExtra( "number", number ); // Put the result in the extras bundle.
        setResult( Activity.RESULT_OK, intent ); // Set the result code.
        finish(); // Finish this activity which will generate the callback to
                  // onActivityResult in the activity that launched this one.
      }
    }
    catch( Exception exp )
    {
      TextView error = (TextView) findViewById( R.id.error );
      error.setText( getString( R.string.invalid ) );
    }
  }
}
