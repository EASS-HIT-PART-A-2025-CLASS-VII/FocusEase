from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, declarative_base
import jwt
from sqlalchemy import DateTime
from datetime import datetime

DATABASE_URL = "postgresql://postgres:password@task-db/tasks"
SECRET_KEY = "SECRET"  # Same as in user-service

# Database setup
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
Base = declarative_base()

class Task(Base):
    __tablename__ = 'tasks'
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    duration = Column(Integer)
    user_id = Column(String, index=True)
    due_date = Column(DateTime, nullable=True)  # ✅ New field

Base.metadata.create_all(engine)

app = FastAPI()

# Request model for creating tasks
class TaskRequest(BaseModel):
    title: str
    duration: int

# Utility function to get user ID from token
def get_user_id_from_token(authorization: str):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid or missing token")
    token = authorization.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return payload["id"]
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")

# Create task
@app.post("/tasks")
def create_task(request: TaskRequest, authorization: str = Header(None)):
    user_id = get_user_id_from_token(authorization)
    session = Session()
    task = Task(title=request.title, duration=request.duration, user_id=user_id)
    session.add(task)
    session.commit()
    session.close()
    return {"message": "Task created"}

# Get tasks for logged-in user
@app.get("/tasks")
def get_tasks(authorization: str = Header(None)):
    user_id = get_user_id_from_token(authorization)
    session = Session()
    tasks = session.query(Task).filter(Task.user_id == user_id).all()
    session.close()
    return tasks

# Root endpoint
@app.get("/")
def root():
    return {"message": "Task Service connected to users!"}
