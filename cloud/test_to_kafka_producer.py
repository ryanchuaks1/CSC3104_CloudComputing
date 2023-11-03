import logging, time
import kafkaProducer as kp

def run():
    # NOTE(gRPC Python Team): .close() is possible on a channel and should be
    # used in circumstances in which the with statement does not fit the needs
    # of the code.
    udid = "f1740855-6716-11ee-9b42-107b44"
    location = "1.377476301551542, 103.84873335110395"

    kafka_producer = kp.KafkaProducer('producer-service:50052')

    added_topic = kafka_producer.addNewTopic(udid)
    print(f"Added New Topic: {added_topic}")

    if added_topic:
        for i in range(10):
            published = kafka_producer.publishLocationToKafka(udid, location)
            print(f"Location Published: {published}")

            time.sleep(5)
    else:
        print("Failed to add a topic to Kafka Server. Topic ID: " + added_topic.udid)

if __name__ == '__main__':
    logging.basicConfig()
    run()