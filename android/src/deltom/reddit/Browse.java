package deltom.reddit;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class Browse extends Activity {
	public static final int MAXPOST = 10;
	public String subreddit = null;
	public ArrayList<RedditPost> postArray = new ArrayList<RedditPost>();

	@Override
	/**
	 * Loads the intent data and triggers the listview to populate.
	 */
	protected void onCreate(Bundle savedInstanceState) {
		Log.d("REDDIT", "onCreate() | Browse");
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_browse);

		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			postArray = extras.getParcelableArrayList("postArray");
			subreddit = extras.getString("subreddit");
		}

		Log.d("REDDIT", "onCreate() | Intent bundle success");
		Log.d("REDDIT", postArray.toString());
		fillData();
	}

	/**
	 * Populates the listview with the appropriate data.
	 */
	public void fillData() {
		Log.d("REDDIT", "fillData()...");

		TextView title = (TextView) findViewById(R.id.textView11);
		title.setText("/r/" + subreddit);

		ListView listView = (ListView) findViewById(R.id.listView1);
		String[] values = new String[MAXPOST + 1];
		values[0] = "back";
		for (int i = 0; i < values.length - 1; i++) {
			values[i + 1] = (i + 1) + ". " + postArray.get(i).getTitle();
		}

		// First paramenter - Context
		// Second parameter - Layout for the row
		// Third parameter - ID of the TextView to which the data is written
		// Forth - the Array of data
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);

		// Assign adapter to ListView
		listView.setAdapter(adapter);

		listView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				if (position == 0) {
					Log.d("REDDIT", "finish()...");
					Intent intent = getIntent(); // The intent that started this activity.
					setResult(Activity.RESULT_OK, intent); // Set the result code.
					finish(); // Finish this activity which will generate the callback to
								// onActivityResult in the activity that launched this one.
				} else {
					Toast.makeText(getApplicationContext(), parseDescription(position - 1), Toast.LENGTH_LONG).show();
				}
			}
		});

		Log.d("REDDIT", "fillData() | end");
	}

	/**
	 * Parses the description data to show only the author and number of comments.
	 * 
	 * @param position
	 *            - The listview position that was interacted with.
	 * @return - A string of the data to toast.
	 */
	public String parseDescription(int position) {
		String data = postArray.get(position).getDescription();

		// Parse poster data
		String poster = data.split("submitted by")[1];
		poster = poster.split("\">")[1];
		poster = poster.split("</a>")[0].trim();

		// Parse comment data
		String comments = data.split(">\\[")[2];
		comments = comments.split(" comments\\]")[0].trim();

		String result = "Posted by: " + poster + "\nComments: " + comments;
		return result;
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return true;
	}

}
