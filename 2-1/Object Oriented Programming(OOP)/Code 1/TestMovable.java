package lab6;

public class TestMovable {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Movable m1 = new MovablePoint(5, 6, 10, 12);
		System.out.println(m1);
		m1.moveLeft();
		System.out.println(m1);

		Movable m2 = new MovableCircle(2, 1, 2, 20, 4);
		System.out.println(m2);
		m2.moveRight();
		System.out.println(m2);
		MovablePoint m3= new MovablePoint(5, 6, 10, 12);
		MovablePoint m4= new MovablePoint(5, 6, 10, 12);
		MovablePoint.compare(m3 , m4);
	}

}
