# 🗓️ Planify – Cloud-Based Event Management System

Planify is a cloud-based application designed to simplify and centralize event planning.  
It enables users to **create, organize, and manage events** — from small meetings to large conferences — all in one place.  
The system is built using a **microservices architecture** and integrates multiple modern technologies for reliability, scalability, and ease of use.

---

## 🚀 Features

-   **Event Management** – Create, edit, and manage events with custom agendas, locations, and guest lists
-   **Guest Management** – RSVP handling, inbox notifications, and integration with personal calendars (iCalendar, Google Calendar)
-   **Booking System** – Real-time location booking, time slot management, and payment processing (Stripe integration)
-   **Notifications** – Automatic email, SMS, and push notifications (SendGrid, Twilio)
-   **Analytics** – Real-time dashboards and reporting (Prometheus, Grafana)
-   **Authentication** – Secure user authentication and authorization via Keycloak (OAuth2, OIDC)
-   **Scalability** – Dockerized microservices orchestrated with Kubernetes and deployed on Microsoft Azure

---

## 🧱 System Architecture

The Planify system is divided into several independent microservices:

| Service                   | Description                                                                |
| ------------------------- | -------------------------------------------------------------------------- |
| **user_service**          | Handles user registration, login, roles, and authentication via Keycloak   |
| **event_manager_service** | Core service for creating, updating, and managing events                   |
| **guest_service**         | Manages guest interactions, RSVPs, and notifications                       |
| **booking_service**       | Handles venue and service bookings, integrates with Stripe and Google Maps |
| **notification_service**  | Sends emails, SMS, and push notifications asynchronously via Kafka         |
| **analytics_service**     | Collects metrics and provides visual dashboards for event analytics        |

Communication between services uses **REST/gRPC** for synchronous calls and **Kafka** for event-driven asynchronous messaging.

---

## ⚙️ Setup & Development Environment

### 1. Clone the Repository

```bash
git clone https://github.com/<your-org>/planify.git
cd planify
```

### 2. Install System Tools

-   Docker Desktop
-   Java 21
-   Maven 3.9+
-   Node.js + npm

### 3. Start Infrastructure (PostgreSQL, Kafka, Zookeeper)

From the project root:

```bash
cd infrastructure
docker compose up -d
```

Services start on:

| Service    | Port |
| ---------- | ---- |
| PostgreSQL | 5432 |
| Kafka      | 9092 |
| Zookeeper  | 2181 |

Check PostgreSQL:

```bash
docker exec -it planify-postgres psql -U planify -d planify -c "SELECT 1;"
```

Expected:

```
1
```

---

### 4. Running a Microservice

Go to any microservice folder (example: `service-template`):

```bash
cd services/service-template
```

Run it using Maven:

```bash
./mvnw spring-boot:run
```

Or run the packaged JAR:

First we need to build it:

```bash
./mvnw clean install
```

Then we can run it:

```bash
java -jar target/service-template-0.0.1-SNAPSHOT.jar
```

---

### 5. Running a Service in Docker

Build the image:

```bash
docker build -t planify/service-template .
```

Run the container:

```bash
docker run -p 8080:8080 planify/service-template
```

## How to setup Azure environment

### 🔑 1. Log in to Azure

Open your terminal and sign in:

```bash
az login
```

### 🔍 2. Verify Login

Check that you are logged in:

```bash
az account show
```

If it shows your subscription details, you are logged in.

### 📌 3. Select the Correct Subscription

```bash
az account list --output table
```

If you have multiple Azure subscriptions:

```bash
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 🏗 4. Create the Resource Group

```bash
az group create \
  --name planify-rg \
  --location germanywestcentral
```

### 🧩 5. Create the AKS Kubernetes Cluster

```bash
az aks create \
  --resource-group planify-rg \
  --name planify-cluster \
  --node-count 1 \
  --node-vm-size Standard_B2ps_v2 \
  --enable-managed-identity \
  --generate-ssh-keys \
  --location germanywestcentral \
  --network-plugin azure \
  --node-osdisk-size 30 \
  --max-pods 30 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 2 \
  --tier free
```

### 🔗 6. Connect kubectl to the Cluster

Once the cluster is created, download credentials:

```bash
az aks get-credentials \
  --resource-group planify-rg \
  --name planify-cluster
```

Verify the connection:

```bash
kubectl get nodes
```

### 7. After the Cluster Is Set Up

Delete the cluster:

```bash
az aks delete \
  --resource-group planify-rg \
  --name planify-cluster \
  --yes
```

Start and stop the cluster:

```bash
az aks start --resource-group planify-rg --name planify-cluster
az aks stop --resource-group planify-rg --name planify-cluster
```

## Deployment Process

### Automatic (CI/CD)

1. Push code to `dev` or `main` branch
2. GitHub Actions automatically:
    - Builds the code
    - Runs tests
    - Creates Docker image
    - Pushes to GitHub Container Registry

### Manual Deployment Step

After GitHub Actions completes, deploy to Kubernetes:

```bash
# Deploy to development
kubectl rollout restart deployment/event-manager-service -n planify-dev

# Verify deployment
kubectl get pods -n planify-dev

# Check rollout status
kubectl rollout status deployment/event-manager-service -n planify-dev
```

## 🧰 How to Start Development of a New Microservice

### 1. Create a new branch

Every microservice MUST be developed in its own Git branch:

```bash
git checkout -b feature/user-service
```

---

### 2. Copy the template

```bash
cp -r service-template user-service
```

---

### 3. Update naming

#### Update folder structure and package names:

```
com.planify.service_template → com.planify.user_service
```

#### Update `pom.xml`:

```xml
<artifactId>user-service</artifactId>
<name>User Service</name>
```

#### Update application.yml:

```yaml
spring:
    application:
        name: user-service

server:
    port: 8081
```

---

### 4. Start local development

```bash
./mvnw spring-boot:run
```

---

## 🔀 Git Workflow for Microservice Development

To keep the repo clean and consistent:

### ✔ Every microservice or feature = its own branch

Example:

```
feature/user-service
feature/event-manager-service
feature/booking-db-schema
```

### ✔ When finished → create Pull Request into `dev` branch

1. Push your branch:

```bash
git push -u origin feature/user-service
```

2. Open a Pull Request **feature → dev**

3. Another team member must review & approve the PR

4. After approval → merge into `dev`

---

## 🔖 Versioning (short)

We use Semantic Versioning (SemVer): MAJOR.MINOR.PATCH (for example: 1.2.3).

-   Development (`dev` branch) uses `-SNAPSHOT` versions (e.g. `1.3.0-SNAPSHOT`).
-   Released code on `main` should have the release version without `-SNAPSHOT` (e.g. `1.3.0`) and a Git tag `v1.3.0`.

Typical release steps:

1. Create a release branch from `dev` (e.g. `release/v1.3.0`).
2. Remove the `-SNAPSHOT` suffix in all `pom.xml` files and commit.
3. Tag the release (`git tag -a v1.3.0 -m "Release v1.3.0"`) and push.
4. Merge the release branch into `main` (CI will build/tag images from the release).
5. Bump `dev` to the next snapshot (e.g. `1.4.0-SNAPSHOT`).

You can automate releases with Maven's release plugin (`mvn release:prepare release:perform`) or use `mvn versions:set` for simple bumps. See the project docs if you want fully automated GitHub Actions releases.
