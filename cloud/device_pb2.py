# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: device.proto
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x0c\x64\x65vice.proto\x12\x06\x64\x65vice\"n\n\x04Item\x12\x0b\n\x03_id\x18\x01 \x01(\t\x12\x0e\n\x06userId\x18\x02 \x01(\t\x12\x10\n\x08\x64\x65viceId\x18\x03 \x01(\t\x12\x12\n\ndeviceName\x18\x04 \x01(\t\x12\x10\n\x08latitude\x18\x05 \x01(\t\x12\x11\n\tlongitude\x18\x06 \x01(\t\"9\n\x0bUserAccount\x12\x10\n\x08userName\x18\x01 \x01(\t\x12\x18\n\x10userPasswordHash\x18\x02 \x01(\t\"@\n\x0cUserInstance\x12\x0e\n\x06result\x18\x01 \x01(\t\x12\x0e\n\x06userId\x18\x02 \x01(\t\x12\x10\n\x08userName\x18\x03 \x01(\t\"E\n\x05Reply\x12\x0e\n\x06result\x18\x01 \x01(\t\x12\x0f\n\x07message\x18\x02 \x01(\t\x12\x1b\n\x05items\x18\x03 \x03(\x0b\x32\x0c.device.Item2\x89\x02\n\x06\x44\x65vice\x12/\n\x0e\x61\x64\x64_new_device\x12\x0c.device.Item\x1a\r.device.Reply\"\x00\x12.\n\rdelete_device\x12\x0c.device.Item\x1a\r.device.Reply\"\x00\x12\x30\n\x0fget_all_devices\x12\x0c.device.Item\x1a\r.device.Reply\"\x00\x12\x36\n\x0e\x63reate_account\x12\x13.device.UserAccount\x1a\r.device.Reply\"\x00\x12\x34\n\x05login\x12\x13.device.UserAccount\x1a\x14.device.UserInstance\"\x00\x62\x06proto3')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'device_pb2', _globals)
if _descriptor._USE_C_DESCRIPTORS == False:
  DESCRIPTOR._options = None
  _globals['_ITEM']._serialized_start=24
  _globals['_ITEM']._serialized_end=134
  _globals['_USERACCOUNT']._serialized_start=136
  _globals['_USERACCOUNT']._serialized_end=193
  _globals['_USERINSTANCE']._serialized_start=195
  _globals['_USERINSTANCE']._serialized_end=259
  _globals['_REPLY']._serialized_start=261
  _globals['_REPLY']._serialized_end=330
  _globals['_DEVICE']._serialized_start=333
  _globals['_DEVICE']._serialized_end=598
# @@protoc_insertion_point(module_scope)
