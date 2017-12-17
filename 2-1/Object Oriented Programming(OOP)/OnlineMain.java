package test;

import java.util.Random;
import java.awt.*;

import javax.swing.*;

import java.awt.event.*;

class QuadraticEquation
{
private		int	quadNo;			// Quadratic Equation NO
private 	int 	a;			// A Field
private 	int 	b;			// B Field	
private 	int 	c;			// C Field
private 	boolean isSolved;		// Represents whether Roots have been computed or not
private		boolean	isRootsPossible;	// Represents whether Roots are possible or not
private	static	int	noofobjectsCreated = 0;	// Keeps up the count of the no of instances of this class created so far
private		double	root1;			// First 	Root
private		double	root2;			// Second 	Root

	QuadraticEquation(int a, int b, int c)
	{
		this.a	=	a;
		this.b	=	b;
		this.c	=	c;
		isSolved=	false;
		noofobjectsCreated++;
		quadNo	=	noofobjectsCreated;
	}

	public synchronized void computeRoots()
	{
		if( b*b - 4*a*c < 0) 
		{
			isRootsPossible = false;
			root1 = root2 = Double.NEGATIVE_INFINITY; 
			isSolved = true;
			return;
		}
		double disc	=	Math.sqrt(b*b - 4*a*c);
		root1 		= 	(-b+disc)/(2*a);
		root2 		= 	(-b-disc)/(2*a);
		isRootsPossible = 	true;
		isSolved 	= 	true;
		return;
	}
	public synchronized String toString()
	{
		return "Quadratic Equation No:="+quadNo+"A:= "+a+"B:= "+b+"C:= "+c+"Root 1:="+root1+"Root 2:="+root2;
	}
	public synchronized boolean getisSolved()
	{
		return isSolved;
	}
	public synchronized	int getNoofObjects()
	{
		return noofobjectsCreated;
	}
}// End of class QuadraticEquation

class QuadraticEquationQueue
{
private QuadraticEquation[]	quadQueue	=	new QuadraticEquation[10]; // queue with capacity 10
private	int	tail;	// tail value
private	int	head;	// head value
private	int	size;	// size field
	QuadraticEquationQueue()
	{
		head = tail = size =0;
	}
	public synchronized QuadraticEquation remove() throws InterruptedException
	{
		while(size == 0) wait();
		QuadraticEquation quad = quadQueue[head];
		head++;
		size--;
		if(head == quadQueue.length)
			head =0;
		notifyAll();
	return quad;
	}
	public synchronized void add(QuadraticEquation quad) throws InterruptedException
	{
		while(size == quadQueue.length) wait();
		quadQueue[tail] = quad;
		tail++;
		size++;
		if(tail == quadQueue.length)
		tail = 0;
		notifyAll();
	}
	public synchronized boolean isFull()
	{
	return size == quadQueue.length;
	}
	public synchronized boolean isEmpty()
	{
	return size == 0;
	}
}// End of class QuadraticEquationQueue

