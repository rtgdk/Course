package lab6;

public class BinaryClass {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		BinaryInterface complement = new OneComplement();
		complement.toBinary(16);
		BinaryInterface complement2 = new TwoComplement();
		complement2.toBinary(-16);
	}

}
