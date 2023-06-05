# LLM Knowledge Base
A self-hosted solution to internal search. Add an indexes all your data and ask question about them using natural language.

# Project Setup

## Prerequisites
Ensure the following tools are installed on your machine:

- OpenAI API key: The current LLM used is OpenAI GPT-3.5 so you need an API key to use it. You can get one [here](https://beta.openai.com/).
- Docker: Install from [Docker official page](https://docs.docker.com/get-docker/)
- Docker Compose: Install from [Docker official page](https://docs.docker.com/compose/install/)

## Run setup script

The setup script ensures docker compose is set up, create the `.env` file and creates `mongo-keyfile` for MongoDB.

Here are the steps to run this script:

1. Open a terminal.
2. Navigate to the root directory of the project.
3. Run the following command to ensure setup.sh has execute permissions:
```
chmod +x setup.sh
```
4. Now run the setup script:

```
./setup.sh
```

# Run the app

Make sure you have `docker compose` installed. In root folder:
```
docker compose up --build
```

This will start the following services on ports: 
- 8000: flutter client
- 8001: flask server
- 8002: weaviate database (Not used atm)
- 8003: mongodb database

Go to `localhost:8000` to start using the app.

# Components
- Client: [Flutter](https://flutter.dev/)
- Server: [Flask](https://flask.palletsprojects.com)
- Key-value database: [MongoDB](https://www.mongodb.com/)
- Vector database: [Weaviate](https://weaviate.io/) (Not used atm)

# Resources
- [LLM Knowledge retrieval](https://mattboegner.com/knowledge-retrieval-architecture-for-llms/)
- [LlamaIndex with MongoDB](https://medium.com/llamaindex-blog/build-a-chatgpt-with-your-private-data-using-llamaindex-and-mongodb-b09850eb154c)
- [Graph with Weaviate](https://gpt-index.readthedocs.io/en/latest/examples/composable_indices/ComposableIndices-Weaviate.html)