class OnlineMain
{
static Random 	r1 = new Random(20);			// Random instance to craete random integer
static boolean 	createThreadStarted	= false;	// indicates whether CreateThread has been started or not
static boolean 	createThreadStopped	= false;	// indicates whether CreateThread has been stopped or not
static boolean 	createThreadResumed	= false;	// indicates whether CreateThread has been resumed or not
static boolean 	computeThreadStarted	= false;	// indicates whether ComputeThread has been started or not
static boolean 	computeThreadStopped	= false;	// indicates whether ComputeThread has been stopped or not
static boolean 	computeThreadResumed	= false;	// indicates whether ComputeThread has been resumed or not

public static void main(String args[])
{
	JFrame frame = new JFrame("QuadraticFrame");			// Main JFrame
	Container c1 = frame.getContentPane();				// Container for Main Frame 
	c1.setLayout(new BoxLayout(c1,BoxLayout.X_AXIS));		// Setting Layout for Container c1
	
	// **************************************** CREATION OF LEFTSIDE PANEL ***************************
	// Creating First of the LeftSidePanel
	//JPanel firstRow	= new JPanel();
	JLabel label1	= new JLabel("QUEUE FULL");
	//firstRow.add(label1);
	
	// Creating START and STOP Buttons for the LeftSidePanel
	JButton b1 = new JButton("START");
	JButton b2 = new JButton("STOP");
	
	// Creating Labels for the LeftSidePanel
	JLabel L1	= new JLabel("A =");
	JLabel L2	= new JLabel("B =");
	JLabel L3	= new JLabel("C =");
	JLabel L4	= new JLabel("No of QuadraticEquations Created:"+0);
	
	// Creating Button Panel for START and STOP Buttons and adding Buttons to this Panel
	JPanel btnPanel = new JPanel();
	btnPanel.add(b1);
	btnPanel.add(b2);
	
	// Creating Three JTextFields for the LeftSidePanel
	final JTextField T1 	= new JTextField(6); 
	final JTextField T2 	= new JTextField(6); 
	final JTextField T3 	= new JTextField(6); 
	
	T1.setText("0");
	T2.setText("0");
	T3.setText("0");
	
	// Creating Panel for Label "A=" and its corresponding JTextField and adding JLabel and JTextField to it
	JPanel P1 = new JPanel();
	P1.add(L1);
	P1.add(T1);
	
	// Creating Panel for Label "B=" and its corresponding JTextField and adding JLabel and JTextField to it
	JPanel P2 = new JPanel();
	P2.add(L2);
	P2.add(T2);
	
	// Creating Panel for Label "C=" and its corresponding JTextField and adding JLabel and JTextField to it
	JPanel P3 = new JPanel();
	P3.add(L3);
	P3.add(T3);
	
	// A Separate Panel for Last Label of the left sidePanel
	JPanel P4 = new JPanel();
	P4.add(L4);
	
	// Creating a Final Panel and adding all the above panels to this
	JPanel leftPanel = new JPanel();
	leftPanel.setLayout(new BoxLayout(leftPanel,BoxLayout.Y_AXIS));
	leftPanel.add(label1);
	leftPanel.add(btnPanel);
	leftPanel.add(P1);
	leftPanel.add(P2);
	leftPanel.add(P3);
	leftPanel.add(P4);
	
	// **************************************** CREATION OF RIGHTSIDE PANEL *************************** 
	
	// Creating rightPanel and adding label "QUEUE EMPTY" to it
	JPanel rightPanel = new JPanel();
	rightPanel.setLayout(new BoxLayout(rightPanel,BoxLayout.Y_AXIS));
	JLabel L20 = new JLabel("QUEUE EMPTY");		// L20 Label is QUEUE EMPTY
	rightPanel.add(L20);
	
	// Creating and Adding Buttons for right side 
	JPanel P21 = new JPanel();			// P21 is Button Panel for right side
	JButton b3 = new JButton("START");
	JButton b4 = new JButton("STOP");
	P21.add(b3);
	P21.add(b4);
	
	rightPanel.add(P21);
	
	// Creating 10 JLabel references for Result Display Area for RightSide Panel
	JLabel[] resultLabels = new JLabel[10];
	for(int i=0;i<10;i++)
	resultLabels[i] = new JLabel();
	
	// Adding Labels of Result Display Area to rightPanel one by one 
	for(int i=0;i<10;i++)
	rightPanel.add(resultLabels[i]);
	
	// Creating Label "NO OF EQUATIONS SOLVED" and adding it into right Panel
	JLabel L21 = new JLabel("NO OF EQUATIONS SOLVED:"+0);
	rightPanel.add(L21);
	
	// Creating Three Counter Labels for compute Threads and adding it into right Panel
	JLabel L22 = new JLabel("By Thread 1:"+0);
	rightPanel.add(L22);
	
	JLabel L23 = new JLabel("By Thread 2:"+0);
	rightPanel.add(L23);
	
	JLabel L24 = new JLabel("By Thread 3:"+0);
	rightPanel.add(L24);
	
	// Finally Adding leftPanel and rightPanel to conatiner for Main Frame
	c1.add(leftPanel);
	c1.add(rightPanel);
	
	frame.setSize(400,600); 				// setting size of JFrame
	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 	// setting Default Close Operation
	frame.setVisible(true); 				// Showing Jframe
	
	
	// ***************** In main() method WRITE YOUR CODE FROM HERE *************************
	QuadraticEquationQueue QEQ = new QuadraticEquationQueue();
	CreateThread ct = new CreateThread(QEQ,T1,T2,T3,label1,L4,L20);
	RandomThread r = new RandomThread(T1,T2,T3);
	ComputeThread cot1 = new ComputeThread(1,QEQ,L21,L22,resultLabels,L20,label1);
	ComputeThread cot2 = new ComputeThread(2,QEQ,L21,L23,resultLabels,L20,label1);
	ComputeThread cot3 = new ComputeThread(3,QEQ,L21,L24,resultLabels,L20,label1);
	
	b1.addActionListener(new ActionListener() {

		@Override
		public void actionPerformed(ActionEvent arg0) {
			// TODO Auto-generated method stub
			
			if (createThreadStarted	== false){
				System.out.println("here start");
				ct.start();
				r.start();
				ct.myresume();
				r.myresume();
				createThreadStarted = true;
			}
			else if (createThreadStarted == true && createThreadStopped	== true ){
				createThreadResumed=true;
				ct.myresume();
				r.myresume();
			}
			else {}
		}
		
	});
	
	b2.addActionListener(new ActionListener() {

		@Override
		public void actionPerformed(ActionEvent arg0) {
			// TODO Auto-generated method stub
			if (createThreadStarted	== false){}
			else if (createThreadStarted == true || createThreadResumed==true){
				ct.mysuspend();
				r.mysuspend();
				createThreadStopped = true;
			}
			else {}
		}
		
	});

	
	b3.addActionListener(new ActionListener() {

		@Override
		public void actionPerformed(ActionEvent arg0) {
			// TODO Auto-generated method stub
			
			if (computeThreadStarted	== false){
				System.out.println("here compute start");
				cot1.start();
				cot2.start();
				cot3.start();
				cot1.myresume();
				cot2.myresume();
				cot3.myresume();
				computeThreadStarted = true;
			}
			else if (computeThreadStarted == true && computeThreadStopped	== true ){
				computeThreadResumed=true;
				cot1.myresume();
				cot2.myresume();
				cot3.myresume();
			}
			else {}
		}
		
	});
	b4.addActionListener(new ActionListener() {

		@Override
		public void actionPerformed(ActionEvent arg0) {
			// TODO Auto-generated method stub
			if (computeThreadStarted	== false){}
			else if (computeThreadStarted == true || computeThreadResumed==true){
				cot1.mysuspend();
				cot2.mysuspend();
				cot3.mysuspend();
				computeThreadStopped = true;
			}
			else {}
		}
		
	});

} // End of main() method
} // End of class OnlineMain

