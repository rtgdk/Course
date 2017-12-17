import java.io.*;

public class Example1 
{
 public static void main(String arg[])throws IOException
 {
  BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
  System.out.print("Enter your First Name : ");
  String name=br.readLine();
  System.out.println("Your name is : "+name);
 }
}
