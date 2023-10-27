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
    //const new_consumer = new kafka_consumer.Kafka_Consumer("f1740855-6716-11ee-9b42-107b44", 'kafka-client', 'user_1');
    //new_consumer.subscribe_and_listen().catch(console.error);
    callback(null, {udid: call.request.udid, timestamp: 'timestamp', location: "12345"});
}

function main(){
    var server = new grpc.Server();
    server.addService(kafka_consumer_proto.Kafka_Consumer_gRPC.service, {subscribe: Subscribe});
    server.bindAsync(SERVER_SOCKET, grpc.ServerCredentials.createInsecure(), () => {
        server.start();
    })
}

main();