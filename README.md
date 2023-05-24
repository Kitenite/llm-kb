# Knowledge Base
A self-hosted solution to internal search. Answer questions about your organization.

# Setup
Add a `.env` file to the root of the project similar to `.env_example` 

# Run the app

Make sure you have `docker compose` installed. In root folder:
```
docker compose up
```

This will start the following services on ports: 
- 8000: flutter client
- 8001: flask server
- 8002: weaviate database
- 8003: mongodb database

To rebuild the app (if you make changes to the Dockerfile):
```
docker compose up --build
```
# Components
- Client: [Flutter](https://flutter.dev/)
- Server: [Flask](https://flask.palletsprojects.com)
- Key-value database: [MongoDB](https://www.mongodb.com/)
- Vector database: [Weaviate](https://weaviate.io/)

# Resources
- [LlamaIndex with MongoDB](https://medium.com/llamaindex-blog/build-a-chatgpt-with-your-private-data-using-llamaindex-and-mongodb-b09850eb154c)
- [Graph with Weaviate](https://gpt-index.readthedocs.io/en/latest/examples/composable_indices/ComposableIndices-Weaviate.html)
- [LLM Knowledge retrieval](https://mattboegner.com/knowledge-retrieval-architecture-for-llms/)