FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN which gunicorn

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV SECRET_KEY secret_key

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]