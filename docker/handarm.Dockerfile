FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    MUJOCO_GL=osmesa

RUN apt-get update && apt-get install -y --no-install-recommends \
        libglib2.0-0 \
        libgl1 \
        libgomp1 \
        libosmesa6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && python -c "import numpy, cv2, mujoco, mediapipe"

COPY handarm ./handarm
COPY assets ./assets
COPY tests ./tests
COPY docker/handarm-entrypoint.sh /usr/local/bin/handarm-entrypoint

RUN chmod +x /usr/local/bin/handarm-entrypoint \
    && mkdir -p /app/recordings

ENTRYPOINT ["handarm-entrypoint"]
CMD ["ready"]
