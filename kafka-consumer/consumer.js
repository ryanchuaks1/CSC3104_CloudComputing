class Kafka_Consumer{
    constructor(client_id, group_id){
        const { Kafka } = require('kafkajs');
        this._kafka_conn = new Kafka({
            clientId: client_id,
            brokers: ['kafka:9092']
        });
        this._consumer = this._kafka_conn.consumer({
            groupId: group_id
        });
    }

    async export_log(volume_path){
        const kafka_admin = require("./admin.js");
        const fs = require('fs');
        const admin_client = new kafka_admin.Kafka_Admin('exporting-topic-admin');
        var count = 0;
        var success = true;
        
        try {
            const topics = await admin_client.list_topics();

            //console.log("1st topic = " + topics[0]);

            for (const topic of topics) {
                await this._consumer.connect();
                await this._consumer.subscribe({
                    topic: topic,
                    fromBeginning: true
                });

                const file_path = `${volume_path}/${topic}.txt`;
                console.log(file_path);
                const write_stream = fs.createWriteStream(file_path, { flags: 'a' , encoding: 'utf-8' });

                await this._consumer.run({
                    eachMessage: async({ topic, partition, message }) => {
                        const data = {
                            timestamp: message.key.toString(),
                            location: message.value.toString()
                        }

                        console.log(data);

                        write_stream.write(JSON.stringify(data) + "\n");
                        
                        count++;
                        if(count === 5){
                            write_stream.end();
                            await this._consumer.disconnect();
                            return;
                        }
                    }
                });

                break;
            };

        } catch (error) {
            console.error("Error from export_log(): " + error.message);
            success = false;
            await this._consumer.disconnect();
        }

        return success;
    }

    async subscribe_and_listen(udid){
        var success = true;
        try{
            await this._consumer.connect();
            await this._consumer.subscribe({
                topic: udid,
                fromBeginning: true
            });
    
            await this._consumer.run({
                eachMessage: async({ topic, partition, message }) => {
                    const data = {
                        timestamp: message.key.toString(),
                        location: message.value.toString()
                    }

                    console.log(data);
                    //this.return_location(topic, partition, message);

                    // count++;
                    // if(count === 5){
                    //     await this._consumer.disconnect();
                    //     return;
                    // }
                }
            })
        }
        catch(error){
            console.error("Error from subscribe_and_listen(): " + error.message);
            success = false;
            await this._consumer.disconnect();
        }

        return success;

    }

    // return_location(topic, partition, message){
    //     this._grpc_call.write({udid: this._grpc_call.request.udid, timestamp: message.key.toString(), location: message.value.toString()});
    //     console.log({
    //         key: message.key.toString(),
    //         value: message.value.toString(),
    //     });
    // }
}

module.exports = { Kafka_Consumer };