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
  static final _$export_Topics = $grpc.ClientMethod<$0.Request, $0.Response>(
      '/kafka_consumer_grpc.Kafka_Consumer_gRPC/Export_Topics',
      ($0.Request value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));

  Kafka_Consumer_gRPCClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.Location_Data> subscribe($0.Subscribe_Data request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$subscribe, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.Response> export_Topics($0.Request request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$export_Topics, request, options: options);
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
        true,
        ($core.List<$core.int> value) => $0.Subscribe_Data.fromBuffer(value),
        ($0.Location_Data value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Response>(
        'Export_Topics',
        export_Topics_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Location_Data> subscribe_Pre($grpc.ServiceCall call, $async.Future<$0.Subscribe_Data> request) async* {
    yield* subscribe(call, await request);
  }

  $async.Future<$0.Response> export_Topics_Pre($grpc.ServiceCall call, $async.Future<$0.Request> request) async {
    return export_Topics(call, await request);
  }

  $async.Stream<$0.Location_Data> subscribe($grpc.ServiceCall call, $0.Subscribe_Data request);
  $async.Future<$0.Response> export_Topics($grpc.ServiceCall call, $0.Request request);
}
