(Error handling request (no URI read)) 

CMD ["sh", "-c", "python manage.py migrate && gunicorn core.wsgi:application --bind 0.0.0.0:8000 --timeout 120 --workers 3"]

# to fix (Error handling request (no URI read)) add --timeout 120


healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/"] # Request Real Page
  interval: 30s
  timeout: 10s
  retries: 3
