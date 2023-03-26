# app Dockerfile
FROM python:3.8.12-slim-buster as python-builder
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/
ENV TOKEN_PATH /app/.telegramToken
CMD ["python3", "bot.py"]
