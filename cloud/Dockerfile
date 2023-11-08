FROM python:3.12

RUN apt update
RUN apt install build-essential -y

# ADD https://github.com/vishnubob/wait-for-it/raw/master/wait-for-it.sh /wait-for-it.sh
# RUN chmod +x /wait-for-it.sh

WORKDIR /server

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .
RUN make

# ENTRYPOINT ["/wait-for-it.sh", "mariadb:3306", "-t", "100", "--", "python", "server.py"]
ENTRYPOINT ["python", "server.py"]
