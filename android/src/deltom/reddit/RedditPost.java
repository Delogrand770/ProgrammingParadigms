package deltom.reddit;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;

public class RedditPost implements Parcelable {

	private String title = null;
	private String link = null;
	private String date = null;
	private String description = null;
	private String thumb = null;

	public RedditPost(String title, String link, String date, String description, String thumb) {
		this.title = title;
		this.link = link;
		this.date = date;
		this.description = description;
		this.thumb = thumb;
	}

	/**
	 * Constructor for when the data is being made parcelable for the intent transfer.
	 * 
	 * @param source
	 */
	public RedditPost(Parcel source) {
		Log.d("REDDIT", "ParcelData(Parcel source): time to put back parcel data");
		this.title = source.readString();
		this.link = source.readString();
		this.date = source.readString();
		this.description = source.readString();
		this.thumb = source.readString();
	}

	/**
	 * Gets the requested data. Never used this but still made it.
	 * 
	 * @param item
	 *            - The data wanted
	 * @return - A string with the wanted data.
	 */
	public String getData(String item) {
		if (item.compareToIgnoreCase("title") == 1) {
			return this.title;
		} else if (item.compareToIgnoreCase("description") == 1) {
			return this.description;
		} else if (item.compareToIgnoreCase("link") == 1) {
			return this.link;
		} else if (item.compareToIgnoreCase("date") == 1) {
			return this.date;
		} else if (item.compareToIgnoreCase("thumb") == 1) {
			return this.thumb;
		} else {
			return "Unsupported Data Request: " + item;
		}
	}

	// The following methods are the accessor methods for the data contained in the object.
	public String getTitle() {
		return this.title;
	}

	public String getLink() {
		return this.link;
	}

	public String getDate() {
		return this.date;
	}

	public String getDescription() {
		return this.description;
	}

	public String getThumb() {
		return this.thumb;
	}

	/**
	 * Just for testing purposes. Logs what is in this object.
	 */
	public void log() {
		Log.d("REDDIT", "----------\nTitle: " + title + "\nLink: " + link + "\nDate: " + date + "\nDescription: " + description + "\nThumb: " + thumb + "\n----------");
	}

	@Override
	/**
	 * Needed to make parcelable
	 */
	public int describeContents() {
		return hashCode();
	}

	@Override
	/**
	 * Writes the data in this object to a parcel.
	 */
	public void writeToParcel(Parcel dest, int flags) {
		Log.d("REDDIT", "writeToParcel()..." + flags);
		dest.writeString(title);
		dest.writeString(link);
		dest.writeString(date);
		dest.writeString(description);
		dest.writeString(thumb);
	}

	/**
	 * Needed to retrieve the data from the parcel.
	 */
	public static final Parcelable.Creator<RedditPost> CREATOR = new Parcelable.Creator<RedditPost>() {
		public RedditPost createFromParcel(Parcel in) {
			return new RedditPost(in);
		}

		public RedditPost[] newArray(int size) {
			return new RedditPost[size];
		}
	};
}
