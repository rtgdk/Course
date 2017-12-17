import java.awt.*;
import javax.swing.*;
import java.awt.geom.*;

class CircleIcon implements Icon
{
	private double radius;
	CircleIcon(double radius)
	{
		this.radius = radius;
	}

	public int getIconHeight()	{	return (int) radius; }
	public int getIconWidth()	{	return (int) radius; }

	public void paintIcon(Component c, Graphics g, int x, int y)
	{
		Graphics2D g2 = (Graphics2D) g;
		Ellipse2D.Double circle= new Ellipse2D.Double(x,y,radius,radius);
		g2.draw(circle);
	}
}

class IconComponent extends JComponent
{
	private Icon icon;
	IconComponent(Icon icon)
	{
		this.icon = icon;
	}
	
	public void paintComponent(Graphics g)
	{
		icon.paintIcon(this,g,50,50);
	}
}

class Test
{
	public static void main(String args[])
	{
		CircleIcon circle = new CircleIcon(50);
		
		IconComponent iconC = new IconComponent(circle);

		JFrame f = new JFrame("My Frame");
		f.setSize(600,600);

		f.setLayout(new BorderLayout());

		f.add(iconC, BorderLayout.CENTER);
	
		f.setVisible(true);
	}
}