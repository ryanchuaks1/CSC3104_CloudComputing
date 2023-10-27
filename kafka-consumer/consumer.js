class Kafka_Consumer{
    constructor(udid, client_id, group_id){
        this._udid = udid;
        const { Kafka } = require('kafkajs');
        this._kafka_conn = new Kafka({
            clientId: client_id,
            brokers: ['kafka:9092']
        })
        this._consumer = this._kafka_conn.consumer({
            groupId: group_id
        })
    }

    async subscribe_and_listen(){
        try{
            await this._consumer.connect();
            await this._consumer.subscribe({
                topic: this._udid,
                fromBeginning: false
            });
    
            await this._consumer.run({
                eachMessage: async({ topic, partition, message }) => {
                    this.return_location(topic, partition, message);
                }
            })
        }
        catch(error){
            console.error("Error: " + error.message);
        }
        finally{
            await this._consumer.disconnect();
        }

    }

    return_location(topic, partition, message){
        console.log({
            key: message.key.toString(),
            value: message.value.toString(),
        })
    }
}

module.exports = { Kafka_Consumer };

//function subscribe(udid, )

//const udid = "f1740855-6716-11ee-9b42-107b44"

// const { Kafka } = require('kafkajs');

// const kafka = new Kafka({
//     clientId: 'my-app',
//     brokers: ['kafka:9092'],
// });

// const consumer = kafka.consumer({
//     groupId: 'my-group'
// });

// const run = async () => {
//     await consumer.connect();
//     await consumer.subscribe({
//         topic: udid,
//         fromBeginning: true
//     });

//     await consumer.run({
//         eachMessage: async ({ topic, partition, message }) => {
//             console.log({
//                 key: message.key.toString(),
//                 value: message.value.toString(),
//             })
//         },
//     });
// }

// console.log("Hello, Consumer!");

// run().catch(console.error);