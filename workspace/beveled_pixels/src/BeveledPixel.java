import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Composite;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.Rectangle2D;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class BeveledPixel extends JPanel {
	public void paint(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;

		// the rendering quality.
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

		// a red rectangle.
		Rectangle2D r = new Rectangle2D.Double(50, 50, 550, 100);
		g2.setPaint(Color.red);
		g2.fill(r);

		// a composite with transparency.
		Composite c = AlphaComposite.getInstance(AlphaComposite.SRC_OVER, .3f);
		g2.setComposite(c);
		// Draw some blue text.
		g2.setPaint(Color.blue);
		g2.setFont(new Font("Times New Roman", Font.PLAIN, 72));
		g2.drawString("Java Source and Support", 25, 130);
	}

	@SuppressWarnings("deprecation")
	public static void main(String[] args) {
		JFrame f = new JFrame();
		f.getContentPane().add(new BeveledPixel());
		f.setSize(800, 250);
		f.show();
	}
}