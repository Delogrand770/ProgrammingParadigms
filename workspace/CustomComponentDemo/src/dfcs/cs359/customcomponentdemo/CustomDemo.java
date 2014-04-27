package dfcs.cs359.customcomponentdemo;

import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Description: A simple app that demonstrates three custom components.
 * 
 * The Android Menu button gives access to each of the three demos.
 * 
 * Note: The demos are NOT launched as new activities, so no matter how
 * many screens are displayed as the user switches from one demo to another,
 * the Android back button will immediately exit the app.
 * 
 * @author Randall.Bower
 */
public class CustomDemo extends Activity
{
  @Override
  public void onCreate( Bundle savedInstanceState )
  {
    Log.d( "CUSTOM DEMO", "onCreate()..." );

    super.onCreate( savedInstanceState );
    setContentView( R.layout.activity_custom_demo );

    if( savedInstanceState != null )
    {
      int rand = savedInstanceState.getInt( "rand", -1 ); // -1 is default value
      Log.d( "CUSTOM DEMO", String.format( "Found %d in bundle...", rand ) );
    }
  }

  @Override
  public boolean onCreateOptionsMenu( Menu menu )
  {
    Log.d( "CUSTOM DEMO", "onCreateOptionsMenu()..." );
    getMenuInflater().inflate( R.menu.activity_custom_demo, menu );
    return true;
  }

  public void home( MenuItem item )
  {
    Log.d( "CUSTOM DEMO", "home()..." );
    setContentView( R.layout.activity_custom_demo );
  }

  public void dateViewDemo( MenuItem item )
  {
    Log.d( "CUSTOM DEMO", "dateViewDemo()..." );
    setContentView( R.layout.date_view_demo );
  }

  public void magicButtonDemo( MenuItem item )
  {
    Log.d( "CUSTOM DEMO", "magicButtonDemo()..." );
    setContentView( R.layout.magic_button_demo );
  }

  public void magicButtonMethod( View v )
  {
    Log.d( "CUSTOM DEMO", "magicButtonMethod()..." );
    Toast.makeText( this, "Hey, you hit\nmy button!", Toast.LENGTH_SHORT ).show();
  }

  public void lengthPickerDemo( MenuItem item )
  {
    Log.d( "CUSTOM DEMO", "lengthPickerDemo()..." );
    setContentView( R.layout.length_picker_demo );
  }

  public void updateArea( View v )
  {
    Log.d( "CUSTOM DEMO", "updateArea()..." );
    LengthPicker widthPicker = (LengthPicker) findViewById( R.id.width );
    LengthPicker heightPicker = (LengthPicker) findViewById( R.id.height );
    TextView mArea = (TextView) findViewById( R.id.area );

    int area = widthPicker.getNumInches() * heightPicker.getNumInches();
    mArea.setText( getString( R.string.area_format, area ) );
  }

  public void customViewDemo( MenuItem item )
  {
    Log.d( "CUSTOM DEMO", "customViewDemo()..." );
    setContentView( R.layout.custom_view_demo );
  }

  /*
   * The following methods illustrate the Android Activity Life Cycle.
   * http://developer.android.com/reference/android/app/Activity.html
   */

  @Override
  protected void onStart()
  {
    super.onStart(); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onStart()..." );
  }

  @Override
  protected void onRestart()
  {
    super.onRestart(); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onRestart()..." );
  }

  @Override
  protected void onResume()
  {
    super.onResume(); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onResume()..." );
  }

  @Override
  protected void onPause()
  {
    super.onPause(); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onPause()..." );
  }

  @Override
  protected void onStop()
  {
    super.onStop(); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onStop()..." );
  }

  @Override
  protected void onDestroy()
  {
    super.onDestroy(); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onDestroy()..." );
  }

  @Override
  protected void onSaveInstanceState( Bundle outState )
  {
    super.onSaveInstanceState( outState ); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onSaveInstanceState()..." );
    
    int rand = (int)( Math.random() * 1024 );
    outState.putInt( "rand", rand );
    Log.d( "CUSTOM DEMO", String.format( "Putting %d in bundle...", rand ) );
  }

  @Override
  protected void onRestoreInstanceState( Bundle savedInstanceState )
  {
    super.onRestoreInstanceState( savedInstanceState ); // Must do this or app will crash!
    Log.d( "CUSTOM DEMO", "onRestoreInstanceState()..." );

    if( savedInstanceState != null )
    {
      int rand = savedInstanceState.getInt( "rand", -1 ); // -1 is default value
      Log.d( "CUSTOM DEMO", String.format( "Found %d in bundle...", rand ) );
    }
  }
}
