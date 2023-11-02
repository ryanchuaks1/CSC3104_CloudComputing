const PROTO_PATH = __dirname + '/kafka_consumer.proto';
const SERVER_SOCKET = "consumer-service:50051";
const VOLUME_PATH = __dirname + '/data';

//var parseArgs = require('minimist');
var grpc = require('@grpc/grpc-js');
var protoLoader = require('@grpc/proto-loader');
var kafka_consumer = require('./consumer.js');
const fs = require('fs');
var packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {
        keepCase: true,
        longs: String,
        enums: String,
        defaults: true,
        oneofs: true
    }
);

var kafka_consumer_proto = grpc.loadPackageDefinition(packageDefinition).kafka_consumer_grpc;

function Subscribe(call, callback){
    // const new_consumer = new kafka_consumer.Kafka_Consumer(call.request.udid, 'kafka-client', 'user_1', call);
    // new_consumer.subscribe_and_listen().catch(console.error);
    var count = 0;

    const { Kafka } = require('kafkajs');
    const kafka = new Kafka({
        clientId: 'kafka-client',
        brokers: ['kafka:9092'],
    });
    const consumer = kafka.consumer({
        groupId: 'user_1'
    });

    async function run(){
        try{
            await consumer.connect();
            await consumer.subscribe({
                topic: call.request.udid,
                fromBeginning: true
            });

            const file_path = `${VOLUME_PATH}/${call.request.udid}.txt`;
            const write_stream = fs.createWriteStream(file_path, { flags: 'a' , encoding: 'utf-8' });

            await consumer.run({
                eachMessage: async ({ topic, partition, message }) => {
                    call.write({udid: call.request.udid, timestamp: message.key.toString(), location: message.value.toString()});
                    console.log({
                        key: message.key.toString(),
                        value: message.value.toString(),
                    });

                    write_stream.write("timestamp: " + message.key.toString() + ", location: " + message.value.toString() + "\n");

                    count++;
                    if(count === 5){
                        write_stream.end();
                        call.end();
                        await consumer.disconnect();
                        return;
                    }
                },
            });

            // var new_consumer = new kafka_consumer.Kafka_Consumer('kafka-client-2', 'user_1');
            // await new_consumer.export_log(VOLUME_PATH);
        }
        catch(error){
            console.error("Error from run(): " + error.message);
            await consumer.disconnect();
        }
    }

    run().catch(console.error);
    //callback(null, {udid: call.request.udid, timestamp: 'timestamp', location: "12345"});
}

function main(){
    var server = new grpc.Server();
    server.addService(kafka_consumer_proto.Kafka_Consumer_gRPC.service, {Subscribe: Subscribe});
    server.bindAsync(SERVER_SOCKET, grpc.ServerCredentials.createInsecure(), () => {
        server.start();
    })
}

main();