package deltom.reddit;

/* Authors:
 * Gavin Delphia
 * Alex Thomson
 * 
 * Enhanced: 
 * Home.java passes information through an intent to Browse.java using a custom object. This custom object implements Parcelable.
 * 		Home.setupIntent - Creates intent
 * 		Home.onActivityResult - Handles intent response
 * 		Browse.onCreate - Receives intent
 * 		RedditPost.java - custom object / Parcelable implementation
 * We pull a XML resource from the Internet and store it in a custom object.
 * 		Home.downloadRSS
 * 		Home.openHttpConnection
 * 		RedditPost.java - custom object / Parcelable implementation
 * 			writeToParcel
 * 			describeContents
 * 			RedditPost(Parcel) constructor
 * 			Parcelable.Creator
 * 			
 * We believe we did the correct design practices for localization.
 * 		res/values/strings.xml
 * 
 * Prelim Documentation:
 * We did not receive help on this assignment.
 * 
 * PEX Documentation: 
 * How we learned to use ListView - http://www.vogella.com/articles/AndroidListView/article.html
 * How we learned to create an intent containing a list of custom objects - http://prasanta-paul.blogspot.com/2010/06/android-parcelable-example.html
 * How we learned to detect a specific button from an XML onClick - http://stackoverflow.com/questions/5706942/possibility-to-add-parameters-in-button-xml
 * How we learned to pull XML from the Internet - http://www.devx.com/wireless/Article/39810/1954
 */

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

@TargetApi(Build.VERSION_CODES.GINGERBREAD)
public class Home extends Activity {

