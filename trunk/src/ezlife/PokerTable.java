package ezlife;

import java.awt.AWTException;
import java.awt.image.BufferedImage;

public class PokerTable {
	private int id;
	private int x;
	private int y;
	private int width;
	private int height;
	private ComputerScreen screen;
	private BufferedImage tableImage;
	private static int tableCount = 0;
	
	
	public PokerTable(int x, int y, int width, int height) throws AWTException{
		tableCount++;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		screen = new ComputerScreen(x, y, width, height);
	}
	
	public void updateStatus(){
		tableImage = screen.captureWindow();
	}
	
	public BufferedImage getTableImage(){
		return tableImage;
	}
	
	public int getId() {
		return id;
	}

	public static int getTableCount() {
		return tableCount;
	}

}
