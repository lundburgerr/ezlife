package ezlife;

import java.awt.*;
import java.awt.image.*;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class Main {

	public static void main(String[] args) {
		PokerTable table;
		
		
		Image image;
		ImageIcon imageicon;
		JFrame frame = new JFrame("FrameDemo");
		BufferedImage bimage;
		Point p = new Point(1,1);
		
		
		try {
			table = new PokerTable();
		} catch (AWTException e) {
			e.printStackTrace();
			return;
		}
		
		// Show screenshot
		table.updateStatus();
		bimage = table.getTableImage();
		imageicon = new ImageIcon(bimage);
		
        JLabel label = new JLabel("", imageicon, JLabel.CENTER);
        JPanel panel = new JPanel(new BorderLayout());
        panel.add(label, BorderLayout.CENTER );
        
        frame.setSize(imageicon.getIconWidth(), imageicon.getIconHeight()+45);
        frame.add(panel);
        frame.setVisible(true);
        
        // Sleep for a few seconds
//        try {
//            Thread.sleep(3000);                 //1000 milliseconds is one second.
//        } catch(InterruptedException ex) {
//            Thread.currentThread().interrupt();
//        }
		
        System.out.println("hej");

	}

}
