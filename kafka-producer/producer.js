const uuid = "f1740855-6716-11ee-9b42-107b44"

const { Kafka } = require('kafkajs');

const kafka = new Kafka({
    clientId: 'my-app',
    brokers: ['kafka:9092'],
});

const producer = kafka.producer();

const run = async () => {
    await producer.connect();
    await producer.send({
        topic: uuid,
        messages: [
            {
                key: 'device_1',
                value: '1.377476301551542, 103.84873335110395'
            }
        ]
    });

    await producer.disconnect();
}

const interval = 5000; // milliseconds

setInterval(() => {
    run().catch(console.error);
}, interval)

console.log("Hello, Producer!");

