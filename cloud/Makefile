PROTO=device

all: compile

compile:
	python -m grpc_tools.protoc -I. --python_out=. --pyi_out=. --grpc_python_out=. ./${PROTO}.proto

clean:
	${RM} -r __pycache__ ${PROTO}_pb2_grpc.py ${PROTO}_pb2.py ${PROTO}_pb2.pyi
