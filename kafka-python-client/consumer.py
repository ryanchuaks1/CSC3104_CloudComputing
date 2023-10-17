from confluent_kafka import Producer, Consumer, KafkaError
from confluent_kafka.admin import AdminClient, NewTopic

KAFKA_SERVER = 'localhost:9092'
uuid = 'f1740855-6716-11ee-9b42-107b44'

def retrieve_location() -> str:
    consumer = Consumer({
        'bootstrap.servers': KAFKA_SERVER,
        'group.id': uuid,
        'auto.offset.reset': 'latest'
    })
    consumer.subscribe([uuid])
    while True:
        msg = consumer.poll(1.0) # poll with a timeout of 1s
        if msg is None:
            continue
        else:
            key = msg.key()
            val = msg.value()
            print(f"Message is: {key}, {val}")

retrieve_location()