package dfcs.cs359.customcomponentdemo;

/**
 * Description: A Button that changes its text every time it is clicked.
 * 
 * This is an example of both inheritance and polymorphism. Inheritance
 * allows this Button to inherit all of the behaviors of a regular Button
 * and polymorphism allows any app that uses this object to treat it just
 * like any other button.
 * 
 * @author Randall.Bower
 */
import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.widget.Button;

public class MagicButton extends Button
{
  // For a truly useful implementation of this class, the constructors
  // would mostly likely take as a parameter an array of strings, an
  // ArrayList of strings, or a single string to be parsed into the
  // various button labels.
  private static String[] buttons = { "One", "Two", "Three" };
  private static int buttonIndex = 0;

  public MagicButton( Context context )
  {
    super( context );
    this.setText( buttons[ buttonIndex ] );
  }

  public MagicButton( Context context, AttributeSet attrs )
  {
    super( context, attrs );
    this.setText( buttons[ buttonIndex ] );
  }

  public MagicButton( Context context, AttributeSet attrs, int defStyle )
  {
    super( context, attrs, defStyle );
    this.setText( buttons[ buttonIndex ] );
  }

  /**
   * Override the onTouchEvent to add behaviors to this button.
   * Note the onTouchEvent happens during one "touch" of a button,
   * allowing separate behaviors for pushing a button down and
   * releasing a button.
   * 
   * @param event Event object associated with this event.
   * @return true if event is handled; false otherwise. (Get this value from parent!)
   */
  @Override
  public boolean onTouchEvent( MotionEvent event )
  {
    Log.d( "MAGICBUTTON", "onTouchEvent()" );
    if( event.getAction() == MotionEvent.ACTION_UP )
    {
      buttonIndex = ( buttonIndex + 1 ) % buttons.length;
      setText( buttons[ buttonIndex ] );
    }
    return super.onTouchEvent( event );
  }
}
