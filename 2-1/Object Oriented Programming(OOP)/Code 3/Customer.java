class Item
{
	private String itemName,itemNo;
	private int itemQuantity;
	private double itemPrice;
	
	public Item(String itemName,String itemNo,int itemQuantity,double itemPrice)
	{
		this.itemName=itemName;
		this.itemNo=itemNo;
		this.itemQuantity=itemQuantity;
		this.itemPrice=itemPrice;
	}
	
	public Item(String itemName,String itemNo,int itemQuantity)
	{
		this.itemName=itemName;
		this.itemNo=itemNo;
		this.itemQuantity=itemQuantity;
		this.itemPrice=500;
	}
	
	public Item(String itemName,String itemNo)
	{
		this.itemName=itemName;
		this.itemNo=itemNo;
		this.itemQuantity=1;
		this.itemPrice=500;
	}
	
	public Item(){}
	
	public String getItemName()
	{
		return itemName;
	}
	
	public String getitemNo()
	{
		return itemNo;
	}
	
	public int getItemQuantity()
	{
		return itemQuantity;
	}
	
	public double getItemPrice()
	{
		return itemPrice;
	}
	
	public void setItemName(String itemName)
	{
		this.itemName=itemName;
	}
	
	public void setItemNo(String itemNo)
	{
		this.itemNo=itemNo;
	}

	public void setItemQuantity(int itemQuantity)
	{
		this.itemQuantity=itemQuantity;
	}

	public void setItemPrice(double itemPrice)
	{
		this.itemPrice=itemPrice;
	}
}

class Customer 
{
	private String name,idNo;
	private double balance;
	private Item item;
	
	public Customer(String name,String idNo,double balance)
	{
		this.name=name;
		this.idNo=idNo;
		this.balance=balance;
	}
	
	public Customer(String name,String idNo)
	{
		this.name=name;
		this.idNo=idNo;
		this.balance=5000;
	}
	
	public String getName()
	{
		return name;
	}
	
	public String getidNo()
	{
		return idNo;
	}
	
	public double getBalance()
	{
		return balance;
	}
	
	public void setName(String name)
	{
		this.name=name;
	}

	public void setidNo(String idNo)
	{
		this.idNo=idNo;
	}
	
/*	public void prnt()
	{
		System.out.printf("\nItem Name : "+item.getItemName()+"\nItem No : "+idNo+"\nItem Quantity : "+item.getItemQuantity()+"\nItem Price : "+item.getItemPrice()+"\nBalance : "+balance);
	}*/
	
	public void buyItem(Item item)
	{
		System.out.printf("\nItem Name : "+item.getItemName()+"\nItem No : "+idNo+"\nItem Quantity : "+item.getItemQuantity()+"\nItem Price : "+item.getItemPrice()+"\nBalance : "+balance);
		double price=(item.getItemPrice()*item.getItemQuantity());
		if(item.getItemQuantity()>=1 && balance>=price)
		{
			balance=balance-price;
		}
		else
		if(balance<price)
		{
			System.out.println("Insufficient Balance");
		}
		else
		{
			System.out.println("Invalid Order");
		}
		System.out.println();
		System.out.printf("\nItem Name : "+item.getItemName()+"\nItem No : "+idNo+"\nItem Quantity : "+item.getItemQuantity()+"\nItem Price : "+item.getItemPrice()+"\nBalance : "+balance);
	}
	

}

class Test
{
	public static void main(String arg[])
	{
		Customer c=new Customer("Chinmay Sanjay Deshmukh","2014B5A7770P",8500);
		System.out.println(c.getName());
		System.out.println();
		Item i1=new Item("Mac","1279P34",6);
		c.buyItem(i1);
		System.out.println();
		Item i2=new Item("PS2","1239G34",2);
		c.buyItem(i2);
		
		
	}
}
