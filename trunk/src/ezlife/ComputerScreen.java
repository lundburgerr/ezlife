package ezlife;
import java.awt.*;
import java.awt.image.*;
import java.text.AttributedCharacterIterator;
import java.util.ArrayList;

import javax.swing.JComponent;

public class ComputerScreen {
	
	private int id; //Uniquely defines the poker window
	int x;
	int y;
	int width;
	int height;
	
	private Robot robot; //Used to capture the screen
	private ScreenField screen;
	
	public ComputerScreen(int id, int x, int y, int width, int height) throws AWTException{
		this.id = id;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.robot = new Robot();
		screen = new ScreenField(x, y, width, height);
	}
	
	/**
	 * Takes a screenshot of a specified portion of your window
	 *
	 * @return screenshot of window
	 */
	public BufferedImage captureWindow(){
		//Rectangle screenRect = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
		Rectangle screenRect = new Rectangle(x, y, width, height);
		BufferedImage screenShot = robot.createScreenCapture(screenRect);
		
		return screenShot;
	}
	
	
	private class ScreenField {

		private Window field;
		
		public ScreenField(int x, int y, int width, int height){
			field = new Window(null)
			{
				private static final long serialVersionUID = -2576011115125513080L;
				
				@Override
				public void paint(Graphics g)
				{
					g.drawRect(x, y, width, height);
					g.setColor(new Color(0x101010)); //representing R G B with R as the first 2 hex
				}
				@Override
				public void update(Graphics g)
				{
					paint(g);
				}
			};			
			
			field.setAlwaysOnTop(true);
			field.setBounds(field.getGraphicsConfiguration().getBounds());
			field.setBackground(new Color(0, true));
			field.setVisible(true);
		}

	}
	
}
