# Label Studio Added - Summary

## ✅ Label Studio Successfully Added!

**Label Studio** is an open-source data labeling tool for machine learning projects. It supports multiple data types and ML frameworks.

---

## 📦 Service Details

| Property          | Value                     |
| ----------------- | ------------------------- |
| **Version**       | 1.21.0 (latest stable)    |
| **Port**          | 8082                      |
| **Container**     | labelstudio-container     |
| **Web UI**        | http://localhost:8082     |
| **Default Login** | admin@example.com / admin |

---

## 🎯 What is Label Studio?

Label Studio is a **data annotation and labeling platform** for creating training data for ML/AI models.

### Key Features:

- 📝 **Multi-format support:** Images, text, audio, video, time-series, HTML
- 🤖 **ML integration:** Pre-labeling with models, active learning
- 👥 **Collaboration:** Multi-user projects, role-based access
- 📤 **Export formats:** JSON, CSV, COCO, YOLO, Pascal VOC, TSV, CONLL
- 🔌 **API & SDK:** Python SDK for automation
- 🎨 **Customizable:** Custom labeling interfaces and workflows

### Use Cases:

- **Computer Vision:** Image classification, object detection, segmentation
- **NLP:** Named entity recognition, text classification, sentiment analysis
- **Audio:** Speech recognition, audio classification
- **Video:** Video classification, frame-by-frame annotation
- **Time-Series:** Anomaly detection, sequence labeling

---

## 🚀 Setup & Usage

### Prerequisites

Label Studio requires PostgreSQL for data storage.

### Setup Steps

```bash
# 1. Start PostgreSQL
make up postgresql

# 2. Create Label Studio database
docker exec -it postgres-container psql -U postgres -c "CREATE DATABASE labelstudio;"

# 3. Create shared network
docker network create local-dev-network

# 4. Start Label Studio
make up labelstudio

# 5. Access the Web UI
# Open: http://localhost:8082
# Login: admin@example.com / admin
```

### First-Time Setup

1. Open http://localhost:8082
2. Login with default credentials (or set in `.env`)
3. Create your first project
4. Import data (upload files or connect cloud storage)
5. Configure labeling interface
6. Start labeling!

---

## 💡 Usage Examples

### Example 1: Image Classification

```python
from label_studio_sdk import Client

# Connect to Label Studio
ls = Client(url='http://localhost:8082', api_key='YOUR_API_KEY')

# Create project
project = ls.start_project(
    title='Image Classification',
    label_config='''
    <View>
      <Image name="image" value="$image"/>
      <Choices name="choice" toName="image">
        <Choice value="Cat"/>
        <Choice value="Dog"/>
        <Choice value="Bird"/>
      </Choices>
    </View>
    '''
)

# Import tasks
project.import_tasks([
    {'image': 'https://example.com/image1.jpg'},
    {'image': 'https://example.com/image2.jpg'}
])

# Export annotations
annotations = project.export_tasks()
```

### Example 2: Named Entity Recognition (NER)

```python
project = ls.start_project(
    title='NER Labeling',
    label_config='''
    <View>
      <Text name="text" value="$text"/>
      <Labels name="label" toName="text">
        <Label value="Person"/>
        <Label value="Organization"/>
        <Label value="Location"/>
      </Labels>
    </View>
    '''
)

# Import text data
project.import_tasks([
    {'text': 'Apple Inc. is located in Cupertino, California.'},
    {'text': 'Elon Musk founded SpaceX in 2002.'}
])
```

### Example 3: Object Detection

```python
project = ls.start_project(
    title='Object Detection',
    label_config='''
    <View>
      <Image name="image" value="$image"/>
      <RectangleLabels name="label" toName="image">
        <Label value="Car"/>
        <Label value="Person"/>
        <Label value="Bicycle"/>
      </RectangleLabels>
    </View>
    '''
)
```

---

## 🔧 Configuration

### Environment Variables (`.env`)

```bash
# PostgreSQL connection
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
LABELSTUDIO_DB=labelstudio

# Label Studio settings
LABEL_STUDIO_HOST=http://localhost:8082
LABEL_STUDIO_USERNAME=admin@example.com
LABEL_STUDIO_PASSWORD=admin
```

### Customize Admin Credentials

Edit `labelstudio/.env` before first startup:

```bash
LABEL_STUDIO_USERNAME=your.email@example.com
LABEL_STUDIO_PASSWORD=your_secure_password
```

---

## 🔌 Integration with Other Services

### With PostgreSQL (Required)

```bash
# Label Studio stores all data in PostgreSQL
# Projects, tasks, annotations, users, etc.
make up postgresql labelstudio
```

