package dfcs.cs359.customcomponentdemo;

/**
 * Description: Demonstrating a custom view on which drawing can be done.
 * 
 * @author Randall.Bower
 */
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

public class MagicView extends View
{
  private Paint paint;
  
  public MagicView( Context context )
  {
    super( context );
    init();
  }

  public MagicView( Context context, AttributeSet attrs )
  {
    super( context, attrs );
    init();
  }

  public MagicView( Context context, AttributeSet attrs, int defStyle )
  {
    super( context, attrs, defStyle );
    init();
  }
  
  private void init()
  {
    paint = new Paint();
    paint.setColor(  Color.BLACK );
  }

  public void onDraw( Canvas c )
  {
    c.drawColor( Color.CYAN );
    
    c.drawLine( 0, 0, getWidth(), 0, paint ); // Top
    c.drawLine( 0, getHeight(), getWidth(), getHeight(), paint ); // Bottom
    c.drawLine( 0, 0, 0, getHeight(), paint ); // Left
    c.drawLine( getWidth(), 0, getWidth(), getHeight(), paint ); // Right
    c.drawLine( 0, 0, getWidth(), getHeight(), paint ); // X
    c.drawLine( 0, getHeight(), getWidth(), 0, paint ); // X
  }
}
