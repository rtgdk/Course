import java.util.*;
class Test
{
	public static void main(String args[])
	{
		Thread t1 = new Thread("One");
		Thread t2 = new Thread("Two");
		
		t1.start();
		t2.start();

		String s1 = "Java";
		String s2 = "Object";
		
		int x = Integer.parseInt(args[0]);
		Scanner sc = new Scanner(System.in);
		while( x == 0)
		{
			System.out.println(s1.equals(s2));
			x = sc.nextInt();
		}	
	}
}	


	