FROM debian:9

RUN env
RUN apt-get update
RUN apt-get install -y python-virtualenv git-core qrencode
RUN git clone https://github.com/chubin/qrenco.de
RUN cd qrenco.de && virtualenv ve/                                                                              
RUN cd qrenco.de && ve/bin/pip install -r requirements.txt 

EXPOSE 8003

CMD cd  qrenco.de && ve/bin/python bin/srv.py
