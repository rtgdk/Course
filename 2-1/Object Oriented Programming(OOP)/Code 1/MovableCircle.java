package lab6;

public class MovableCircle implements Movable {
	public MovablePoint center;
	private int radius;

	public MovableCircle(int x, int y, int xSpeed, int ySpeed, int radius) {
		// TODO Auto-generated constructor stub
		center = new MovablePoint(x, y, xSpeed, ySpeed);
		this.radius = radius;
	}

	public String toString() {
		return "Point at(" + center.x + "," + center.y + ")";
	}

	@Override
	public void moveUp() {
		// TODO Auto-generated method stub
		center.y -= center.ySpeed;
	}

	@Override
	public void moveDown() {
		// TODO Auto-generated method stub
		center.y += center.ySpeed;
	}

	@Override
	public void moveLeft() {
		// TODO Auto-generated method stub
		center.x -= center.xSpeed;
	}

	@Override
	public void moveRight() {
		// TODO Auto-generated method stub
		center.x += center.xSpeed;
	}
	public void compare1(MovableCircle p1, MovableCircle p2){
		if (p1.radius==p2.radius){
			System.out.println("Radius is equal");
		}
		else 
			System.out.println("Not equal");
		
	}
	public void compare2(MovableCircle p1, MovableCircle p2){
		if (p1.center.x==p2.center.x && p1.center.x==p2.center.y){
			System.out.println("Center is equal");
		}
		else 
			System.out.println("Not equal");
		
	}
	public void compare3(MovableCircle p1, MovableCircle p2){
		if (p1.radius==p2.radius && p1.center.x==p2.center.x && p1.center.x==p2.center.y){
			System.out.println("Circles is equal");
		}
		else 
			System.out.println("Not equal");
		}
}
