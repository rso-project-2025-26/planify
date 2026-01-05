# Planify — Cloud-Based Event Management System

Planify is a cloud-native, microservices-based event management platform designed to simplify and centralize event planning. From small meetings to large conferences, Planify enables users to create, organize, and manage events with comprehensive features for guest management, location booking, notifications, and analytics.

Built with modern cloud technologies, Planify demonstrates a production-ready microservices architecture with event-driven communication, distributed monitoring, and automated CI/CD pipelines.

---

## Overview

Planify is built as a distributed system following microservices architecture principles:

- 6 Backend Microservices (Java 21 + Spring Boot)
- 1 Frontend Application (Angular 17 + Angular Material)
- Event-Driven Architecture (Apache Kafka)
- Cloud-Native Deployment (Kubernetes + Helm + Azure AKS)
- Comprehensive Monitoring (Prometheus + Grafana + ELK Stack)
- OAuth2 Authentication (Keycloak)

The system is designed for scalability, resilience, and observability, implementing industry best practices for distributed systems.

---

## Features

### Event Management
- Create, edit, and delete events with custom agendas
- Event lifecycle management (draft, published, cancelled, completed)
- Location selection and real-time availability checking
- Public and private event visibility

### Guest Management
- Invitation system with RSVP tracking (accepted, declined, maybe)
- Real-time guest list updates
- Automated invitation emails
- Check-in tracking

### Location Booking
- Real-time location availability checking via gRPC
- Time slot conflict detection
- Booking confirmation and status tracking

### Notifications
- Multi-channel notifications (email, in-app, planned: SMS)
- Real-time WebSocket updates
- Customizable notification templates
- Event change notifications

### Organization Management
- Multi-tenancy with organization isolation
- Role-based access control (Guest, Organizer, Admin)
- Organization member management
- Join requests and invitations

### Analytics & Reporting
- Real-time event metrics (RSVPs, attendance, check-ins)
- User activity tracking
- REST and GraphQL APIs for data querying
- Integration with Grafana dashboards

### Security & Authentication
- OAuth2/OIDC authentication via Keycloak
- JWT token-based authorization
- Role-based access control (RBAC)
- Secure inter-service communication

---

## System Architecture

### Microservices

| Service | Port | Description | Technology Highlights |
|---------|------|-------------|----------------------|
| **event-manager-service** | 8081 | Core event CRUD, guest lists | gRPC client, Kafka producer |
| **user-service** | 8082 | User management, organizations, roles | REST API, Keycloak integration |
| **notification-service** | 8083 | Multi-channel notifications | WebSocket, SendGrid, Kafka |
| **analytics-service** | 8084 | Metrics and reporting | REST + GraphQL APIs |
| **guest-service** | 8085 | RSVP management, invitations | Kafka consumer/producer |
| **booking-service** | 8086 | Location reservations | gRPC server, REST API |
| **planify-web** | 80 | Angular frontend | Angular 17, Material UI |

### Communication Patterns

#### Synchronous Communication
- REST APIs for client-service and service-service communication
- gRPC for high-performance internal service calls (booking service)
- GraphQL for flexible analytics queries

#### Asynchronous Communication
- Kafka topics for event-driven messaging
- WebSocket for real-time notifications
- Event sourcing for audit trails

#### Key Kafka Topics
- event-created, event-updated, event-deleted
- guest-invited, guest-removed
- rsvp-accepted, rsvp-declined
- booking-created, booking.events
- user.join-request-sent, user.join-request-responded
- user.invitation-sent, user.invitation-responded

### Data Flow Example

```
1. User creates event (Frontend → event-manager-service)
2. Event manager checks location availability (gRPC → booking-service)
3. Booking service confirms availability
4. Event manager creates event, publishes event-created (Kafka)
5. Notification service receives event, sends emails (Kafka consumer)
6. Analytics service records metrics (Kafka consumer)
7. Frontend receives real-time update (WebSocket)
```

---

## Technology Stack

### Backend Services
- **Java 21** - Programming language
- **Spring Boot 3.5.7** - Application framework
- **Spring Cloud** - Microservices patterns
- **Spring Data JPA + Hibernate** - ORM
- **Spring Security + OAuth2** - Security
- **gRPC + Protobuf** - High-performance RPC
- **Apache Kafka** - Event streaming
- **Resilience4j** - Fault tolerance (circuit breakers, retry, bulkheads)

