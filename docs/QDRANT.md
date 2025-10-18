# Qdrant Documentation

> **Note:** Personal development setup. Not production-ready.

## 📦 Service Details

| Property       | Value                |
| -------------- | -------------------- |
| **Version**    | 1.11.3               |
| **API Port**   | 6333                 |
| **gRPC Port**  | 6334                 |
| **Container**  | qdrant-container     |
| **Image**      | qdrant/qdrant:1.11.3 |

---

## 🎯 What is Qdrant?

Qdrant is an open-source vector similarity search engine with extended filtering support. Perfect for semantic search, recommendations, and RAG (Retrieval Augmented Generation) applications.

### Features:

- 🔍 **Vector Search** - Fast similarity search
- 📊 **Filtering** - Rich filtering on metadata
- 🚀 **Performance** - Written in Rust for speed
- 🔌 **REST & gRPC APIs** - Multiple client options
- 💾 **Persistent Storage** - Data saved on disk
- 🌐 **Web Dashboard** - Built-in UI

---

## Quick Start

```bash
# Start Qdrant
make up qdrant

# Access Dashboard
# http://localhost:6333/dashboard

# Check status
make ps qdrant
```

---

## 🔌 Using Qdrant

### Python Client

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

# Connect
client = QdrantClient(host="localhost", port=6333)

# Create collection
client.create_collection(
    collection_name="my_collection",
    vectors_config=VectorParams(size=384, distance=Distance.COSINE)
)

# Insert vectors
points = [
    PointStruct(
        id=1,
        vector=[0.1, 0.2, ...],  # 384 dimensions
        payload={"text": "Hello world", "category": "greeting"}
    ),
    PointStruct(
        id=2,
        vector=[0.3, 0.4, ...],
        payload={"text": "Good morning", "category": "greeting"}
    )
]
client.upsert(collection_name="my_collection", points=points)

# Search
results = client.search(
    collection_name="my_collection",
    query_vector=[0.15, 0.25, ...],
    limit=5
)

for result in results:
    print(f"Score: {result.score}, Text: {result.payload['text']}")
```

### With OpenAI Embeddings

```python
import openai
from qdrant_client import Qdrant Client

# Generate embeddings
def get_embedding(text):
    response = openai.Embedding.create(
        model="text-embedding-ada-002",
        input=text
    )
    return response['data'][0]['embedding']

# Store in Qdrant
text = "Machine learning is awesome"
vector = get_embedding(text)

client.upsert(
    collection_name="documents",
    points=[PointStruct(
        id=1,
        vector=vector,
        payload={"text": text}
    )]
)

# Semantic search
query = "AI and ML"
query_vector = get_embedding(query)

results = client.search(
    collection_name="documents",
    query_vector=query_vector,
    limit=5
)
```

### Filtering

```python
# Search with filters
from qdrant_client.models import Filter, FieldCondition, MatchValue

results = client.search(
    collection_name="my_collection",
    query_vector=[0.15, 0.25, ...],
    query_filter=Filter(
        must=[
            FieldCondition(
                key="category",
                match=MatchValue(value="greeting")
            )
        ]
    ),
    limit=5
)
```

---

## 🤖 RAG (Retrieval Augmented Generation)

```python
from sentence_transformers import SentenceTransformer
from qdrant_client import QdrantClient

# Load embedding model
model = SentenceTransformer('all-MiniLM-L6-v2')
client = QdrantClient(host="localhost", port=6333)

# Index documents
documents = [
    "Python is a programming language",
    "Machine learning uses algorithms",
    "Docker containers run applications"
]

for i, doc in enumerate(documents):
    vector = model.encode(doc).tolist()
    client.upsert(
        collection_name="knowledge_base",
        points=[PointStruct(
            id=i,
            vector=vector,
            payload={"text": doc}
        )]
    )

# RAG query
def rag_query(question, k=3):
    # 1. Search relevant documents
    query_vector = model.encode(question).tolist()
    results = client.search(
        collection_name="knowledge_base",
        query_vector=query_vector,
        limit=k
    )
    
    # 2. Build context
    context = "\n".join([r.payload["text"] for r in results])
    
    # 3. Generate answer (with LLM)
    prompt = f"Context: {context}\n\nQuestion: {question}\n\nAnswer:"
    # answer = llm.generate(prompt)
    
    return context

answer = rag_query("What is Python?")
```

---

## Resources

- **Docs:** https://qdrant.tech/documentation/
- **Python Client:** https://github.com/qdrant/qdrant-client
- **Docker Hub:** https://hub.docker.com/r/qdrant/qdrant

---

**Need help?** Check the [main README](../README.md) or [Qdrant documentation](https://qdrant.tech/documentation/).
