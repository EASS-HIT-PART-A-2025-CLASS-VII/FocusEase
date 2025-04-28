from fastapi import FastAPI, UploadFile, File, Header, HTTPException
import requests

app = FastAPI()

TASK_SERVICE_URL = "http://task-service:8000/tasks"

# Simulate extracting task data from image
def extract_task_from_image(filename):
    # Dummy extraction logic (we can improve later with real OCR!)
    title = filename.split(".")[0].replace("_", " ").title()
    duration = 30  # Default duration
    return title, duration

@app.post("/upload")
async def upload_image(file: UploadFile = File(...), authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Missing Authorization header")

    contents = await file.read()
    filename = file.filename

    # Simulate task extraction from filename
    title, duration = extract_task_from_image(filename)

    # Send task creation request to task-service
    task_data = {
        "title": title,
        "duration": duration
    }

    headers = {
        "Authorization": authorization,
        "Content-Type": "application/json"
    }

    response = requests.post(TASK_SERVICE_URL, json=task_data, headers=headers)

    if response.status_code != 200:
        return {"error": "Failed to create task", "details": response.text}

    return {"message": "Image processed, task created!", "task": task_data}

@app.get("/")
def root():
    return {"message": "Media Service connected to task service!"}
