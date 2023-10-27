//
//  Generated code. Do not modify.
//  source: kafka_consumer.proto
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

import 'kafka_consumer.pb.dart' as $0;

export 'kafka_consumer.pb.dart';

@$pb.GrpcServiceName('kafka_consumer_grpc.Kafka_Consumer_gRPC')
class Kafka_Consumer_gRPCClient extends $grpc.Client {
  static final _$subscribe = $grpc.ClientMethod<$0.Subscribe_Data, $0.Location_Data>(
      '/kafka_consumer_grpc.Kafka_Consumer_gRPC/Subscribe',
      ($0.Subscribe_Data value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Location_Data.fromBuffer(value));

  Kafka_Consumer_gRPCClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Location_Data> subscribe($0.Subscribe_Data request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$subscribe, request, options: options);
  }
}

@$pb.GrpcServiceName('kafka_consumer_grpc.Kafka_Consumer_gRPC')
abstract class Kafka_Consumer_gRPCServiceBase extends $grpc.Service {
  $core.String get $name => 'kafka_consumer_grpc.Kafka_Consumer_gRPC';

  Kafka_Consumer_gRPCServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Subscribe_Data, $0.Location_Data>(
        'Subscribe',
        subscribe_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Subscribe_Data.fromBuffer(value),
        ($0.Location_Data value) => value.writeToBuffer()));
  }

  $async.Future<$0.Location_Data> subscribe_Pre($grpc.ServiceCall call, $async.Future<$0.Subscribe_Data> request) async {
    return subscribe(call, await request);
  }

  $async.Future<$0.Location_Data> subscribe($grpc.ServiceCall call, $0.Subscribe_Data request);
}
