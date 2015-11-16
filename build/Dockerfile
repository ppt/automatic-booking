FROM fprieur/docker-casperjs

# set timezone to Bangkok
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install node, npm, coffeescript, moment
RUN apt-get update && apt-get install nodejs -y && apt-get install npm -y && npm install -g coffee-script && npm install moment

# copy source code
COPY booking.coffee booking-seq.coffee /home/
