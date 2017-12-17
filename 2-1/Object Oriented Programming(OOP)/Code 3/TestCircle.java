class Circle{  
    static double PI;
    private double radius; 
    
    Circle(double radius) {          
    	this.radius = radius; 
    	Circle.PI = 3.141;
    }
    
    //accessor method 
	public double getRadius() { 
		return radius;
	}  
	
    //mutator method     
	public void setRadius(double radius) { 
		this.radius = radius; 
	}          
	
	//method to find the area      
	public double area() { 
		return(PI * radius * radius);
	} 
	     
	public final void getCircumference(double radius) {       
		System.out.println("Circumference = " + 2 * PI * radius);     
	}
	// End of circle
}

public class TestCircle{     
	public static void main(String args[]) {  
		Circle c1 = new Circle(2.3);
		System.out.println("1st"); 
		System.out.println(c1.area());
		System.out.println("2nd"); 
		// accessing static method with class name         
		c1.getCircumference(2.3);   
		Circle c2 = new Circle(3.45); 
		System.out.println("3rd"); 
		System.out.println(c2.area());   
			
		// accessing static method with references is discouraged         
		c2.getCircumference (3.45);          
		/* 1. Make the area function as static and observe the output            
		 * 2. Remove the formal argument from getCircumference() method and observe the output            
		 * 3. Rename static to final and observe the error(s) and correct them */     
    }
}