package ezlife;
import java.awt.AWTException;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.image.*;

import javax.swing.JComponent;

public class ComputerScreen {
	
	private int id; //Uniquely defines the poker window
	private Robot robot; //Used to capture the screen
	
	public ComputerScreen(int id) throws AWTException{
		this.id = id;
		this.robot = new Robot();
	}
	
	public BufferedImage captureWindow(){
		Toolkit t = Toolkit.getDefaultToolkit();
		Rectangle screenRect = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
		BufferedImage screenShot = robot.createScreenCapture(screenRect);
		
		return screenShot;
	}
	
//	public void drawScreenRectangle(Point start, Point end){
//		Window w = new Window(null);
//		RectangleContour rect = new RectangleContour(start, end);
//	}
	
	
//	private class RectangleContour extends JComponent{
//		private static final long serialVersionUID = 1L;
//		private Point start;
//		private Point end;
//
//		public RectangleContour(Point start, Point end){
//			this.start = start;
//			this.end = end;
//			return;
//		}
//		
//		public void setRectangle(Point start, Point end){
//			
//		}
//	}
	
}
