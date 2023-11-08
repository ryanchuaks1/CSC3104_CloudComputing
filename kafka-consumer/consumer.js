const { resolve } = require('path');
const { promiseHooks } = require('v8');

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

    sleep(ms){
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async export_log(volume_path){
        const kafka_admin = require("./admin.js");
        const fs = require('fs');
        const admin_client = new kafka_admin.Kafka_Admin('export-topic-admin');
        var success = true;
        
        try {
            const topics = await admin_client.list_topics();

            await this.sleep(1000);

            for (const topic of topics) {
                if(topic === "__consumer_offsets"){
                    continue;
                }
                
                const write_promise = new Promise(async(resolve) => {
                    var count = 0;
                    const topic_offset = await admin_client.get_latest_message(topic);
                    await this._consumer.connect();
                    await this._consumer.subscribe({
                        topic: topic,
                        fromBeginning: true
                    });
    
                    const file_path = `${volume_path}/${topic}.txt`;
                    const write_stream = fs.createWriteStream(file_path, { flags: 'w' , encoding: 'utf-8' });
    
                    if(topic_offset != null){
    
                        this._consumer.run({
                            eachMessage: async({ topic, partition, message }) => {
                                const data = {
                                    timestamp: message.key.toString(),
                                    location: message.value.toString()
                                }
        
                                console.log(data);
        
                                write_stream.write(JSON.stringify(data));
                                console.log("done writing");

                                count++;
                                if(count == 1){
                                    write_stream.end();
                                    resolve();
                                    return;
                                }
                            
                            }
                        });
                        this._consumer.seek({ topic: topic, partition: topic_offset.partition, offset: topic_offset.offset - 1 });
                    }
                    else{
                        success = false;
                        resolve();
                    }

                });

                await write_promise;
                await this._consumer.disconnect();

                console.log("finish");

                if(!success){
                    break;
                }

                await this.sleep(1000);

            };

        } catch (error) {
            console.error("Error from export_log(): " + error.message);
            success = false;
            await this._consumer.disconnect();
        }

        return success;
    }

    async subscribe_and_listen(udid, callback){
        const kafka_admin = require("./admin.js");
        const admin_client = new kafka_admin.Kafka_Admin('subscribe-admin');
        var success = true;

        try{
            const topic_offset = await admin_client.get_latest_message(udid);

            await this._consumer.connect();
            await this._consumer.subscribe({
                topic: udid,
                fromBeginning: true,
            });

            if(topic_offset != null){
                this._consumer.run({
                    eachMessage: async({ topic, partition, message }) => {
                        callback({
                            udid: topic,
                            timestamp: message.key.toString(),
                            location: message.value.toString()
                        });
                    }
                })
    
                this._consumer.seek({ topic: udid, partition: topic_offset.partition, offset: topic_offset.offset - 1 });
            }

            else{
                await this._consumer.run({
                    eachMessage: async({ topic, partition, message }) => {
    
                        callback({
                            udid: topic,
                            timestamp: message.key.toString(),
                            location: message.value.toString()
                        });
    
                        // count++;
                        // if(count === 5){
                        //     await this._consumer.disconnect();
                        //     return;
                        // }
                    }
                })
            }
        }
        catch(error){
            console.error("Error from subscribe_and_listen(): " + error.message);
            success = false;
            await this._consumer.disconnect();
        }

        return success;

    }
}

module.exports = { Kafka_Consumer };