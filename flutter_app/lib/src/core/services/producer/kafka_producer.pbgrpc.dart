//
//  Generated code. Do not modify.
//  source: kafka_producer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'kafka_producer.pb.dart' as $0;

export 'kafka_producer.pb.dart';

@$pb.GrpcServiceName('kafka_consumer_grpc.Kafka_Producer_gRPC')
class Kafka_Producer_gRPCClient extends $grpc.Client {
  static final _$publish = $grpc.ClientMethod<$0.Location_Data, $0.Response_Data>(
      '/kafka_consumer_grpc.Kafka_Producer_gRPC/Publish',
      ($0.Location_Data value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response_Data.fromBuffer(value));

  Kafka_Producer_gRPCClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Response_Data> publish($0.Location_Data request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$publish, request, options: options);
  }
}

@$pb.GrpcServiceName('kafka_consumer_grpc.Kafka_Producer_gRPC')
abstract class Kafka_Producer_gRPCServiceBase extends $grpc.Service {
  $core.String get $name => 'kafka_consumer_grpc.Kafka_Producer_gRPC';

  Kafka_Producer_gRPCServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Location_Data, $0.Response_Data>(
        'Publish',
        publish_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Location_Data.fromBuffer(value),
        ($0.Response_Data value) => value.writeToBuffer()));
  }

  $async.Future<$0.Response_Data> publish_Pre($grpc.ServiceCall call, $async.Future<$0.Location_Data> request) async {
    return publish(call, await request);
  }

  $async.Future<$0.Response_Data> publish($grpc.ServiceCall call, $0.Location_Data request);
}