class CreateThread extends Thread
{
	private boolean suspendFlag ;
	private JTextField T1;
	private JTextField T2;
	private JTextField T3;
	private QuadraticEquation QE;
	private QuadraticEquationQueue QEQ;
	private JLabel label;
	private JLabel label2;
	private int count=0;
	private JLabel label3;
	
	
	CreateThread(QuadraticEquationQueue QEQ ,JTextField t1, JTextField t2, JTextField t3,JLabel label, JLabel label2,JLabel label3){
		this.suspendFlag = true;
		this.QEQ=QEQ;
		this.T1= t1;
		this.T2 = t2;
		this.T3 =t3;
		this.label=label;
		this.label2 =label2;
		this.label3=label3;
	}
	
	public void run(){
		try {
			while(true){
				synchronized(this){
					while(!suspendFlag){
						notifyAll();
						this.label3.setForeground(Color.BLACK);
					
						if (T1.getText() == "" || T2.getText() == "" || T3.getText()=="" ){}
						else {
							try{
								String a1 = T1.getText();
								//System.out.println("taking a1");
								//System.out.println(a1);
								String b1 = T2.getText();
								String c1 = T3.getText();
								int a =Integer.parseInt(a1);
								int b =Integer.parseInt(b1);
								int c =Integer.parseInt(c1);
								if (a==0){}
								else {
									QuadraticEquation q = new QuadraticEquation(a,b,c);
									
									QEQ.add(q);
									count++;
									notifyAll();
									Thread.sleep(150);
								}
							}
							catch (Exception NumberFormatException){}
							
						}
						this.label2.setText("No of QuadraticEquations Created:" + count);
						while (QEQ.isFull()){
							this.label.setForeground(Color.GREEN);
							wait();
						}
						this.label.setBackground(Color.BLACK);
					}
					 wait() ; 
				}
			
			}
		}catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public synchronized void myresume(){
		this.suspendFlag=false;
		notify();
	}
	public void mysuspend(){
		this.suspendFlag=true;
	}
	
// Write the code for this class

}// End of CreateThread class


class ComputeThread extends Thread
{

// Write the code for this class
	private boolean suspendFlag ;
	private QuadraticEquationQueue QEQ;
	private JLabel labeltotal;
	private JLabel labelown;
	private JLabel[] labelchange;
	private int count=0;
	private static int totalcount=0;
	private int id;
	private JLabel labelcolour;
	private JLabel labelcolour2;
	
	
	ComputeThread(int id,QuadraticEquationQueue QEQ,JLabel label1,JLabel label2, JLabel[] label3, JLabel label4,JLabel label5){
		this.suspendFlag = true;
		this.labelchange=label3;
		this.labelown= label2;
		this.labeltotal=label1;
		this.QEQ=QEQ;
		this.id = id;
		this.labelcolour =label4;
		this.labelcolour2= label5;
	}
	
