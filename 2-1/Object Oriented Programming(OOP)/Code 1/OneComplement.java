package lab6;

import java.util.*;

public class OneComplement implements BinaryInterface {
	ArrayList<Integer> arr = new ArrayList<Integer>();

	public OneComplement() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void toBinary(int N) {
		// TODO Auto-generated method stub

		int bin = Integer.parseInt(Integer.toBinaryString(N));
		
        System.out.println(bin);
		int x = 0;
		
		while (bin != 0) {
			if (x==0){
				arr.add(1);
			}
			else
				arr.add(0);
			bin = bin / 10;
			x = bin % 10;

		}
		
		int size = arr.size();
		for (int i = 0; i < size; i++) {
			System.out.println(arr.get(size - i -1));
		}

	}

}
