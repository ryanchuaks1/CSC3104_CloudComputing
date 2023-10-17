const uuid = "f1740855-6716-11ee-9b42-107b44"

const { Kafka } = require('kafkajs');

const kafka = new Kafka({
    clientId: 'my-app',
    brokers: ['kafka:9092'],
});

const consumer = kafka.consumer({
    groupId: 'my-group'
});

const run = async () => {
    await consumer.connect();
    await consumer.subscribe({
        topic: uuid,
        fromBeginning: true
    });

    await consumer.run({
        eachMessage: async ({ topic, partition, message }) => {
            console.log({
                key: message.key.toString(),
                value: message.value.toString(),
            })
        },
    });

    console.log("hello");
}

console.log("Hello, Consumer!");

run().catch(console.error);