### Frontend
- **Angular 17** - Web framework
- **TypeScript 5.2** - Type-safe JavaScript
- **Angular Material** - UI components
- **RxJS** - Reactive programming
- **Keycloak-js** - Authentication client

### Data Layer
- **PostgreSQL 16** - Primary database (one database, separate schemas per service)
- **Flyway** - Database migrations
- **HikariCP** - Connection pooling

### Infrastructure
- **Docker** - Containerization
- **Kubernetes 1.28+** - Orchestration
- **Helm 3** - Package management
- **Nginx Ingress** - API Gateway
- **cert-manager** - TLS certificate management

### Monitoring & Logging
- **Prometheus** - Metrics collection
- **Grafana** - Metrics visualization
- **Elasticsearch** - Log storage
- **Kibana** - Log visualization
- **Fluentd** - Log aggregation
- **Micrometer** - Metrics instrumentation

### Authentication & Authorization
- **Keycloak 24** - Identity and access management
- **OAuth2 + OIDC** - Authentication protocols
- **JWT** - Token format

### Cloud Platform
- **Microsoft Azure** - Cloud provider
- **Azure Kubernetes Service (AKS)** - Managed Kubernetes
- **Azure Container Registry** - Docker registry alternative
- **GitHub Container Registry (GHCR)** - Docker image storage

### CI/CD
- **GitHub Actions** - CI/CD pipelines
- **Maven** - Java build tool
- **npm** - Node.js package manager

---

## Quick Start

### Prerequisites

- Docker Desktop 24.x or higher
- kubectl 1.28 or higher
- Helm 3.x or higher
- Java 21 (for local service development)
- Node.js 18 + npm (for frontend development)
- Git

### 1. Clone the Repository

```bash
git clone https://github.com/rso-project-2025-26/planify.git
cd planify
```

### 2. Start Local Infrastructure

```bash
docker compose up -d
```

This starts:
- PostgreSQL (port 5432)
- Kafka (port 9092)
- Zookeeper (port 2181)
- Keycloak (port 9080)

### 3. Verify Infrastructure

Check PostgreSQL:

```bash
docker exec -it planify-postgres psql -U planify -d planify -c "SELECT 1;"
```

Expected output:

```
 ?column?
----------
        1
```

Check Kafka:

```bash
docker exec -it planify-kafka kafka-topics.sh --list --bootstrap-server localhost:9092
```

Check Keycloak:

```bash
curl http://localhost:9080/health
```

### 4. Access Services

Once deployed, services are available at:

| Service | URL | Credentials |
|---------|-----|-------------|
| Keycloak Admin | http://localhost:9080 | admin / admin |
| PostgreSQL | localhost:5432 | planify / planify |
| Kafka | localhost:9092 | - |

---

## Infrastructure Components

### PostgreSQL Database

Single Database, Multiple Schemas:
- auth - user-service data
- event_manager - event-manager-service data
- guest - guest-service data
- booking - booking-service data
- notification - notification-service data
- analytics - analytics-service data
- keycloak - Keycloak authentication data

Configuration:
- User: planify
- Password: planify
- Database: planify
- Port: 5432

Initialization:
Database schemas are created automatically via Flyway migrations when each service starts.

### Apache Kafka

Message Broker for Event-Driven Architecture

Pre-configured Topics:
- event-created, event-updated, event-deleted
- booking-created, booking.events
- notification-sent

Configuration:
- Bootstrap servers: localhost:9092 (local), kafka-service:9092 (K8s)
- Zookeeper: localhost:2181

### Keycloak

Authentication & Authorization Server

Pre-configured Realm: planify

Clients:
- planify-frontend - Public client for Angular app
- Service clients configured for inter-service communication

Roles:
- UPORABNIK - Standard user
- ORGANISER - Event organizer
- ORG_ADMIN - Organization administrator
- ADMINISTRATOR - System administrator

Configuration:
- Admin URL: http://localhost:9080
- Admin credentials: admin / admin
- Realm config: realm-config.json (auto-imported)

### Prometheus

Metrics Collection

Scrapes metrics from:
- All Spring Boot services (/actuator/prometheus)
- Kubernetes cluster metrics
- Custom business metrics

Configuration:
- Web UI: /prometheus (via ingress)
- Scrape interval: 15s
- Retention: 15 days

### Grafana

