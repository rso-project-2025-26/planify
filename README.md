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
