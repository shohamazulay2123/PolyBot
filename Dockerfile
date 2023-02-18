FROM python:3.8.12-slim-buster


WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 80
ENTRYPOINT ["python"]

CMD ["python3", "bot.py"]
