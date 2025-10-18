# MLflow Documentation

> **Note:** Personal development setup. Not production-ready.

## 📦 Service Details

| Property      | Value                  |
| ------------- | ---------------------- |
| **Version**   | 2.16.2                 |
| **Port**      | 5000                   |
| **Container** | mlflow-container       |
| **Image**     | mlflow-postgres:2.16.2 |
| **Database**  | PostgreSQL (required)  |

---

## 🎯 What is MLflow?

MLflow is an open-source platform for managing the end-to-end machine learning lifecycle. It tracks experiments, packages code, and manages model deployment.

### Features:

- 🧪 **Experiment Tracking** - Log parameters, metrics, artifacts
- 📦 **Model Registry** - Version and manage models
- 🚀 **Model Deployment** - Deploy models to various platforms
- 📊 **Web UI** - Visualize and compare experiments
- 🔌 **Language Agnostic** - Python, R, Java, REST API
- 🤝 **Integration** - Works with TensorFlow, PyTorch, Scikit-learn

---

## Quick Start

```bash
# 1. Start PostgreSQL
make up postgresql

# 2. Create MLflow database
docker exec -it postgres-container psql -U postgres -c "CREATE DATABASE mlflow;"

# 3. Create shared network
docker network create local-dev-network

# 4. Start MLflow
make up mlflow

# 5. Access Web UI
# http://localhost:5000
```

---

## Configuration

### Environment Variables (`.env`)

```bash
# PostgreSQL connection
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
MLFLOW_DB=mlflow

# MLflow credentials (optional)
MLFLOW_USERNAME=admin
MLFLOW_PASSWORD=password
```

---

## 🔌 Using MLflow

### Python Client

```python
import mlflow

# Set tracking URI
mlflow.set_tracking_uri("http://localhost:5000")

# Create/set experiment
mlflow.set_experiment("my-experiment")

# Start a run
with mlflow.start_run():
    # Log parameters
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("epochs", 100)

    # Log metrics
    mlflow.log_metric("accuracy", 0.95)
    mlflow.log_metric("loss", 0.05)

    # Log artifacts
    mlflow.log_artifact("model.pkl")
    mlflow.log_artifact("config.json")

    # Log model
    mlflow.sklearn.log_model(model, "model")
```

### Training Script Example

```python
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Setup
mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("iris-classification")

# Load data
X, y = load_data()
X_train, X_test, y_train, y_test = train_test_split(X, y)

# Start run
with mlflow.start_run():
    # Parameters
    n_estimators = 100
    max_depth = 5

    mlflow.log_param("n_estimators", n_estimators)
    mlflow.log_param("max_depth", max_depth)

    # Train
    model = RandomForestClassifier(
        n_estimators=n_estimators,
        max_depth=max_depth
    )
    model.fit(X_train, y_train)

    # Evaluate
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)

    mlflow.log_metric("accuracy", accuracy)

    # Log model
    mlflow.sklearn.log_model(model, "model")

    print(f"Model accuracy: {accuracy}")
```

### Hyperparameter Tuning

```python
import mlflow
from sklearn.model_selection import GridSearchCV

mlflow.set_experiment("hyperparameter-tuning")

param_grid = {
    'n_estimators': [50, 100, 200],
    'max_depth': [3, 5, 10]
}

for n_est in param_grid['n_estimators']:
    for depth in param_grid['max_depth']:
        with mlflow.start_run():
            mlflow.log_param("n_estimators", n_est)
            mlflow.log_param("max_depth", depth)

            model = RandomForestClassifier(
                n_estimators=n_est,
                max_depth=depth
            )
            model.fit(X_train, y_train)

            accuracy = model.score(X_test, y_test)
            mlflow.log_metric("accuracy", accuracy)
```

---

## 📊 Web UI Features

Access http://localhost:5000

### Main Pages:

1. **Experiments** - View all experiments and runs
2. **Compare Runs** - Side-by-side comparison
3. **Models** - Model registry
4. **Artifacts** - Browse logged files

### Key Actions:

- 📈 **Plot metrics** - Visualize metric evolution
- 🔍 **Search runs** - Filter by parameters/metrics
- 📋 **Compare runs** - Side-by-side comparison table
- 📦 **Download artifacts** - Get logged files
- 🏷️ **Tag runs** - Organize with tags
- 📝 **Add notes** - Document experiments

---

## 🤖 Deep Learning Frameworks

### PyTorch

```python
import mlflow.pytorch

with mlflow.start_run():
    # Log parameters
    mlflow.log_param("lr", 0.001)
    mlflow.log_param("batch_size", 32)

    # Training loop
    for epoch in range(epochs):
        loss = train_epoch(model, dataloader)
        mlflow.log_metric("loss", loss, step=epoch)

    # Log model
    mlflow.pytorch.log_model(model, "model")
```

### TensorFlow/Keras

```python
import mlflow.tensorflow

with mlflow.start_run():
    mlflow.log_param("optimizer", "adam")
    mlflow.log_param("loss", "categorical_crossentropy")

    # Train
    history = model.fit(X_train, y_train, epochs=10)

    # Log metrics
    for epoch, (loss, acc) in enumerate(zip(
        history.history['loss'],
        history.history['accuracy']
    )):
        mlflow.log_metric("loss", loss, step=epoch)
        mlflow.log_metric("accuracy", acc, step=epoch)

    # Log model
    mlflow.tensorflow.log_model(model, "model")
```

---

## 📦 Model Registry

### Register Model

```python
# Log and register in one step
with mlflow.start_run():
    mlflow.sklearn.log_model(
        model,
        "model",
        registered_model_name="IrisClassifier"
    )

# Or register later
model_uri = f"runs:/{run_id}/model"
mlflow.register_model(model_uri, "IrisClassifier")
```

### Model Versions & Stages

```python
from mlflow.tracking import MlflowClient

client = MlflowClient()

# Transition model to staging
client.transition_model_version_stage(
    name="IrisClassifier",
    version=1,
    stage="Staging"
)

# Promote to production
client.transition_model_version_stage(
    name="IrisClassifier",
    version=1,
    stage="Production"
)
```

### Load Models

```python
# Load latest production model
model = mlflow.pyfunc.load_model(
    "models:/IrisClassifier/Production"
)

# Make predictions
predictions = model.predict(X_test)
```

---

## Integration

### With MinIO (Artifact Storage)

```python
import os

os.environ['MLFLOW_S3_ENDPOINT_URL'] = 'http://localhost:9000'
os.environ['AWS_ACCESS_KEY_ID'] = 'minioadmin'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'minioadmin'

# Artifacts will be stored in MinIO
with mlflow.start_run():
    mlflow.log_artifact("large_model.pkl")
```

### With Label Studio (Data → Training)

```python
# 1. Export labeled data from Label Studio
# 2. Train model with MLflow tracking
# 3. Register model
# 4. Use for predictions
```

---

## Data Persistence

- **Database:** PostgreSQL stores experiment metadata
- **Artifacts:** Stored in Docker volume `mlflow-artifacts`

---

## Troubleshooting

### Container Restarting

Check logs:

```bash
make logs mlflow
```

Common issues:

- PostgreSQL not running
- Network not created
- Database not created

### Cannot Connect to PostgreSQL

Ensure PostgreSQL is on the same network:

```bash
docker network inspect local-dev-network
```

---

## Resources

- **Docs:** https://mlflow.org/docs/latest/index.html
- **GitHub:** https://github.com/mlflow/mlflow
- **Python API:** https://mlflow.org/docs/latest/python_api/index.html

---

**Need help?** Check the [main README](../README.md) or [MLflow documentation](https://mlflow.org/docs/).
