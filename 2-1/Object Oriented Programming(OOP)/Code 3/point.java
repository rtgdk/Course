
public class point {
      private double x;
      private double y;
      point(double x, double y) { this.x=x; this.y=y; } 
      public double getX() { return this.x; }  
      public double getY() { return this.y; } 
      public void setX(double x) { this.x = x; } 
      public void setY(double y) { this.y = y; }
      public String toString() { return "X="+x+" Y ="+y; }
      public static void changestate(point other ){
    	  other.setX(-20);
    	  other.setY(-30);
      }
      public static void changeReference(point other){
    	   other = new point(-20,-20);
      }
      public static void main(String args[]){ 
    	    point p1 = new point(10,20);
    	    System.out.println(p1);
    	    point.changestate(p1); 
    	    System.out.println(p1);
    	    point p2 = new point(100,200);
    	    System.out.println(p2);
    	    point.changeReference(p2); 
    	    System.out.println(p2);   	       
      }
}
