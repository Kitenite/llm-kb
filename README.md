# Knowledge Base
A self-hosted solution to internal search. Answer questions about your organization.

# Setup
Add a `.env` file to the root of the project with the following variables:
```
OPENAI_API_KEY=YOUR_KEY
```

Soon we will add Chroma for vector database (instead of Pinecone) and Serge for LLM (instead of OpenAI)

# Run the app

In root folder:
```
docker compose up
```
This will start the following services on ports: 
- 8000: flutter client
- 8001: flask server
- 6379: redis database
