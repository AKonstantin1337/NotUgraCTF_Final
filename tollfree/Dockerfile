FROM alpine:latest

RUN apk add --update asterisk perl perl-utils make

EXPOSE 5060/udp 5060/tcp 10000-10999/udp

RUN PERL_MM_USE_DEFAULT=1 cpan Asterisk::AGI

VOLUME /etc/asterisk

RUN ln -s /etc/asterisk/record.pl /var/lib/asterisk/agi-bin/record.pl
RUN ln -s /etc/asterisk/last.pl /var/lib/asterisk/agi-bin/last.pl
RUN ln -s /etc/asterisk/sounds /var/lib/asterisk/sounds/sounds

CMD /usr/sbin/asterisk -T -p -vvvdddf