	public void run(){
		try {
			while(true){
				synchronized(this){
					while(!suspendFlag){ 
						//System.out.println("here ca");
						notifyAll();
						this.labelcolour2.setForeground(Color.BLACK);
						QuadraticEquation q = this.QEQ.remove();
						q.computeRoots();
						this.count ++;
						totalcount++;
						labeltotal.setText("NO OF EQUATIONS SOLVED:" + totalcount);
						labelown.setText("By Thread "+ this.id +":" + this.count);
						int b = totalcount % 10;
						if (b==0){
							labelchange[9].setText(q.toString());
						}
						else {
						labelchange[b-1].setText(q.toString());
						}
						while (QEQ.isEmpty()){
							this.labelcolour.setForeground(Color.GREEN);
							//wait();
						}
						this.labelcolour.setBackground(Color.BLACK);
						Thread.sleep(150);
					}
					while (suspendFlag){
						notifyAll();
					wait();}
				}
			
			}
		}catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public synchronized void myresume(){
		this.suspendFlag=false;
		this.notify();
	}
	public  void mysuspend(){
		this.suspendFlag = true;
	}

}// End of CreateThread class


class RandomThread extends Thread
{
	public int a;
	public int b;
	public int c;
	private JTextField T1;
	private JTextField T2;
	private JTextField T3;
	private boolean suspendFlag;
	RandomThread(JTextField t1, JTextField t2, JTextField t3){
		this.T1 =t1;
		this.T2 =t2;
		this.T3 =t3;
		this.suspendFlag=true;
	}
	public void run(){
		try {
			while (true){
				synchronized(this){
					while (!suspendFlag){ 
						Random random = new Random();
						//System.out.println("creating a1");
						a= random.nextInt(20);
						b= random.nextInt(20);
						c= random.nextInt(20);
						T1.setText(Integer.toString(a));
						T2.setText(Integer.toString(b));
						T3.setText(Integer.toString(c));
						Thread.sleep(100);
					}
					this.wait();
				}
			}
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void mysuspend(){
		suspendFlag=true;
	}
	public synchronized void myresume(){
		suspendFlag=false;
		this.notify();
	}
}