	private boolean busy = false;
	private View browseButton;
	private EditText subreddit;
	public final static int BROWSE = 42; // Unique value to use as the request

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);

		browseButton = findViewById(R.id.button1);
		browseButton.setEnabled(false);
		subreddit = (EditText) findViewById(R.id.editText1);

		// The code to detect changes in a text field came from stack overflow.
		subreddit.addTextChangedListener(new TextWatcher() {
			public void afterTextChanged(Editable s) {
				browseButton.setEnabled(subreddit.getText().toString().length() != 0);
			}

			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			public void onTextChanged(CharSequence s, int start, int before, int count) {
			}
		});

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_home, menu);
		return true;
	}

	/**
	 * Validates the user subreddit input and attempts to start the XML download if the subreddit is valid.
	 * 
	 * @param v
	 */
	public void checkSubreddit(View v) {
		if (subreddit.getText().toString().isEmpty()) {
			Toast.makeText(getApplicationContext(), "Invalid Subreddit", Toast.LENGTH_LONG).show();
		} else {
			Toast.makeText(getApplicationContext(), "Loading...", Toast.LENGTH_LONG).show();
			browseButton.setEnabled(false);

			String url = "http://www.reddit.com/r/" + subreddit.getText().toString() + "/.xml";
			Log.d("REDDIT", "checkSubreddit() | url = " + url);

			ArrayList<RedditPost> postArray = downloadRSS(url);
			if (postArray != null) {
				setupIntent(postArray);
			} else {
				Toast.makeText(getApplicationContext(), "Invalid Subreddit", Toast.LENGTH_LONG).show();
				this.subreddit.setText("");
				browseButton.setEnabled(false);
			}
		}
	}

	/**
	 * Handles the MostPopular subreddit buttons.
	 * 
	 * @param v
	 */
	public void doPopular(View v) {
		if (!busy) {
			Toast.makeText(getApplicationContext(), "Loading...", Toast.LENGTH_LONG).show();
			busy = true;
			String subreddit = v.getTag().toString();

			String url = "http://www.reddit.com/r/" + subreddit + "/.xml";

			if (subreddit.equalsIgnoreCase("front")) {
				url = "http://www.reddit.com/.xml";
			}

			this.subreddit.setText(subreddit);
			ArrayList<RedditPost> postArray = Home.downloadRSS(url);
			setupIntent(postArray);
		}
	}

	/**
	 * Puts the subreddit data downloaded from the internets into the intent and starts the intent activity.
	 * 
	 * @param postArray
	 *            - The array of RedditPost objects that is going into the intent.
	 */
	public void setupIntent(ArrayList<RedditPost> postArray) {
		Log.d("REDDIT", "checkSubreddit() | Creating intent");
		// Create a new Intent with this application context and the Browse class.
		Intent intent = new Intent(getApplicationContext(), deltom.reddit.Browse.class);
		// Put a couple extra bits of information in the bundle for the Browse class to use.
		intent.putParcelableArrayListExtra("postArray", postArray);
		intent.putExtra("subreddit", subreddit.getText().toString());

		// Start the activity and indicate that this activity should be notified when
		// there is a result; use the unique identifier BROWSE so we can determine
		// between several activities that might be sending results.
		Log.d("REDDIT", "checkSubreddit() | Intent created");
		startActivityForResult(intent, BROWSE);
		Log.d("REDDIT", "checkSubreddit() | Activity started");
	}

	// The following methods handle the activity switching from the popup menu.
	public void showAbout(MenuItem item) {
		Log.d("REDDIT", "showAbout()...");
		setContentView(R.layout.activity_about);
	}

	public void showMostPopular(MenuItem item) {
		Log.d("REDDIT", "showMostPopular()...");
		setContentView(R.layout.activity_mostpopular);
	}

	public void showHome(MenuItem item) {
		Log.d("REDDIT", "showHome(2)...");
		this.subreddit.setText("");
		this.browseButton.setEnabled(false);
		setContentView(R.layout.activity_home);
	}

	public void showHelp(MenuItem item) {
		Log.d("REDDIT", "showHelp()...");
		setContentView(R.layout.activity_help);
	}

	public void showHome(View v) {
		Log.d("REDDIT", "showHome(1)...");
		setContentView(R.layout.activity_home);
		this.subreddit.setText("");
		browseButton.setEnabled(false);
	}

	public void showHelp(View v) {
		Log.d("REDDIT", "showHelp()...");
		setContentView(R.layout.activity_help);
	}

	/**
	 * Called when an activity you launched exits, giving you the requestCode you started it with, the resultCode it returned, and any additional data from it.
	 * 
	 * @param requestCode
	 *            The integer request code originally supplied to startActivityForResult(), allowing you to identify who this result came from.
	 * @param resultCode
	 *            The integer result code returned by the child activity through its setResult().
	 * @param data
	 *            An Intent, which can return result data to the caller (various data can be attached to Intent "extras").
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		Log.d("REDDIT", "onActivityResult()...");
		if (requestCode == BROWSE) {
			if (resultCode == RESULT_OK) {
				busy = false;
				this.subreddit.setText("");
				browseButton.setEnabled(false);
			}
		}
	}

	/*
	 * http://www.devx.com/wireless/Article/39810/1954
	 */
	private static InputStream openHttpConnection(String urlString) throws IOException {
		Log.d("REDDIT", "openHttpConnection() | url = " + urlString);
		InputStream in = null;
		int response = -1;

		URL url = new URL(urlString);
		URLConnection conn = url.openConnection();

		// Log.d("REDDIT", "1");
		if (!(conn instanceof HttpURLConnection))
			throw new IOException("Not an HTTP connection");

		try {
			// Log.d("REDDIT", "2");
			HttpURLConnection httpConn = (HttpURLConnection) conn;
			httpConn.setAllowUserInteraction(false);
			httpConn.setInstanceFollowRedirects(true);
			httpConn.setRequestMethod("GET");
			httpConn.connect();

			// Log.d("REDDIT", "3");
			response = httpConn.getResponseCode();
			if (response == HttpURLConnection.HTTP_OK) {
				in = httpConn.getInputStream();
			}
			// Log.d("REDDIT", "4");
		} catch (Exception ex) {
			throw new IOException("Error connecting");
		}
		// Log.d("REDDIT", "5");
		return in;
	}

	/**
	 * Downloads the subreddit XML data.
	 * 
	 * @param URL
	 *            - The url of the XML data.
	 * @return - A RedditPost object with the XML data inside.
	 */
	public static ArrayList<RedditPost> downloadRSS(String URL) {
		Log.d("REDDIT", "downloadRSS() | url = " + URL);
		ArrayList<RedditPost> postArray = new ArrayList<RedditPost>();
		InputStream in = null;
		try {
			in = openHttpConnection(URL);
			Document doc = null;
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db;

			try {
				db = dbf.newDocumentBuilder();
				doc = db.parse(in);
			} catch (ParserConfigurationException e) {
				e.printStackTrace();
			} catch (SAXException e) {
				e.printStackTrace();
			}

			if (doc == null) {
				Log.d("REDDIT", "Invalid Subreddit");
				return null;
			}

			doc.getDocumentElement().normalize();
			Log.d("REDDIT", "Trying to build crap");
			// ---retrieve all the <item> nodes---
			NodeList itemNodes = doc.getElementsByTagName("item");

			String[] tags = {"title", "link", "pubDate", "description"};
			String[] temp = new String[tags.length];
			for (int i = 0; i < itemNodes.getLength(); i++) {
				Node itemNode = itemNodes.item(i);
				if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
					for (int j = 0; j < temp.length; j++) {
						// ---convert the Node into an Element---
						Element itemElement = (Element) itemNode;

						// ---get all the <title> element under the <item>
						// element---
						NodeList titleNodes = (itemElement).getElementsByTagName(tags[j]);

						// ---convert a Node into an Element---
						Element titleElement = (Element) titleNodes.item(0);

						// ---get all the child nodes under the <title>
						// element---
						NodeList textNodes = ((Node) titleElement).getChildNodes();

						// ---retrieve the text of the <title> element---
						temp[j] = ((Node) textNodes.item(0)).getNodeValue();

					}
				}

				// Since there is a post limit we need to stop storing post data before we over index the array.
				if (i < Browse.MAXPOST) {
					postArray.add(i, new RedditPost(temp[0], temp[1], temp[2], temp[3], ""));
					postArray.get(i).log();
				} else {
					break;
				}
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		return postArray;
	}

	/*
	 * The following methods illustrate the Android Activity Life Cycle. http://developer.android.com/reference/android/app/Activity.html
	 */

	@Override
	protected void onStart() {
		super.onStart(); // Must do this or app will crash!
		Log.d("REDDIT", "onStart()...");
	}

	@Override
	protected void onRestart() {
		super.onRestart(); // Must do this or app will crash!
		Log.d("REDDIT", "onRestart()...");
	}

	@Override
	protected void onResume() {
		super.onResume(); // Must do this or app will crash!
		Log.d("REDDIT", "onResume()...");
	}

	@Override
	protected void onPause() {
		super.onPause(); // Must do this or app will crash!
		Log.d("REDDIT", "onPause()...");
	}

	@Override
	protected void onStop() {
		super.onStop(); // Must do this or app will crash!
		Log.d("REDDIT", "onStop()...");
	}

	@Override
	protected void onDestroy() {
		super.onDestroy(); // Must do this or app will crash!
		Log.d("REDDIT", "onDestroy()...");
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState); // Must do this or app will crash!
		Log.d("REDDIT", "onSaveInstanceState()...");

		// int rand = (int) (Math.random() * 1024);
		// outState.putInt("rand", rand);
		// Log.d("REDDIT", String.format("Putting %d in bundle...", rand));
	}

	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
		super.onRestoreInstanceState(savedInstanceState); // Must do this or app
															// will crash!
		Log.d("REDDIT", "onRestoreInstanceState()...");

		// if (savedInstanceState != null) {
		// int rand = savedInstanceState.getInt("rand", -1); // -1 is default
		// // value
		// Log.d("REDDIT", String.format("Found %d in bundle...", rand));
		// }
	}

}
