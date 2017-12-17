package lab6;

public class MovablePoint implements Movable {
	int x, y, xSpeed, ySpeed;
	

	public MovablePoint(int x, int y, int xSpeed, int ySpeed) {
		// TODO Auto-generated constructor stub
		this.x = x;
		this.y = y;
		this.xSpeed = xSpeed;
		this.ySpeed = ySpeed;
		
		
	}

	public String toString() {
		return "Point at("+x+","+y+")";
	}
	
	
	public void moveUp() {
		// TODO Auto-generated method stub
		y-= ySpeed;
	}

	
	public void moveDown() {
		// TODO Auto-generated method stub
		y+= ySpeed;
	}

	
	public void moveLeft() {
		// TODO Auto-generated method stub
		x-= xSpeed;
	}

	
	public void moveRight() {
		// TODO Auto-generated method stub
		x+= xSpeed;
	}
	public static void compare(MovablePoint p1, MovablePoint p2){
		if (p1.x==p2.x && p1.y==p2.y)
			System.out.println("Poins are equal");
		else 
			System.out.println("Not equal");
	}

}
