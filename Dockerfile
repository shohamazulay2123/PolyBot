# Dockerfile
# First stage - Build the Python image
FROM python:3.8.12-slim-buster as python-builder
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app/
EXPOSE 80
ENV TOKEN_PATH /app/.telegramToken
CMD ["python3", "bot.py"]

# Second stage - Copy artifacts to the Jenkins agent image
FROM jenkins/agent
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
WORKDIR /app
COPY --from=python-builder /app /app