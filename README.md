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

| Service | Port |
|---------|------|
| PostgreSQL | 5432 |
| Kafka | 9092 |
| Zookeeper | 2181 |

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
cd service-template
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
# 🧰 How to Start Development of a New Microservice

## 1. Create a new branch

Every microservice MUST be developed in its own Git branch:

```bash
git checkout -b feature/user-service
```

---

## 2. Copy the template

```bash
cp -r service-template user-service
```

---

## 3. Update naming

### Update folder structure and package names:

```
com.planify.service_template → com.planify.user_service
```

### Update `pom.xml`:

```xml
<artifactId>user-service</artifactId>
<name>User Service</name>
```

### Update application.yml:

```yaml
spring:
  application:
    name: user-service

server:
  port: 8081
```

---

## 4. Start local development

```bash
./mvnw spring-boot:run
```

---
# 🔀 Git Workflow for Microservice Development

To keep the repo clean and consistent:

### ✔ Every microservice or feature = its own branch

Example:

```
feature/user-service
feature/event-service
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
