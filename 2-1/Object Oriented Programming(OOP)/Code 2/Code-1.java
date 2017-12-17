tTimeinterface X { }
interface Y { }
class A implements X
{
	public void doA1()
	{
		Date d1 = new Date();
		Date d2 = new Date();
		long a = d2.getTime();
		long b = d1.getTime();
		long x = a - b;
		doA2(x);
	}
	public void doA2(long a)
	{
		System.out.println("a= " + a);	
	}
}
class B 
{
	private A a;
	B(A a) { this.a = a; }
	public void doA2()
	{
		A a1 = new A();
		A a2 = new A();

		a1.doA1();
		a2.doA1();	
	}
	
}
class Test
{
	public static void main(String args[])
	{
		Date d1 = new Date();
		Date d2 = new Date();

		d1.setTime(1000);
		d2.setTime(2000);

		System.out.println(d1.isAfter(d2);
	}
}	


	