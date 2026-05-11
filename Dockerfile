FROM python:3.11-alpine AS builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache gcc musl-dev libffi-dev postgresql-dev

COPY requirements.txt .



RUN pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements.txt

# Part 2 Stage 2 

FROM python:3.11-alpine 

WORKDIR /app

ENV PYTHONDONTWRITECODE=1 \
    PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODEL=core.settings


# Secur
# just runtime not as build
RUN apk add --no-cache postgresql-dev && \ 
    addgroup -S django && \  
# dont run server as root
    adduser -S django -G django 
# cuz high secure

RUN chown -R django:django /app

COPY --from=builder /wheels /wheels   
# get Ready_lib from stage 1
COPY --from=builder /app . 
# EX. requirements.txt etc...


RUN pip install --no-cache /wheels/* && \
    rm -rf /wheel

COPY --chown=django:django . .

USER django

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
           CMD python manage.py health_check || exit 1



CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn core.wsgi:application --bind 0.0.0.0:8000 --timeout 120 --workers 3"]

# to fix (Error handling request (no URI read)) add --timeout 120

