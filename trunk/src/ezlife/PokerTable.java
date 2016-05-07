package ezlife;

import java.awt.AWTException;
import java.awt.image.BufferedImage;

public class PokerTable {
	private ComputerScreen screen;
	private BufferedImage tableImage;
	
	public PokerTable() throws AWTException{
		screen = new ComputerScreen(1, 0, 0, 600, 600);
	}
	
	public void updateStatus(){
		tableImage = screen.captureWindow();
	}
	
	public BufferedImage getTableImage(){
		return tableImage;
	}

}
