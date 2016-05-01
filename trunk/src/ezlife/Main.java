package ezlife;

import java.awt.AWTException;
import java.awt.BorderLayout;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class Main {

	public static void main(String[] args) {
		ComputerScreen window = null;
		Image image;
		ImageIcon imageicon;
		JFrame frame = new JFrame("FrameDemo");
		BufferedImage bimage;
		try {
			window = new ComputerScreen(1);
		} catch (AWTException e) {
			e.printStackTrace();
		}
		
		File imagefile = new File("C:\\Users\\Robin Lundberg\\ezlife\\img\\table2.png");
//        try {
//			image = ImageIO.read(imagefile);
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//		imageicon = new ImageIcon("C:\\Users\\Robin Lundberg\\ezlife\\img\\table2.png");
		
		bimage = window.captureWindow();
		imageicon = new ImageIcon(bimage);
		
        JLabel label = new JLabel("", imageicon, JLabel.CENTER);
        JPanel panel = new JPanel(new BorderLayout());
        panel.add(label, BorderLayout.CENTER );
        
        frame.setSize(imageicon.getIconWidth(), imageicon.getIconHeight()+45);
        frame.add(panel);
        frame.setVisible(true);
        
		
		

	}

}
