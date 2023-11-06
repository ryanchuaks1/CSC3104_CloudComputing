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

@$pb.GrpcServiceName('kafka_producer_grpc.Kafka_Producer_gRPC')
class Kafka_Producer_gRPCClient extends $grpc.Client {
  static final _$add_New_Location = $grpc.ClientMethod<$0.Location, $0.Response>(
      '/kafka_producer_grpc.Kafka_Producer_gRPC/Add_New_Location',
      ($0.Location value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$add_New_Topic = $grpc.ClientMethod<$0.Topic, $0.Response>(
      '/kafka_producer_grpc.Kafka_Producer_gRPC/Add_New_Topic',
      ($0.Topic value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$load_Topics = $grpc.ClientMethod<$0.Request, $0.Response>(
      '/kafka_producer_grpc.Kafka_Producer_gRPC/Load_Topics',
      ($0.Request value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));

  Kafka_Producer_gRPCClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Response> add_New_Location($0.Location request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$add_New_Location, request, options: options);
  }

  $grpc.ResponseFuture<$0.Response> add_New_Topic($0.Topic request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$add_New_Topic, request, options: options);
  }

  $grpc.ResponseFuture<$0.Response> load_Topics($0.Request request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$load_Topics, request, options: options);
  }
}

@$pb.GrpcServiceName('kafka_producer_grpc.Kafka_Producer_gRPC')
abstract class Kafka_Producer_gRPCServiceBase extends $grpc.Service {
  $core.String get $name => 'kafka_producer_grpc.Kafka_Producer_gRPC';

  Kafka_Producer_gRPCServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Location, $0.Response>(
        'Add_New_Location',
        add_New_Location_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Location.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Topic, $0.Response>(
        'Add_New_Topic',
        add_New_Topic_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Topic.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Response>(
        'Load_Topics',
        load_Topics_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
  }

  $async.Future<$0.Response> add_New_Location_Pre($grpc.ServiceCall call, $async.Future<$0.Location> request) async {
    return add_New_Location(call, await request);
  }

  $async.Future<$0.Response> add_New_Topic_Pre($grpc.ServiceCall call, $async.Future<$0.Topic> request) async {
    return add_New_Topic(call, await request);
  }

  $async.Future<$0.Response> load_Topics_Pre($grpc.ServiceCall call, $async.Future<$0.Request> request) async {
    return load_Topics(call, await request);
  }

  $async.Future<$0.Response> add_New_Location($grpc.ServiceCall call, $0.Location request);
  $async.Future<$0.Response> add_New_Topic($grpc.ServiceCall call, $0.Topic request);
  $async.Future<$0.Response> load_Topics($grpc.ServiceCall call, $0.Request request);
}
