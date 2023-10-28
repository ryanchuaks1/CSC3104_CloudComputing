const PROTO_PATH = __dirname + '/kafka_consumer.proto';
const SERVER_SOCKET = "consumer-service:50051";

//var parseArgs = require('minimist');
var grpc = require('@grpc/grpc-js');
var protoLoader = require('@grpc/proto-loader');
var kafka_consumer = require('./consumer.js');
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

    const { Kafka } = require('kafkajs');
    const kafka = new Kafka({
        clientId: 'my-app',
        brokers: ['kafka:9092'],
    });
    const consumer = kafka.consumer({
        groupId: 'my-group'
    });

    async function run(){
        try{
            await consumer.connect();
            await consumer.subscribe({
                topic: call.request.udid,
                fromBeginning: true
            });
    
            await consumer.run({
                eachMessage: async ({ topic, partition, message }) => {
                    call.write({udid: call.request.udid, timestamp: message.key.toString(), location: message.value.toString()});
                },
            });
        }
        catch(error){
            console.error("Error: " + error.message);
            await consumer.disconnect();
        }
    }

    run().catch(console.error);
    //callback(null, {udid: call.request.udid, timestamp: 'timestamp', location: "12345"});
}

function main(){
    var server = new grpc.Server();
    server.addService(kafka_consumer_proto.Kafka_Consumer_gRPC.service, {subscribe: Subscribe});
    server.bindAsync(SERVER_SOCKET, grpc.ServerCredentials.createInsecure(), () => {
        server.start();
    })
}

main();