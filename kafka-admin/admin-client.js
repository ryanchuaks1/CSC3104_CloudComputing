const uuid = "f1740855-6716-11ee-9b42-107b44"

const { Kafka } = require('kafkajs');

const kafka = new Kafka({
    clientId: 'my-app',
    brokers: ['kafka:9092'],
});

const admin = kafka.admin();

const run = async () => {
    await admin.connect();
    await admin.createTopics({
        validateOnly: false,
        waitForLeaders: false,
        timeout: 10000,
        topics: [{
            topic: uuid
        }],
    });
    console.log("Successfully created topic");
    await admin.disconnect();
}

run().catch(console.error);