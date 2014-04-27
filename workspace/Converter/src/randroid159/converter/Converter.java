package randroid159.converter;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Toast;

public class Converter extends Activity {
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		DownloadRSS("http://rss.cnn.com/rss/cnn_topstories.rss");

		// DownloadRSS( "http://www.reddit.com/r/funny/.rss" );

		// TextView rateLabel = (TextView) findViewById( R.id.rate );
		// rateLabel.setText( "Rate: " + rate );
	}

	/*
	 * http://www.devx.com/wireless/Article/39810/1954
	 */
	private InputStream OpenHttpConnection(String urlString) throws IOException {
		InputStream in = null;
		int response = -1;

		URL url = new URL(urlString);
		URLConnection conn = url.openConnection();

		if (!(conn instanceof HttpURLConnection))
			throw new IOException("Not an HTTP connection");

		try {
			HttpURLConnection httpConn = (HttpURLConnection) conn;
			httpConn.setAllowUserInteraction(false);
			httpConn.setInstanceFollowRedirects(true);
			httpConn.setRequestMethod("GET");
			httpConn.connect();

			response = httpConn.getResponseCode();
			if (response == HttpURLConnection.HTTP_OK) {
				in = httpConn.getInputStream();
			}
		} catch (Exception ex) {
			throw new IOException("Error connecting");
		}
		return in;
	}

	// @SuppressWarnings("unused")
	private void DownloadRSS(String URL) {
		InputStream in = null;
		try {
			in = OpenHttpConnection(URL);
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

			doc.getDocumentElement().normalize();

			// ---retrieve all the <item> nodes---
			NodeList itemNodes = doc.getElementsByTagName("item");

			String strTitle = "";
			for (int i = 0; i < itemNodes.getLength(); i++) {
				Node itemNode = itemNodes.item(i);
				if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
					// ---convert the Node into an Element---
					Element itemElement = (Element) itemNode;

					// ---get all the <title> element under the <item>
					// element---
					NodeList titleNodes = (itemElement).getElementsByTagName("title");

					// ---convert a Node into an Element---
					Element titleElement = (Element) titleNodes.item(0);

					// ---get all the child nodes under the <title> element---
					NodeList textNodes = ((Node) titleElement).getChildNodes();

					// ---retrieve the text of the <title> element---
					strTitle = ((Node) textNodes.item(0)).getNodeValue();

					// ---display the title---
					Toast.makeText(getBaseContext(), strTitle, Toast.LENGTH_LONG).show();
				}
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
}