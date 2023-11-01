class Kafka_Admin{
    constructor(client_id){
        const { Kafka } = require('kafkajs');
        this._kafka_conn = new Kafka({
            clientId: client_id,
            brokers: ['kafka:9092']
        })
        this._admin = this._kafka_conn.admin();
    }

    async check_topic(udid){
        var topic_exist = false;
        try{
            await this._admin.connect();
            const topics = await this._admin.listTopics();
            
            console.log("List of topics: " + topics);
            if(topics.includes(udid)){
                topic_exist = true;
            }
            await this._admin.disconnect();
        }
        catch(error){
            console.error("Error from check_topic: " + error.message);
            await this._admin.disconnect();
        }

        return topic_exist;
    }

    async add_new_topic(udid){
        try{
            await this._admin.connect();
            await this._admin.createTopics({
                validateOnly: false,
                waitForLeaders: true,
                timeout: 5000,
                topics: [{
                    topic: udid
                }],
            });
        }
        catch(error){
            console.error("Error from add_new_topic: " + error.message);
        }
        finally{
            await this._admin.disconnect();
        }
    }
}

module.exports = { Kafka_Admin };

// async function main(){
//     const udid = "f1740855-6716-11ee-9b42-107b44";
//     kafka_admin = new Kafka_Admin('kafka-admin');
    
//     await kafka_admin.add_new_topic(udid);

//     setTimeout(async () => {
//         var topic_exist = await kafka_admin.check_topic(udid);
    
//         if(topic_exist){
//             console.log("The topic exists!");
//         }
//         else{
//             console.log("The topic does not exist!");
//         }
//     }, 5000);
// }

// main();

// const udid = "f1740855-6716-11ee-9b42-107b44"

// const { Kafka } = require('kafkajs');

// const kafka = new Kafka({
//     clientId: 'my-app',
//     brokers: ['kafka:9092'],
// });

// const admin = kafka.admin();

// const run = async () => {
//     await admin.connect();
//     await admin.createTopics({
//         validateOnly: false,
//         waitForLeaders: false,
//         timeout: 10000,
//         topics: [{
//             topic: udid
//         }],
//     });
//     console.log("Successfully created topic");
//     await admin.disconnect();
// }

// run().catch(console.error);