# Knowledge Base
A self-hosted solution to internal search. Answer questions about your organization.

# Setup
Add a `.env` file to the root of the project with the following variables (they're not uploaded to git for security reasons):

```
CLIENT_PORT=8000
SERVER_PORT=8001
MONGO_PORT=27017
MONGO_HOST=localhost
MONGO_INITDB_ROOT_USERNAME=root
MONGO_INITDB_ROOT_PASSWORD=password
LOCAL_STORAGE_DIR=local_storage
CHROMA_PERSISTENT_DIR=chroma_storage
OPENAI_API_KEY=SOME_API_KEY
```

Soon we will add Chroma for vector database (instead of Pinecone) and Serge for LLM (instead of OpenAI)

# Run the app

Make sure you have `docker compose` installed. In root folder:
```
docker compose up
```

This will start the following services on ports: 
- 8000: flutter client
- 8001: flask server
- 27017: mongodb database

To rebuild the app (if you make changes to the Dockerfile):
```
docker compose up --build
```
# Components
- Client: Flutter
- Key-value database: MongoDB
- Vector database: Chroma. For now we'll use Chrome in memory but later on we can use persistent storage [with this](https://docs.trychroma.com/deployment)