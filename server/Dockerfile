FROM python:3.11-slim

WORKDIR /app

RUN apt-get update
RUN apt-get install -y gcc build-essential
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Create the default llama index context storage path
ARG CONTEXT_STORAGE_DIR=/app/storage
ENV CONTEXT_STORAGE_DIR=$CONTEXT_STORAGE_DIR
RUN mkdir $CONTEXT_STORAGE_DIR

ARG CONTAINER_SERVER_PORT=5000
ENV CONTAINER_SERVER_PORT=$CONTAINER_SERVER_PORT
EXPOSE $CONTAINER_SERVER_PORT

COPY . .
CMD ["python", "src/api.py"]
