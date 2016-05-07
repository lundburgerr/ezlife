package ezlife;
import java.awt.*;
import java.awt.image.*;
import java.text.AttributedCharacterIterator;

import javax.swing.JComponent;

public class ComputerScreen {
	
	private int id; //Uniquely defines the poker window
	private Robot robot; //Used to capture the screen
	private Window screen;
	
	public ComputerScreen(int id) throws AWTException{
		this.id = id;
		this.robot = new Robot();
	}
	
	/**
	 * Takes a screenshot of a specified portion of your window
	 *
	 * @return screenshot of window
	 */
	public BufferedImage captureWindow(){
		Toolkit t = Toolkit.getDefaultToolkit();
		Rectangle screenRect = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
		BufferedImage screenShot = robot.createScreenCapture(screenRect);
		
		return screenShot;
	}
	
	public void drawScreenRectangle(int x, int y, int width, int height){
		screen = new Window(null)
		{
			private static final long serialVersionUID = -2576011115125513080L;
			
			@Override
			public void paint(Graphics g)
			{
				g.drawRect(x, y, width, height);
				g.setColor(new Color(0x111111)); //representing R G B with R as the first 2 hex
			}
			@Override
			public void update(Graphics g)
			{
				paint(g);
			}
		};			
		
		screen.setAlwaysOnTop(true);
		screen.setBounds(screen.getGraphicsConfiguration().getBounds());
		screen.setBackground(new Color(0, true));
		screen.setVisible(true);
	}
	
	public void resetScreen(){
		screen.repaint();
	}
	
}
