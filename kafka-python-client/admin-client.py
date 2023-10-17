from confluent_kafka import Producer, Consumer, KafkaError
from confluent_kafka.admin import AdminClient, NewTopic

KAFKA_SERVER = 'localhost:9092'
uuid = 'f1740855-6716-11ee-9b42-107b44'

def create_user_topic() -> bool:
    # Pre-requisites: User is already signed in (UUID not NULL)
    # Create an AdminClient instance
    admin_client = AdminClient({
        'bootstrap.servers': KAFKA_SERVER
    })
    # # Define the topic name based on device information
    # topic_name = f'device_{UUID}'
    # Create a new topic
    new_topic = NewTopic(uuid, num_partitions=1, replication_factor=2)
    try:
        admin_client.create_topics([new_topic])
        return True
    except KafkaError as e:
        print("Error: ", e)
        return False
    
create_user_topic()