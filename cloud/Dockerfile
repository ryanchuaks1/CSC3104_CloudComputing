FROM python:3.12

RUN apt update
RUN apt install build-essential -y

ADD https://github.com/vishnubob/wait-for-it/raw/master/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

WORKDIR /server

COPY . .
RUN pip install grpcio_tools-1.59.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
RUN pip install -r requirements.txt
RUN make

ENTRYPOINT ["/wait-for-it.sh", "mongodb:27017", "-t", "100", "--", "python", "server.py"]
