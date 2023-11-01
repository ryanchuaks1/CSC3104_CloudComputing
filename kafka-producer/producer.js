class Kafka_Producer{
    constructor(udid, client_id){
        this._udid = udid;
        const { Kafka } = require('kafkajs');
        this._kafka_conn = new Kafka({
            clientId: client_id,
            brokers: ['kafka:9092']
        })
        this._producer = this._kafka_conn.producer();
    }

    async load_topics(file_path){
        
    }

    async update_location(location){
        var res = false;
        try{
            await this._producer.connect();
            res = await this._producer.send({
                topic: this._udid,
                messages: [
                    {
                        key: String(new Date().getTime()),
                        value: location
                    }
                ]
            });
            console.log("Result of update_location: " + res);
        }
        catch(error){
            console.error("Error from update_location: " + error.message);
        }
        finally{
            await this._producer.disconnect();
        }
        return res;
    }
}

module.exports = { Kafka_Producer };

// kafka_producer = new Kafka_Producer("f1740855-6716-11ee-9b42-107b44", "kafka-producer");

// const interval = 5000; // milliseconds

// setInterval(() => {
//     kafka_producer.update_location('1.377476301551542, 103.84873335110395');
// }, interval)

// const uuid = "f1740855-6716-11ee-9b42-107b44"

// const { Kafka } = require('kafkajs');

// const kafka = new Kafka({
//     clientId: 'my-app',
//     brokers: ['kafka:9092'],
// });

// const producer = kafka.producer();

// const run = async () => {
//     await producer.connect();
//     await producer.send({
//         topic: uuid,
//         messages: [
//             {
//                 key: 'device_1',
//                 value: '1.377476301551542, 103.84873335110395'
//             }
//         ]
//     });

//     await producer.disconnect();
// }

// const interval = 5000; // milliseconds

// setInterval(() => {
//     run().catch(console.error);
// }, interval)

// console.log("Hello, Producer!");

