package dfcs.cs359.buttons;

import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

public class ButtonDemo extends Activity implements OnClickListener
{
  private final static int QUIT_BUTTON_DIALOG = 0;
  private final static int LEFT_BUTTON_DIALOG = 1;
  private final static int RIGHT_BUTTON_DIALOG = 2;

  @Override
  public void onCreate( Bundle savedInstanceState )
  {
    super.onCreate( savedInstanceState );
    setContentView( R.layout.activity_button_demo );

    // Finding something by id has to be done after the setContentView above!
    Button leftButton = (Button) findViewById( R.id.left_button );
    leftButton.setOnClickListener( new View.OnClickListener()
    {
      public void onClick( View v )
      {
        Log.d( "BUTTON FUN", "leftButton's onClick()..." );
        Log.d( "BUTTON FUN", "View class = " + v.getClass().getName() ); // Polymorphism!
        Toast.makeText( ButtonDemo.this, "Hey, you hit my\nleft button!", Toast.LENGTH_LONG ).show();
      }
    } );

    Button rightButton = (Button) findViewById( R.id.right_button );
    rightButton.setOnClickListener( this );
  }

  public void onClick( View v )
  {
    Log.d( "BUTTON FUN", "rightButton's onClick()..." );
    Log.d( "BUTTON FUN", "View class = " + v.getClass().getName() ); // Polymorphism!
    showDialog( RIGHT_BUTTON_DIALOG );
  }

  public void quitButtonMethod( View v )
  {
    Log.d( "BUTTON FUN", "quitButton's onClick()..." );
    Log.d( "BUTTON FUN", "View class = " + v.getClass().getName() ); // Polymorphism!
    showDialog( QUIT_BUTTON_DIALOG );
  }

  @Override
  protected Dialog onCreateDialog( int id )
  {
    Dialog dialog = null;
    AlertDialog.Builder builder;

    switch( id )
    {
      case QUIT_BUTTON_DIALOG:
        builder = new AlertDialog.Builder( this );
        // setCancelable( false ) - User must click one of the buttons on the dialog.
        builder.setMessage( "Are you sure you want to quit?" ).setCancelable( false )
        .setPositiveButton( "Yes", new DialogInterface.OnClickListener()
        {
          public void onClick( DialogInterface dialog, int id )
          {
            ButtonDemo.this.finish();
          }
        } ).setNegativeButton( "No", new DialogInterface.OnClickListener()
        {
          public void onClick( DialogInterface dialog, int id )
          {
            dialog.cancel();
          }
        } );
        dialog = builder.create();
        break;
      case LEFT_BUTTON_DIALOG:
        // This case not used ... the left button in this demo popped up a Toast message.
        break;
      case RIGHT_BUTTON_DIALOG:
        builder = new AlertDialog.Builder( this );
        // setCancelable( true ) - Allows the Android device's back button to close the dialog.
        builder.setMessage( "You clicked the Right button." ).setCancelable( true )
        .setNeutralButton( "Close", new DialogInterface.OnClickListener()
        {
          public void onClick( DialogInterface dialog, int id )
          {
            dialog.cancel();
          }
        } );
        dialog = builder.create();
        break;
      default:
        dialog = null;
    }
    return dialog;
  }

  @Override
  public boolean onCreateOptionsMenu( Menu menu )
  {
    getMenuInflater().inflate( R.menu.activity_button_demo, menu );
    return true;
  }
}
