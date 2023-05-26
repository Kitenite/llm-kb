FROM python:3.11-slim

WORKDIR /app

# ENV FLASK_APP=src/api.py
# ENV FLASK_RUN_HOST=0.0.0.0
# ENV FLASK_RUN_PORT=5000

RUN apt-get update
RUN apt-get install -y gcc build-essential
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
COPY . .
CMD ["python", "src/api.py"]
