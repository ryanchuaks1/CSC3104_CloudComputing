//
//  Generated code. Do not modify.
//  source: kafka_consumer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use subscribe_DataDescriptor instead')
const Subscribe_Data$json = {
  '1': 'Subscribe_Data',
  '2': [
    {'1': 'udid', '3': 1, '4': 1, '5': 9, '10': 'udid'},
  ],
};

/// Descriptor for `Subscribe_Data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribe_DataDescriptor = $convert.base64Decode(
    'Cg5TdWJzY3JpYmVfRGF0YRISCgR1ZGlkGAEgASgJUgR1ZGlk');

@$core.Deprecated('Use location_DataDescriptor instead')
const Location_Data$json = {
  '1': 'Location_Data',
  '2': [
    {'1': 'udid', '3': 1, '4': 1, '5': 9, '10': 'udid'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 9, '10': 'timestamp'},
    {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `Location_Data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List location_DataDescriptor = $convert.base64Decode(
    'Cg1Mb2NhdGlvbl9EYXRhEhIKBHVkaWQYASABKAlSBHVkaWQSHAoJdGltZXN0YW1wGAIgASgJUg'
    'l0aW1lc3RhbXASGgoIbG9jYXRpb24YAyABKAlSCGxvY2F0aW9u');

@$core.Deprecated('Use response_DataDescriptor instead')
const Response_Data$json = {
  '1': 'Response_Data',
  '2': [
    {'1': 'udid', '3': 1, '4': 1, '5': 9, '10': 'udid'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `Response_Data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List response_DataDescriptor = $convert.base64Decode(
    'Cg1SZXNwb25zZV9EYXRhEhIKBHVkaWQYASABKAlSBHVkaWQSGAoHc3VjY2VzcxgCIAEoCFIHc3'
    'VjY2Vzcw==');

