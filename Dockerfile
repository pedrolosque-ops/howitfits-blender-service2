FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/blender:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip curl xz-utils ca-certificates \
      xvfb libgl1 libglu1-mesa libegl1 \
      libxrender1 libxext6 libxi6 libxxf86vm1 libxfixes3 \
      libxrandr2 libxkbcommon0 libxkbcommon-x11-0 libsm6 libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Blender 3.6 LTS
RUN curl -sSLo /tmp/blender.tar.xz https://download.blender.org/release/Blender3.6/blender-3.6.9-linux-x64.tar.xz && \
    tar -xJf /tmp/blender.tar.xz -C /opt && \
    mv /opt/blender-3.6.9-linux-x64 /opt/blender && \
    ln -s /opt/blender/blender /usr/local/bin/blender && \
    rm -f /tmp/blender.tar.xz

WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY server.py .

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fs "http://127.0.0.1:${PORT}/health" || exit 1

CMD ["sh", "-c", "uvicorn server:app --host 0.0.0.0 --port ${PORT}"]
