
public class StaticExample {
	
	static {
		System.out.println("this is 1st static block");
		
	}
	
	public void staticExample(){
		System.out.println("This is constructor");
	}
	
	public static String staticString = "Static Variable";
	
	static {
		System.out.println("this is 2nd static block and "+staticString);	
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		StaticExample statEx = new StaticExample();
		StaticExample.staticMethod2();
		
	}

	static {
		staticMethod();
		System.out.println("this is 3rd static block");	
	}
	
	public static void staticMethod(){
		System.out.println("this is static method");
	}
	
	public static void staticMethod2(){
		System.out.println("this is static method2");
	}
}