package lab6;

public class Out {
	Inner i1 = new Inner();
	private String s = "Outer String";
	
	void getS(){ System.out.println(s);}
	
	void getInnerS(){ System.out.println(i1.s);}
	
	class Inner {
		private String s = "Inner String";
		void getS(){
			System.out.println(s);
		}
		void getOutS(){
			System.out.println(Out.this.s);
		}
	}
	public static void main(String[] args){
		Out o = new Out();
		Out.Inner oi = o.new Inner();
		o.getS();
		oi.getS();
		o.getInnerS();
		oi.getOutS();
	}
}