Metrics Visualization

Pre-configured Dashboards:
- Service health and performance
- Event metrics (RSVPs, attendance)
- User engagement
- System resources (CPU, memory, network)

Configuration:
- Web UI: /grafana (via ingress)
- Default credentials: admin / admin
- Datasource: Prometheus (auto-configured)

### ELK Stack (Elasticsearch, Logstash, Kibana)

Centralized Logging

Fluentd - Log aggregation from all services \
Elasticsearch - Log storage and indexing \
Kibana - Log visualization and search

Configuration:
- Namespace: planify-logging
- Retention: 7 days
- Kibana UI: accessible via ingress

### Nginx Ingress Controller

API Gateway and Routing

Routes:
- /api/events/\* - event-manager-service
- /api/auth/\*, /api/users/\*, /api/organizations/\* - user-service
- /api/guests/\* - guest-service
- /api/booking/\*, /api/locations/\* - booking-service
- /api/notifications/\* - notification-service
- /grafana/\* - Grafana
- /prometheus/\* - Prometheus
- /keycloak/\* -Keycloak
- /\* - planify-web (frontend)

---

## Local Development

### Running Individual Services

Each microservice can be run locally:

```bash
# Clone service repository
git clone https://github.com/rso-project-2025-26/[service-name].git
cd [service-name]

# Run with Maven
./mvnw spring-boot:run

# Or build and run JAR
./mvnw clean package
java -jar target/*.jar
```

Required Environment Variables:
```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/planify
SPRING_DATASOURCE_USERNAME=planify
SPRING_DATASOURCE_PASSWORD=planify
SPRING_KAFKA_BOOTSTRAP_SERVERS=localhost:9092
OAUTH2_ISSUER_URI=http://localhost:9080/realms/planify
```

### Running Frontend Locally

```bash
# Clone frontend repository
git clone https://github.com/rso-project-2025-26/planify-web.git
cd planify-web

# Install dependencies
npm install

# Start development server
npm start
```

Frontend runs on http://localhost:4200 with API proxy to backend services.

### Docker Development

Build and run a service in Docker:

```bash
# Build image
docker build -t planify/[service-name]:dev .

# Run container
docker run -p 8081:8081 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/planify \
  -e SPRING_KAFKA_BOOTSTRAP_SERVERS=host.docker.internal:9092 \
  -e OAUTH2_ISSUER_URI=http://host.docker.internal:9080/realms/planify \
  planify/[service-name]:dev
```

---

## Kubernetes Deployment

### Namespaces

The system uses separate namespaces for environment isolation:

```bash
kubectl apply -f namespaces.yaml
```

Creates:
- `planify-dev` - Development environment
- `planify-main` - Production environment
- `planify-logging` - Centralized logging

### Infrastructure Deployment

Deploy core infrastructure components:

```bash
# PostgreSQL
kubectl apply -f postgres.yaml -n planify-dev

# Kafka & Zookeeper
kubectl apply -f kafka.yaml -n planify-dev

# Keycloak
kubectl apply -f keycloak.yaml -n planify-dev
kubectl apply -f keycloak-init-job.yaml -n planify-dev

# Monitoring
kubectl apply -f prometheus.yaml -n planify-dev
kubectl apply -f grafana.yaml -n planify-dev

# Logging
kubectl apply -f elasticsearch.yaml -n planify-logging
kubectl apply -f kibana.yaml -n planify-logging
kubectl apply -f fluentd.yaml -n planify-logging

# Ingress
kubectl apply -f ingress.yaml -n planify-dev
```

### Service Deployment via Helm

Each microservice has its own Helm chart:

```bash
# Deploy user-service
helm install user ./helm/user -n planify-dev

# Deploy event-manager-service
helm install event-manager ./helm/event-manager -n planify-dev

# Deploy all services
helm install guest ./helm/guest -n planify-dev
helm install booking ./helm/booking -n planify-dev
helm install notification ./helm/notification -n planify-dev
helm install analytics ./helm/analytics -n planify-dev
helm install planify ./helm/web -n planify-dev
```

### Verify Deployment

```bash
# Check pods
kubectl get pods -n planify-dev

# Check services
kubectl get svc -n planify-dev

# Check ingress
kubectl get ingress -n planify-dev

# View logs
kubectl logs -f deployment/event-manager-service -n planify-dev
```

---

## Azure Cloud Setup

