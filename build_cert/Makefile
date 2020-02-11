main:
	perl mk-ca-bundle.pl
install: ca-bundle.crt
	mv ca-bundle.crt ../lib/cert/chain.pem
clean:
	rm certdata.txt
