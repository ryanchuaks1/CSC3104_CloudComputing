//
//  Generated code. Do not modify.
//  source: kafka_producer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Location_Data extends $pb.GeneratedMessage {
  factory Location_Data({
    $core.String? udid,
    $core.String? timestamp,
    $core.String? location,
  }) {
    final $result = create();
    if (udid != null) {
      $result.udid = udid;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (location != null) {
      $result.location = location;
    }
    return $result;
  }
  Location_Data._() : super();
  factory Location_Data.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Location_Data.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Location_Data', package: const $pb.PackageName(_omitMessageNames ? '' : 'kafka_consumer_grpc'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'udid')
    ..aOS(2, _omitFieldNames ? '' : 'timestamp')
    ..aOS(3, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Location_Data clone() => Location_Data()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Location_Data copyWith(void Function(Location_Data) updates) => super.copyWith((message) => updates(message as Location_Data)) as Location_Data;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location_Data create() => Location_Data._();
  Location_Data createEmptyInstance() => create();
  static $pb.PbList<Location_Data> createRepeated() => $pb.PbList<Location_Data>();
  @$core.pragma('dart2js:noInline')
  static Location_Data getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location_Data>(create);
  static Location_Data? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get udid => $_getSZ(0);
  @$pb.TagNumber(1)
  set udid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUdid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUdid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get timestamp => $_getSZ(1);
  @$pb.TagNumber(2)
  set timestamp($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get location => $_getSZ(2);
  @$pb.TagNumber(3)
  set location($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => clearField(3);
}

class Response_Data extends $pb.GeneratedMessage {
  factory Response_Data({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  Response_Data._() : super();
  factory Response_Data.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Response_Data.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Response_Data', package: const $pb.PackageName(_omitMessageNames ? '' : 'kafka_consumer_grpc'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Response_Data clone() => Response_Data()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Response_Data copyWith(void Function(Response_Data) updates) => super.copyWith((message) => updates(message as Response_Data)) as Response_Data;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Response_Data create() => Response_Data._();
  Response_Data createEmptyInstance() => create();
  static $pb.PbList<Response_Data> createRepeated() => $pb.PbList<Response_Data>();
  @$core.pragma('dart2js:noInline')
  static Response_Data getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response_Data>(create);
  static Response_Data? _defaultInstance;

  /// string udid = 1;
  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