### Prerequisites

- Azure CLI installed (`az`)
- Azure subscription with appropriate permissions
- kubectl configured

### 1. Login to Azure

```bash
az login
az account show
```

### 2. Select Subscription

```bash
# List subscriptions
az account list --output table

# Set active subscription
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 3. Create Resource Group

```bash
az group create \
  --name planify-rg \
  --location germanywestcentral
```

### 4. Create AKS Cluster

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

Cluster Configuration:
- VM Size: Standard_B2ps_v2 (cost-optimized for development)
- Auto-scaling: 1-2 nodes
- OS Disk: 30 GB
- Max pods per node: 30

### 5. Connect kubectl to Cluster

```bash
az aks get-credentials \
  --resource-group planify-rg \
  --name planify-cluster

# Verify connection
kubectl get nodes
```

### 6. Install Nginx Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace kube-system \
  --set controller.service.loadBalancerIP="<YOUR_STATIC_IP>"
```

### 7. Deploy Application

```bash
# Create namespaces
kubectl apply -f namespaces.yaml

# Deploy infrastructure
kubectl apply -f postgres.yaml -n planify-main
kubectl apply -f kafka.yaml -n planify-main
kubectl apply -f keycloak.yaml -n planify-main

# Deploy monitoring
kubectl apply -f prometheus.yaml -n planify-main
kubectl apply -f grafana.yaml -n planify-main

# Deploy logging
kubectl apply -f elasticsearch.yaml -n planify-logging
kubectl apply -f kibana.yaml -n planify-logging
kubectl apply -f fluentd.yaml -n planify-logging

# Deploy services via Helm
helm install user-service ./helm/user -n planify-main
helm install event-manager-service ./helm/event-manager -n planify-main
# ... (repeat for all services)

# Deploy ingress
kubectl apply -f ingress.yaml -n planify-main
```

### 8. Cluster Management

Start and stop cluster (to save costs):
```bash
# Stop cluster
az aks stop --resource-group planify-rg --name planify-cluster

# Start cluster
az aks start --resource-group planify-rg --name planify-cluster
```

Delete cluster:
```bash
az aks delete \
  --resource-group planify-rg \
  --name planify-cluster \
  --yes
```

---

## Monitoring & Logging

### Prometheus Metrics

Access Prometheus:
- Local: http://localhost:9090
- K8s: http://[INGRESS-IP]/prometheus

Key Metrics:
- http_server_requests_seconds - HTTP request latencies
- jvm_memory_used_bytes - JVM memory usage
- kafka_consumer_records_consumed_total - Kafka message consumption
- Custom business metrics (events created, RSVPs, etc.)

Query Examples:
```promql
# Request rate per service
rate(http_server_requests_seconds_count[5m])

# 95th percentile latency
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))

# JVM heap usage
jvm_memory_used_bytes{area="heap"}
```

### Grafana Dashboards

Access Grafana:
- Local: http://localhost:3000
- K8s: http://[INGRESS-IP]/grafana
- Default credentials: admin / admin

Available Dashboards:
- Service Overview - Health status, request rates, error rates
- Event Metrics - Events created, RSVPs, attendance
- User Engagement - Active users, invitation acceptance rates
- Infrastructure - CPU, memory, network, disk usage
- Kafka - Message throughput, consumer lag

### ELK Stack Logging

Access Kibana:
- K8s: http://[INGRESS-IP]/kibana

Log Collection:
- Fluentd agents run on each node
- Collects logs from all pods
- Forwards to Elasticsearch
- Indexed by service, namespace, and timestamp

Log Search Examples:
```
# All logs from event-manager-service
kubernetes.namespace_name:"planify-main" AND kubernetes.labels.app:"event-manager-service"

# Error logs across all services
kubernetes.namespace_name:"planify-main" AND log:"ERROR"

# Logs for specific event ID
log:"eventId=550e8400-e29b-41d4-a716-446655440000"
```

### Health Checks

All services expose health endpoints via Spring Boot Actuator:

```bash
# Service health
curl http://[SERVICE-URL]/actuator/health

# Liveness probe
curl http://[SERVICE-URL]/actuator/health/liveness

# Readiness probe
curl http://[SERVICE-URL]/actuator/health/readiness

# Metrics
curl http://[SERVICE-URL]/actuator/prometheus
```

---

## CI/CD Pipeline

