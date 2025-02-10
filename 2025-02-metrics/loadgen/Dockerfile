FROM python:3-slim

WORKDIR /app
COPY highload.py .
RUN pip install requests

CMD ["python", "highload.py"]