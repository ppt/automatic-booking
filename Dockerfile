FROM fprieur/docker-casperjs
RUN apt-get update
RUN apt-get install nodejs -y
RUN apt-get install npm -y
RUN npm install -g coffee-script
RUN npm install moment
COPY booking.coffee booking-seq.coffee /home/
RUN rm phantomjs-1.9.7-linux-x86_64.tar.bz2