FROM node:18

#Create app directory
WORKDIR /usr/src/app

#Copies the package.json fle into the application image
COPY package.json ./

RUN npm install
#For production,
#RUN npm ci --omit=dev

#bundle app source
COPY . .

EXPOSE 8080