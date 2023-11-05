from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Optional as _Optional

DESCRIPTOR: _descriptor.FileDescriptor

class Topic(_message.Message):
    __slots__ = ["udid"]
    UDID_FIELD_NUMBER: _ClassVar[int]
    udid: str
    def __init__(self, udid: _Optional[str] = ...) -> None: ...

class Location(_message.Message):
    __slots__ = ["udid", "location"]
    UDID_FIELD_NUMBER: _ClassVar[int]
    LOCATION_FIELD_NUMBER: _ClassVar[int]
    udid: str
    location: str
    def __init__(self, udid: _Optional[str] = ..., location: _Optional[str] = ...) -> None: ...

class Request(_message.Message):
    __slots__ = []
    def __init__(self) -> None: ...

class Response(_message.Message):
    __slots__ = ["udid", "success"]
    UDID_FIELD_NUMBER: _ClassVar[int]
    SUCCESS_FIELD_NUMBER: _ClassVar[int]
    udid: str
    success: bool
    def __init__(self, udid: _Optional[str] = ..., success: bool = ...) -> None: ...
