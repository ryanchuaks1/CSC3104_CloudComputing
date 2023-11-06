//
//  Generated code. Do not modify.
//  source: device.proto
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

import 'device.pb.dart' as $0;

export 'device.pb.dart';

@$pb.GrpcServiceName('device.Device')
class DeviceClient extends $grpc.Client {
  static final _$publish_current_location = $grpc.ClientMethod<$0.Item, $0.Reply>(
      '/device.Device/publish_current_location',
      ($0.Item value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Reply.fromBuffer(value));
  static final _$add_new_device = $grpc.ClientMethod<$0.Item, $0.Reply>(
      '/device.Device/add_new_device',
      ($0.Item value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Reply.fromBuffer(value));
  static final _$delete_device = $grpc.ClientMethod<$0.Item, $0.Reply>(
      '/device.Device/delete_device',
      ($0.Item value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Reply.fromBuffer(value));
  static final _$get_all_devices = $grpc.ClientMethod<$0.Item, $0.Reply>(
      '/device.Device/get_all_devices',
      ($0.Item value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Reply.fromBuffer(value));
  static final _$create_account = $grpc.ClientMethod<$0.UserAccount, $0.Reply>(
      '/device.Device/create_account',
      ($0.UserAccount value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Reply.fromBuffer(value));
  static final _$login = $grpc.ClientMethod<$0.UserAccount, $0.UserInstance>(
      '/device.Device/login',
      ($0.UserAccount value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserInstance.fromBuffer(value));

  DeviceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Reply> publish_current_location($0.Item request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$publish_current_location, request, options: options);
  }

  $grpc.ResponseFuture<$0.Reply> add_new_device($0.Item request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$add_new_device, request, options: options);
  }

  $grpc.ResponseFuture<$0.Reply> delete_device($0.Item request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$delete_device, request, options: options);
  }

  $grpc.ResponseFuture<$0.Reply> get_all_devices($0.Item request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$get_all_devices, request, options: options);
  }

  $grpc.ResponseFuture<$0.Reply> create_account($0.UserAccount request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$create_account, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserInstance> login($0.UserAccount request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }
}

@$pb.GrpcServiceName('device.Device')
abstract class DeviceServiceBase extends $grpc.Service {
  $core.String get $name => 'device.Device';

  DeviceServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Item, $0.Reply>(
        'publish_current_location',
        publish_current_location_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Item.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Item, $0.Reply>(
        'add_new_device',
        add_new_device_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Item.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Item, $0.Reply>(
        'delete_device',
        delete_device_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Item.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Item, $0.Reply>(
        'get_all_devices',
        get_all_devices_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Item.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserAccount, $0.Reply>(
        'create_account',
        create_account_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserAccount.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserAccount, $0.UserInstance>(
        'login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserAccount.fromBuffer(value),
        ($0.UserInstance value) => value.writeToBuffer()));
  }

  $async.Future<$0.Reply> publish_current_location_Pre($grpc.ServiceCall call, $async.Future<$0.Item> request) async {
    return publish_current_location(call, await request);
  }

  $async.Future<$0.Reply> add_new_device_Pre($grpc.ServiceCall call, $async.Future<$0.Item> request) async {
    return add_new_device(call, await request);
  }

  $async.Future<$0.Reply> delete_device_Pre($grpc.ServiceCall call, $async.Future<$0.Item> request) async {
    return delete_device(call, await request);
  }

  $async.Future<$0.Reply> get_all_devices_Pre($grpc.ServiceCall call, $async.Future<$0.Item> request) async {
    return get_all_devices(call, await request);
  }

  $async.Future<$0.Reply> create_account_Pre($grpc.ServiceCall call, $async.Future<$0.UserAccount> request) async {
    return create_account(call, await request);
  }

  $async.Future<$0.UserInstance> login_Pre($grpc.ServiceCall call, $async.Future<$0.UserAccount> request) async {
    return login(call, await request);
  }

  $async.Future<$0.Reply> publish_current_location($grpc.ServiceCall call, $0.Item request);
  $async.Future<$0.Reply> add_new_device($grpc.ServiceCall call, $0.Item request);
  $async.Future<$0.Reply> delete_device($grpc.ServiceCall call, $0.Item request);
  $async.Future<$0.Reply> get_all_devices($grpc.ServiceCall call, $0.Item request);
  $async.Future<$0.Reply> create_account($grpc.ServiceCall call, $0.UserAccount request);
  $async.Future<$0.UserInstance> login($grpc.ServiceCall call, $0.UserAccount request);
}
