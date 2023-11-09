const PROTO_PATH = __dirname + '/kafka_producer.proto';
const SERVER_SOCKET = "0.0.0.0:50052";
const VOLUME_PATH = __dirname + '/data';

//var parseArgs = require('minimist');
var grpc = require('@grpc/grpc-js');
var protoLoader = require('@grpc/proto-loader');
var kafka_producer = require('./producer.js');
var kafka_admin = require('./admin.js');
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

var kafka_producer_proto = grpc.loadPackageDefinition(packageDefinition).kafka_producer_grpc;

async function Add_New_Location(call, callback){
    const new_producer = new kafka_producer.Kafka_Producer('kafka-producer');
    var res = await new_producer.update_location(call.request.udid, undefined, call.request.location);
    callback(null, {udid: call.request.udid, success: res});
}

async function Add_New_Topic(call, callback){
    const new_admin = new kafka_admin.Kafka_Admin('kafka-admin');

    var topic_exist = await new_admin.check_topic(call.request.udid);

    if(!topic_exist){
        await new_admin.add_new_topic(call.request.udid);
        callback(null, {udid: call.request.udid, success: true});
    }
    else{
        callback(null, {udid: call.request.udid, success: false});
    }
}

async function Load_Topics(call, callback){
    const new_producer = new kafka_producer.Kafka_Producer('load-topic-producer');
    var res = await new_producer.load_topics(VOLUME_PATH);
    callback(null, {udid: null, success: res});
}

function main(){
    var server = new grpc.Server();
    server.addService(kafka_producer_proto.Kafka_Producer_gRPC.service, {Add_New_Location: Add_New_Location, Add_New_Topic: Add_New_Topic, Load_Topics: Load_Topics});
    server.bindAsync(SERVER_SOCKET, grpc.ServerCredentials.createInsecure(), () => {
        server.start();
    })
}

main();
