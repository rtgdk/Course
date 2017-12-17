import java.util.*;
class Test
{
	public static void main(String args[])
	{
		int x = Integer.parseInt(args[0]);

		String s1 = "Java";
		String s2 = "Object";

		if( x == 0)
			System.out.println(s1.compareTo(s2));
		else
			System.out.println(s1.compareToIgnoreCase(s2));
		
	}
}	


	