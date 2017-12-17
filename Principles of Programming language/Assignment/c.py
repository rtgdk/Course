from sys import argv
l1 = []
l2 = []
with open(str(argv[1])) as f1, open(str(argv[2])) as f2:
    l1 = list(line.strip().split() for line in f1)
    l2 = list(line.strip().split() for line in f2)
    if (len(l1)!=len(l2)):
        print("Length not same")
    else :
        for i in range(0,len(l1)):
            if (len(l1[i])!=len(l2[i])):
                print(" Line "+ str(i+1) + " length not same")
            else :
                for j in range(0, len(l1[i])):
                    if (len(l1[i][j]) != len(l2[i][j])):
                        print(" Line " + str(i + 1) + " charcter " + str(j+1) +  " not same ")
                        print (" Got " + str(l1[i][j]))
                        print ("expected " + str(l2[i][j]))
    print("same")
"""

l1 = []
with open("test3.txt") as f1:
	l1 = list(line.strip().split() for line in f1)
	count =0
	for i in range(0,len(l1[0])):
		if "((" in l1[0][i]:
			count= count +1
			if (count == 6):
				print(str(l1[0][i]) +"---" + str(l1[0][i+1]) + "---"+ str(l1[0][i+2])+"---"+ str(l1[0][i+3]))
				break;
	print (count)
"""