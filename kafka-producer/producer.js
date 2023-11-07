class Kafka_Producer{
    constructor(client_id){
        const { Kafka } = require('kafkajs');
        this._kafka_conn = new Kafka({
            clientId: client_id,
            brokers: ['kafka-0.kafka-hs.cloud-computing.svc.cluster.local:9092']
        });
        this._producer = this._kafka_conn.producer();
    }

    async load_topics(dir_path){
        const fs = require('fs');
        const readline = require('readline');
        const path = require('path');
        const kafka_admin = require("./admin.js");
        const admin_client = new kafka_admin.Kafka_Admin('restoring-topic-admin');

        var success = true;

        try {
            const topic_files = fs.readdirSync(dir_path);

            for (const topic_file of topic_files){
                const file_path = path.join(dir_path, topic_file);
                const file_status = fs.statSync(file_path);

                if(!file_status.isDirectory()){
                    const topic_name = path.parse(topic_file).name;
                    var topic_res = await admin_client.add_new_topic(topic_name);

                    console.log("Result of adding topic: " + topic_res);

                    if(topic_res){
                        const file_stream = fs.createReadStream(file_path);
                        const read_line = readline.createInterface({
                            input: file_stream,
                            crlfDelay: Infinity
                        });

                        for await (const line of read_line){
                            const message = JSON.parse(line);
                            var msg_res = await this.update_location(topic_name, message.timestamp, message.location);

                            if(!msg_res){
                                success = false;
                            }
                        }
                    }

                    else{
                        success = false;
                    }
                }
            }
            return success;

        } catch (error) {
            console.error("Error from load_topics(): " + error.message);
            return false;
        }
    }

    async update_location(udid, timestamp = null, location){
        var res = null;
        try{
            await this._producer.connect();
            res = await this._producer.send({
                topic: udid,
                messages: [
                    {
                        key: timestamp == null ? String(new Date().getTime()) : timestamp,
                        value: location
                    }
                ]
            });
            console.log("Result of sending location to kafka: " + (res != null));
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

