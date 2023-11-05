from google.protobuf.internal import containers as _containers
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class Item(_message.Message):
    __slots__ = ["_id", "userId", "deviceId", "deviceName", "latitude", "longitude"]
    _ID_FIELD_NUMBER: _ClassVar[int]
    USERID_FIELD_NUMBER: _ClassVar[int]
    DEVICEID_FIELD_NUMBER: _ClassVar[int]
    DEVICENAME_FIELD_NUMBER: _ClassVar[int]
    LATITUDE_FIELD_NUMBER: _ClassVar[int]
    LONGITUDE_FIELD_NUMBER: _ClassVar[int]
    _id: str
    userId: str
    deviceId: str
    deviceName: str
    latitude: str
    longitude: str
    def __init__(self, _id: _Optional[str] = ..., userId: _Optional[str] = ..., deviceId: _Optional[str] = ..., deviceName: _Optional[str] = ..., latitude: _Optional[str] = ..., longitude: _Optional[str] = ...) -> None: ...

class UserAccount(_message.Message):
    __slots__ = ["userName", "userPasswordHash"]
    USERNAME_FIELD_NUMBER: _ClassVar[int]
    USERPASSWORDHASH_FIELD_NUMBER: _ClassVar[int]
    userName: str
    userPasswordHash: str
    def __init__(self, userName: _Optional[str] = ..., userPasswordHash: _Optional[str] = ...) -> None: ...

class UserInstance(_message.Message):
    __slots__ = ["result", "userId", "userName"]
    RESULT_FIELD_NUMBER: _ClassVar[int]
    USERID_FIELD_NUMBER: _ClassVar[int]
    USERNAME_FIELD_NUMBER: _ClassVar[int]
    result: str
    userId: str
    userName: str
    def __init__(self, result: _Optional[str] = ..., userId: _Optional[str] = ..., userName: _Optional[str] = ...) -> None: ...

class Reply(_message.Message):
    __slots__ = ["result", "message", "items"]
    RESULT_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_FIELD_NUMBER: _ClassVar[int]
    ITEMS_FIELD_NUMBER: _ClassVar[int]
    result: str
    message: str
    items: _containers.RepeatedCompositeFieldContainer[Item]
    def __init__(self, result: _Optional[str] = ..., message: _Optional[str] = ..., items: _Optional[_Iterable[_Union[Item, _Mapping]]] = ...) -> None: ...
