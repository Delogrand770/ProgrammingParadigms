package dfcs.cs359.customcomponentdemo;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

/**
 * Description: http://www.sqisland.com/talks/android-custom-components/#1
 * 
 * @author Chiu-Ki Chan
 */
public class LengthPicker extends LinearLayout implements View.OnClickListener
{
  private TextView mTextView;
  private View mMinusButton;

  private View mPlusButton;
  private int mNumInches = 0;

  public LengthPicker( Context context )
  {
    super( context );
    init();
  }

  public LengthPicker( Context context, AttributeSet attrs )
  {
    super( context, attrs );
    init();
  }

  public LengthPicker( Context context, AttributeSet attrs, int defStyle )
  {
    super( context, attrs, defStyle );
    init();
  }

  private void init()
  {
    LayoutInflater inflater = (LayoutInflater) getContext().getSystemService( Context.LAYOUT_INFLATER_SERVICE );
    inflater.inflate( R.layout.length_picker, this );

    mPlusButton = findViewById( R.id.plus_button );
    mTextView = (TextView) findViewById( R.id.text );
    mMinusButton = findViewById( R.id.minus_button );

    updateControls();

    mPlusButton.setOnClickListener( this );
    mMinusButton.setOnClickListener( this );
  }

  private void updateControls()
  {
    int feet = mNumInches / 12;
    int inches = mNumInches % 12;

    String text = String.format( "%d' %d\"", feet, inches );
    if( feet == 0 )
    {
      text = String.format( "%d\"", inches );
    }
    else
    {
      if( inches == 0 )
      {
        text = String.format( "%d'", feet );
      }
    }
    mTextView.setText( text );

    mMinusButton.setEnabled( mNumInches > 0 );
  }

  public int getNumInches()
  {
    return mNumInches;
  }

  public void onClick( View v )
  {
    switch( v.getId() )
    {
      case R.id.plus_button:
        mNumInches++;
        updateControls();
        break;
      case R.id.minus_button:
        if( mNumInches > 0 )
        {
          mNumInches--;
          updateControls();
        }
        break;
    }
  }
}
