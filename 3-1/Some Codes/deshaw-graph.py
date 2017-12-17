
def cou(a,b):
	count =0
	c = []
	for i in a:
		if e[a]==False :
			count =count +1
			c.append(a)
	return count ,c

def find(e):
	for i in e:
		if e[i]==False:
			return i

def call(s):
	d=dict()
	e=dict()
	for i in s:
		a,b = i.split('-')
		if a in d :
			d[a].append(b)
		else :
			d[a] = [b]
			e[a] = False
		if b in d:
			d[b].append(a)
		else :
			d[b] = [a]
			e[b] = False
	print (d)
	print (e)
	max =0 
	while(len(d)!=0):
		f = list(d.keys())[0]
		print ("keys----" + f)
		if e[f]==False:
			l = d[f]
			e[f] = True
			count = 1 
			while(len(l)!=0):
				qw = l.pop()
				if e[qw] ==False:
					count =count +1
					e[qw] = True
					l.extend(d[qw])
					del d[qw]
			if (count > max):
				max = count
		del d[f]
	print (max)
	
	#count,c = cou(d[f],e)



	
if __name__ == "__main__" :
	n = int(input().strip())
	a=[]
	for i in range(0,n):
		a.append(str(input().strip()))

	call(a)