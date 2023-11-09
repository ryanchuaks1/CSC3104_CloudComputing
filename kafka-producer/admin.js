class Kafka_Admin{
    constructor(client_id){
        const { Kafka } = require('kafkajs');
        this._kafka_conn = new Kafka({
            clientId: client_id,
            brokers: ['kafka-hs:9092']
        })
        this._admin = this._kafka_conn.admin();
    }

    async list_topics(){
        var topics = null;
        
        try {
            await this._admin.connect();
            topics = await this._admin.listTopics();
            console.log("Topics: " + topics);
        } catch (error) {
            console.error("Error from list_topics(): " + error.message);
        }
        finally{
            await this._admin.disconnect();
        }
        return topics;
    }

    async get_latest_message(topic){
        var latest_msg = null;
        try{
            await this._admin.connect();
            var partition_offsets = await this._admin.fetchTopicOffsets(topic);
            if(partition_offsets.length > 0){
                latest_msg = partition_offsets[0];
                console.log("Topic offset from admin: " + latest_msg.offset);
            }
        }
        catch(error){
            console.error("Error from get_latest_message(): " + error.message);
        }
        finally{
            await this._admin.disconnect();
        }

        return latest_msg;
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
        }
        catch(error){
            console.error("Error from check_topic(): " + error.message);
        }
        finally{
            await this._admin.disconnect();
        }
        return topic_exist;
    }

    async add_new_topic(udid){
        try{
            await this._admin.connect();
            var res = await this._admin.createTopics({
                validateOnly: false,
                waitForLeaders: true,
                timeout: 10000,
                topics: [{
                    topic: udid
                }],
            });

            console.log("Result: " + res);

            if(res){
                console.log("Successfully created topic: " + udid);
            }
            else{
                console.log("Failed to create topic: " + udid);
            }

        }
        catch(error){
            console.error("Error from add_new_topic(): " + error.message);
        }
        finally{
            await this._admin.disconnect();
        }
    }
}

module.exports = { Kafka_Admin };
