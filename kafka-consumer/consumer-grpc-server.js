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

async function Subscribe(call, callback){
    const new_consumer = new kafka_consumer.Kafka_Consumer(call.request.session_id, call.request.session_id);
    await new_consumer.subscribe_and_listen(call.request.udid, ({ udid, timestamp, location }) => {
        call.write({udid: udid, timestamp: timestamp, location: location});
        console.log({
            udid: udid,
            timestamp: timestamp,
            location: location
        })
    })
}

async function Export_Topics(call, callback){
    const new_consumer = new kafka_consumer.Kafka_Consumer('export-topic-consumer', 'admin');
    var res = await new_consumer.export_log(VOLUME_PATH);
    callback(null, {success: res});
}

function main(){
    var server = new grpc.Server();
    server.addService(kafka_consumer_proto.Kafka_Consumer_gRPC.service, {Subscribe: Subscribe, Export_Topics: Export_Topics});
    server.bindAsync(SERVER_SOCKET, grpc.ServerCredentials.createInsecure(), () => {
        server.start();
    })
}

main();