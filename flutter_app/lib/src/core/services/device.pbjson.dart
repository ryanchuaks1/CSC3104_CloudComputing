//
//  Generated code. Do not modify.
//  source: device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use itemDescriptor instead')
const Item$json = {
  '1': 'Item',
  '2': [
    {'1': '_id', '3': 1, '4': 1, '5': 9, '10': 'Id'},
    {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'deviceId', '3': 3, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'deviceName', '3': 4, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'latitude', '3': 5, '4': 1, '5': 9, '10': 'latitude'},
    {'1': 'longitude', '3': 6, '4': 1, '5': 9, '10': 'longitude'},
  ],
};

/// Descriptor for `Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDescriptor = $convert.base64Decode(
    'CgRJdGVtEg8KA19pZBgBIAEoCVICSWQSFgoGdXNlcklkGAIgASgJUgZ1c2VySWQSGgoIZGV2aW'
    'NlSWQYAyABKAlSCGRldmljZUlkEh4KCmRldmljZU5hbWUYBCABKAlSCmRldmljZU5hbWUSGgoI'
    'bGF0aXR1ZGUYBSABKAlSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgGIAEoCVIJbG9uZ2l0dWRl');

@$core.Deprecated('Use replyDescriptor instead')
const Reply$json = {
  '1': 'Reply',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 9, '10': 'result'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'items', '3': 3, '4': 3, '5': 11, '6': '.device.Item', '10': 'items'},
  ],
};

/// Descriptor for `Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyDescriptor = $convert.base64Decode(
    'CgVSZXBseRIWCgZyZXN1bHQYASABKAlSBnJlc3VsdBIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYW'
    'dlEiIKBWl0ZW1zGAMgAygLMgwuZGV2aWNlLkl0ZW1SBWl0ZW1z');

