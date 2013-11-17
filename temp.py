for i in xrange(10):
	n = int(raw_input(),2)
	n = str(hex(n)).upper()[2:]
	print "memory("+str(i)+") <= X\""+str(n)+"\";" 