### With MinIO (Optional - Cloud Storage)

```bash
# Store images/media in MinIO instead of local storage
make up minio labelstudio
# Configure in Label Studio UI: Settings → Cloud Storage → S3
# Endpoint: http://minio-container:9000
```

### With MLflow (ML Pipeline)

```bash
# Label data → Train model → Track with MLflow
make up postgresql labelstudio mlflow
```

### Complete ML Stack

```bash
# Data labeling + Vector DB + Experiment tracking
make up postgresql labelstudio qdrant mlflow
```

---

## 📊 Export Formats

Label Studio supports multiple export formats:

| Format         | Use Case                          |
| -------------- | --------------------------------- |
| **JSON**       | Universal, all annotation types   |
| **CSV**        | Tabular data, text classification |
| **COCO**       | Object detection (MS COCO format) |
| **YOLO**       | Object detection (YOLO format)    |
| **Pascal VOC** | Object detection (VOC format)     |
| **CONLL**      | Named Entity Recognition          |
| **TSV**        | Token classification              |
| **ASR**        | Audio transcription               |

---

## 🎨 Labeling Templates

Label Studio comes with pre-built templates:

### Computer Vision:

- Image Classification
- Object Detection with Bounding Boxes
- Semantic Segmentation
- Keypoint Annotation
- Optical Character Recognition (OCR)

### Natural Language Processing:

- Text Classification
- Named Entity Recognition
- Sentiment Analysis
- Question Answering
- Relation Extraction

### Audio:

- Audio Classification
- Speaker Diarization
- Transcription

### Other:

- Video Classification
- Time Series Annotation
- HTML Annotation
- Dialogue/Conversational AI

---

## 🔑 API Key Setup

1. Login to Label Studio UI
2. Go to: Account & Settings → Access Token
3. Copy your API key
4. Use in Python SDK:

```python
from label_studio_sdk import Client

ls = Client(
    url='http://localhost:8082',
    api_key='YOUR_API_KEY_HERE'
)
```

---

## 📈 Workflow Example

### Complete ML Labeling Pipeline

```bash
# 1. Setup infrastructure
make up postgresql
docker exec -it postgres-container psql -U postgres -c "CREATE DATABASE labelstudio;"
docker compose -f docker-compose.network.yaml up -d
make up labelstudio mlflow qdrant

# 2. Label your data in Label Studio (http://localhost:8082)
# 3. Export labeled data
# 4. Train your model
# 5. Track experiments in MLflow (http://localhost:5000)
# 6. Store embeddings in Qdrant
# 7. Deploy and iterate!
```

---

## 🆚 Comparison with Alternatives

| Feature            | Label Studio | Labelbox   | Supervisely |
| ------------------ | ------------ | ---------- | ----------- |
| **Open Source**    | ✅ Yes       | ❌ No      | ❌ No       |
| **Self-hosted**    | ✅ Yes       | ⚠️ Limited | ⚠️ Limited  |
| **Cost**           | Free         | Paid       | Paid        |
| **Multi-format**   | ✅ Yes       | ✅ Yes     | ✅ Yes      |
| **ML Integration** | ✅ Yes       | ✅ Yes     | ✅ Yes      |
| **Customizable**   | ✅ Highly    | ⚠️ Limited | ⚠️ Limited  |

---

## 💾 Data Persistence

Label Studio stores data in two places:

1. **PostgreSQL Database:** Projects, tasks, annotations, users
2. **Volume:** Media files, exports, uploads
   - Volume name: `labelstudio-data`
   - Location: `/label-studio/data`

### Backup Your Data

```bash
# Backup database
docker exec postgres-container pg_dump -U postgres labelstudio > labelstudio_backup.sql

# Backup volume
docker run --rm -v labelstudio-data:/data -v $(pwd):/backup alpine tar czf /backup/labelstudio_volume.tar.gz /data
```

---

## 📚 Resources

- **Official Docs:** https://labelstud.io/guide/
- **Python SDK:** https://github.com/heartexlabs/label-studio-sdk
- **Templates:** https://labelstud.io/templates
- **Playground:** https://labelstud.io/playground/

---

## 🎉 Summary

You now have **Label Studio** added to your stack!

**Total Services: 13 (17 containers)**

### AI/ML Stack Now Includes:

- 🏷️ **Label Studio** - Data annotation & labeling
- 🧪 **MLflow** - Experiment tracking
- 🔍 **Qdrant** - Vector database
- 🔍 **ChromaDB** - Vector database
- 📊 **Metabase** - Data visualization
- 🗄️ **PostgreSQL** - Structured data

**Perfect for end-to-end ML workflows:** Label → Train → Track → Deploy 🚀
