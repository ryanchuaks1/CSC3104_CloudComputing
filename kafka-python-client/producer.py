from confluent_kafka import Producer, Consumer, KafkaError
from confluent_kafka.admin import AdminClient, NewTopic

KAFKA_SERVER = 'localhost:9092'
uuid = 'f1740855-6716-11ee-9b42-107b44'

def update_location(device_udid, location):
    # Pre-requisites: User is already signed in (UUID not NULL)
    # 1. Connect to DB
    # 2. 
    producer = Producer({
        'bootstrap.servers': KAFKA_SERVER,
        'client.id': uuid
    })
    #device_id = get_device_id(USER_ID, device_udid)
    producer.produce(uuid, key=device_udid, value=location)
    producer.flush()


update_location('12345', '1.377476301551542, 103.84873335110395')