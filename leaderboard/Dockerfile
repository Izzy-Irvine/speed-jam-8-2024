FROM python:3

WORKDIR /app

COPY requirements.txt .

RUN pip3 install -r requirements.txt

COPY main.py .

CMD [ "gunicorn", "main:app", "-w", "4", "--threads", "2", "-b", "0.0.0.0" ]
