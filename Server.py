from fastapi import FastAPI
from fastapi.responses import JSONResponse
import subprocess

app = FastAPI()

@app.get("/")
async def root():
    return JSONResponse({"ok": True, "service": "blender-baseline"})

@app.get("/health")
async def health():
    return JSONResponse({"ok": True})

@app.get("/blender/version")
async def blender_version():
    try:
        out = subprocess.check_output(["blender", "--version"], text=True)
        return JSONResponse({"ok": True, "blender_version": out})
    except Exception as e:
        return JSONResponse({"ok": False, "error": str(e)}, status_code=500)