### GitHub Actions Workflows

Each repository has a CI/CD workflow that automatically:

1. Build & Test - Compile code, run unit tests
2. Build Docker Image - Create container image
3. Push to Registry - Push to GitHub Container Registry (ghcr.io)
4. Deploy to Kubernetes - Update deployment in appropriate namespace
5. Create Release - Tag and create GitHub release (main branch only)

### Workflow Triggers

- Push to dev - Deploy to planify-dev namespace
- Push to main - Deploy to planify-main namespace, create release
- Pull Request - Run tests only

### Manual Deployment

After CI/CD builds and pushes images, trigger deployment manually:

```bash
# Restart deployment to pull latest image
kubectl rollout restart deployment/event-manager-service -n planify-dev

# Check rollout status
kubectl rollout status deployment/event-manager-service -n planify-dev

# View rollout history
kubectl rollout history deployment/event-manager-service -n planify-dev
```

### Image Registries

GitHub Container Registry (GHCR):
- Registry: ghcr.io/rso-project-2025-26
- Authentication: GitHub token
- Images tagged with branch name and commit SHA

Accessing Private Images:
```bash
# Create registry secret
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<GITHUB_USERNAME> \
  --docker-password=<GITHUB_TOKEN> \
  -n planify-dev
```

---

## Service Repositories

### Backend Microservices

