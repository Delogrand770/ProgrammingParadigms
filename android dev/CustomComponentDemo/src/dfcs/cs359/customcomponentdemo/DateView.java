package dfcs.cs359.customcomponentdemo;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

/**
 * Description: http://www.sqisland.com/talks/android-custom-components/#1
 * 
 * @author Chiu-Ki Chan
 */
public class DateView extends TextView
{
  public DateView( Context context )
  {
    super( context );
    setDate();
  }

  public DateView( Context context, AttributeSet attrs )
  {
    super( context, attrs );
    setDate();
  }

  public DateView( Context context, AttributeSet attrs, int defStyle )
  {
    super( context, attrs, defStyle );
    setDate();
  }

  private void setDate()
  {
    SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd" );
    String today = dateFormat.format( Calendar.getInstance().getTime() );
    setText( today );
  }
}
