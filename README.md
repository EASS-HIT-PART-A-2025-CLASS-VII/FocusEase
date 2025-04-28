# 🎯 FocusEase – Smart ADHD Task Manager

---

## 📌 Project Purpose
FocusEase is an intelligent task management app designed for individuals with ADHD, students, and busy professionals.
It helps manage tasks effectively with an emphasis on:
- Focus
- Smart scheduling
- Easy uploads (screenshots to tasks)
- Notifications
- Analytics
- Light/Dark modes
- In-app calendar (planned)
- Music connection (planned)

---

## ⚙️ Tech Stack

- **Frontend**: Flutter (cross-platform: Android, iOS, Web, Desktop)
- **Backend Services**:
  - User Service (FastAPI + JWT)
  - Media Upload Service (FastAPI + OCR)
  - Task Service (FastAPI + Smart Scheduling)
- **Authentication**: JWT tokens
- **Containerization**: Docker Compose (multi-container setup)
- **Database**: PostgreSQL
- **Storage**: Local File Storage (planned: Cloud S3)
- **Notifications**: Local device notifications

---

## 🏗️ Architecture Overview

The app follows a **microservices architecture**:
- Independent services for user management, media uploads, and task management
- Flutter frontend communicates with services via REST APIs
- Docker manages service orchestration

---

## 📋 Features (Current)

- [x] Secure user login and registration (JWT)
- [x] Upload screenshots and convert them into tasks
- [x] Manual task creation (with due date and reminders)
- [x] Light & Dark theme toggle
- [x] Smart task sorting based on deadlines and durations
- [x] Basic analytics dashboard (task completion, focus time)
- [x] Spotify connection (mock, real OAuth planned)

---

## 🚀 Features (Coming Soon)

- 🔥 Real Google Calendar sync
- 🔥 Spotify real OAuth login + Focus playlists
- 🔥 AI-based smart task prioritization
- 🔥 Better cross-device support (mobile/web/desktop)
- 🔥 Full testing (unit + integration)
- 🔥 Firebase Hosting (for production)

---

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK installed
- Docker Desktop installed (for backend services)
- Git installed

### Setup Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/EASS-HIT-PART-A-2025-CLASS-VII/FocusEase.git
   cd FocusEase
   ```

2. **Run the backend (Docker Compose):**
   ```bash
   docker-compose up
   ```

3. **Run the Flutter app:**
   ```bash
   flutter pub get
   flutter run
   ```

---

## 📡 API Endpoints (Backend)

| Method | Endpoint          | Description                    |
|:------:|--------------------|--------------------------------|
| POST   | `/register`         | Create a new user              |
| POST   | `/login`            | Authenticate and get token     |
| POST   | `/upload`           | Upload a screenshot            |
| GET    | `/tasks`            | Fetch user tasks (authorized)  |
| POST   | `/tasks`            | Create a manual task           |

---

## 👀 Screenshots

- Login, Registration, Tasks, Upload, Analytics, Spotify Connect, Dark Mode (see `/screenshots` folder)

---

## 🙏 Credits
Created with ❤️ for the Engineering of Advanced Software Solutions course (HIT).

---

## 💬 Questions?
Let me know! (Ready to continue immediately)

---