| Service | Repository | Documentation |
|---------|------------|---------------|
| User Service | [planify-user-service](https://github.com/rso-project-2025-26/planify-user-service) | [README](https://github.com/rso-project-2025-26/planify-user-service/blob/main/README.md) |
| Event Manager | [planify-event-manager-service](https://github.com/rso-project-2025-26/planify-event-manager-service) | [README](https://github.com/rso-project-2025-26/planify-event-manager-service/blob/main/README.md) |
| Guest Service | [planify-guest-service](https://github.com/rso-project-2025-26/planify-guest-service) | [README](https://github.com/rso-project-2025-26/planify-guest-service/blob/main/README.md) |
| Booking Service | [planify-booking-service](https://github.com/rso-project-2025-26/planify-booking-service) | [README](https://github.com/rso-project-2025-26/planify-booking-service/blob/main/README.md) |
| Notification Service | [planify-notification-service](https://github.com/rso-project-2025-26/planify-notification-service) | [README](https://github.com/rso-project-2025-26/planify-notification-service/blob/main/README.md) |
| Analytics Service | [planify-analytics-service](https://github.com/rso-project-2025-26/planify-analytics-service) | [README](https://github.com/rso-project-2025-26/planify-analytics-service/blob/main/README.md) |

### Frontend

| Component | Repository | Documentation |
|-----------|------------|---------------|
| Web Application | [planify-web](https://github.com/rso-project-2025-26/planify-web) | [README](https://github.com/rso-project-2025-26/planify-web/blob/main/README.md) |

### Infrastructure

| Component | Repository | Documentation |
|-----------|------------|---------------|
| Infrastructure & Deployment | [planify](https://github.com/rso-project-2025-26/planify) | This README |

---

## Development Workflow

### Git Branching Strategy

Main Branches:
- main - Production-ready code
- dev - Development integration branch

Feature Branches:
- feature/[feature-name] - New features
- fix/[bug-name] - Bug fixes
- docs/[doc-name] - Documentation updates

### Development Process

1. Create Feature Branch
```bash
git checkout -b feature/user-profile
```

2. Develop and Test Locally
```bash
# Make changes
# Run tests: ./mvnw test
# Commit changes
git add .
git commit -m "feat: add user profile endpoint"
```

3. Push to Remote
```bash
git push -u origin feature/user-profile
```

4. Create Pull Request
- Open PR: feature/user-profile → dev
- Request code review
- CI/CD runs automatically

5. Merge to Dev
- After approval, merge to dev
- Automatic deployment to planify-dev namespace

6. Release to Production
- Create PR: dev → main
- After approval, merge to main
- Automatic deployment to planify-main namespace
- GitHub release created automatically

### Versioning

Semantic Versioning (SemVer): MAJOR.MINOR.PATCH

Examples:
- 1.0.0 - Initial release
- 1.1.0 - New feature added
- 1.1.1 - Bug fix

Development Versions:
- dev branch: 1.3.0-SNAPSHOT
- main branch: 1.3.0 (with git tag v1.3.0)

### Code Review Guidelines

- All code must be reviewed before merging
- Run tests locally before creating PR
- Update documentation if needed
- Follow existing code style and conventions
- Write meaningful commit messages

---

## Troubleshooting

### Common Issues

#### PostgreSQL Connection Refused

Symptoms: Services can't connect to PostgreSQL

Solution:
```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Check PostgreSQL logs
docker logs planify-postgres

# Verify connection
docker exec -it planify-postgres psql -U planify -d planify -c "SELECT 1;"

# If using K8s
kubectl get pods -n planify-dev | grep postgres
kubectl logs postgres-0 -n planify-dev
```

#### Kafka Connection Issues

Symptoms: Services can't produce/consume Kafka messages

Solution:
```bash
# Check Kafka is running
docker ps | grep kafka

# Check Kafka topics
docker exec -it planify-kafka kafka-topics.sh --list --bootstrap-server localhost:9092

# Create topic manually if needed
docker exec -it planify-kafka kafka-topics.sh \
  --create --topic event-created \
  --bootstrap-server localhost:9092 \
  --partitions 1 --replication-factor 1
```

#### Keycloak Authentication Fails

Symptoms: Login redirects fail, token validation errors

Solution:
```bash
# Check Keycloak is running
curl http://localhost:9080/health

# Verify realm exists
# Login to http://localhost:9080 (admin/admin)
# Check "planify" realm exists

# Re-import realm if needed
docker compose down keycloak
docker compose up -d keycloak
```

#### Service Won't Start in Kubernetes

Symptoms: Pod in CrashLoopBackOff or ImagePullBackOff

Solution:
```bash
# Check pod status
kubectl get pods -n planify-dev

# View pod logs
kubectl logs [POD-NAME] -n planify-dev

# Describe pod for events
kubectl describe pod [POD-NAME] -n planify-dev

# Common fixes:
# 1. Check image exists in registry
# 2. Verify image pull secret is configured
# 3. Check resource limits
# 4. Verify environment variables
```

#### Ingress Not Routing Correctly

Symptoms: 404 errors, services unreachable

Solution:
```bash
# Check ingress controller is running
kubectl get pods -n kube-system | grep ingress

# Check ingress configuration
kubectl get ingress -n planify-dev
kubectl describe ingress planify-ingress -n planify-dev

# Verify services are running
kubectl get svc -n planify-dev

# Check service endpoints
kubectl get endpoints -n planify-dev
```

#### High Memory Usage

Symptoms: Services crashing due to OOM (Out of Memory)

Solution:
```bash
# Check pod memory usage
kubectl top pods -n planify-dev

# Increase memory limits in Helm values:
# Edit values.yaml:
resources:
  limits:
    memory: "1Gi"  # Increase from 512Mi

# Upgrade deployment
helm upgrade event-manager-service ./helm/event-manager -n planify-dev
```

### Debugging Tips

View Live Logs:
```bash
# Single service
kubectl logs -f deployment/event-manager-service -n planify-dev

# All services
kubectl logs -f -l app.kubernetes.io/instance=planify -n planify-dev
```

Execute Commands in Pod:
```bash
kubectl exec -it [POD-NAME] -n planify-dev -- /bin/sh
```

Port Forward for Local Access:
```bash
# Access service locally
kubectl port-forward svc/event-manager-service 8081:8081 -n planify-dev

# Access PostgreSQL
kubectl port-forward svc/postgres-service 5432:5432 -n planify-dev
```

Check Database Migrations:
```bash
# View Flyway migration history
kubectl exec -it postgres-0 -n planify-dev -- \
  psql -U planify -d planify -c "SELECT * FROM event_manager.flyway_schema_history;"
```

---

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Angular Documentation](https://angular.io/docs)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [Kafka Documentation](https://kafka.apache.org/documentation/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

---

## License

This project is developed as part of the RSO (Razvoj na osnovi storitev) course at the University of Ljubljana, Faculty of Computer and Information Science.

---

## Team

University of Ljubljana - Faculty of Computer and Information Science  
Course: RSO 2025/2026

GitHub Organization: [rso-project-2025-26](https://github.com/rso-project-2025-26)

---

## Support

For questions or issues:
1. Check this documentation and service-specific READMEs
2. Search existing GitHub issues in relevant repositories
3. Create a new issue with detailed description and logs
4. Contact team members via university communication channels