# focusease

🎯 FocusEase – Smart ADHD Task Manager
📌 Project Purpose
FocusEase is an intelligent task management system developed for the Engineering of Advanced Software Solutions course at HIT.
The app is specially designed to support users with ADHD by combining task scheduling, media uploads, smart notifications, productivity analytics, and motivational music integration — all in a seamless, distraction-minimizing environment.

⚙ Tech Stack
Frontend: Flutter (Cross-platform Mobile/Web)

Backend Microservices:

User Service: FastAPI + JWT Authentication

Task Service: FastAPI + MongoDB

Media Upload Service: FastAPI + OCR + Task Auto-creation

Containerization: Docker Compose

Database: MongoDB

Authentication: JWT (JSON Web Tokens)

Notifications: Local Notifications (Flutter Local Notifications plugin)

Testing: Pytest (for backend services)

🏗 Architecture Overview
The system follows a microservices architecture with the following services:

user-service: handles registration, login, and JWT generation

task-service: manages tasks CRUD and smart scheduling

media-service: receives uploaded images, extracts text, and auto-generates tasks

Flutter frontend communicates through HTTP APIs between services

MongoDB for user and task data storage

All services run in isolated Docker containers via docker-compose

✨ Current Features
🔵 Register and login system with JWT authentication

🔵 Create manual tasks with custom due dates and durations

🔵 Upload images/screenshots to auto-generate tasks using OCR

🔵 Local notifications with configurable reminder times (5 min, 15 min, 30 min, 1 hour, etc.)

🔵 Daily productivity summary (analytics dashboard)

🔵 Smart task sorting (AI-like) by due date and duration

🔵 Light/Dark theme toggle

🔵 Spotify mock connect for motivation

🔵 Secure token persistence across app restarts

🔵 Fully responsive across Web, Android, and iOS (using Flutter)

🚀 Coming Soon
🎯 Calendar View with Google Calendar sync

🎯 AI-generated smart task suggestions

🎯 Real Spotify integration for focus music

🎯 Advanced gamified productivity streaks

🎯 Push notifications for critical deadlines

🛠 Installation & Setup
⚙ Prerequisites
Docker and Docker Compose installed

Flutter SDK installed (for frontend app)

Python 3.11+ installed (for backend microservices)

Git (for version control)

🔥 Clone the Repository
bash
Copy
Edit
git clone https://github.com/EASS-HIT-PART-A-2025-CLASS-VII/FocusEase.git
cd FocusEase
🐳 Run Microservices with Docker
From the root directory:

bash
Copy
Edit
docker compose up --build
This spins up:

user-service on port 3000

task-service on port 8000

media-service on port 8100

MongoDB on port 27017

🖥 Run Flutter Frontend
In another terminal:

bash
Copy
Edit
cd frontend
flutter pub get
flutter run -d chrome
or

bash
Copy
Edit
flutter run -d windows
flutter run -d android
🌐 API Endpoints

Method	Endpoint	Service	Description
POST	/register	user-service	Register a new user
POST	/login	user-service	Authenticate a user
GET	/tasks	task-service	Retrieve all tasks
POST	/tasks	task-service	Create a manual task
POST	/upload	media-service	Upload image to generate tasks
📈 Folder Structure
plaintext
Copy
Edit
FocusEase/
├── frontend/               # Flutter App
│   ├── lib/
│   │   ├── screens/         # Screens (Login, Tasks, Media, Manual Task, Spotify Connect)
│   │   ├── services/        # HTTP services
│   │   └── utils/           # Notifications, etc
│   └── pubspec.yaml         # Flutter dependencies
│
├── backend/
│   ├── user-service/        # FastAPI JWT User Auth Service
│   ├── task-service/        # FastAPI Task CRUD Service
│   ├── media-service/       # FastAPI Upload & OCR Service
│   └── docker-compose.yml   # Docker Compose file
│
├── database/                # MongoDB Volume
└── README.md                # Documentation (You Are Here)
