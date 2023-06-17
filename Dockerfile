FROM python:slim

RUN useradd microblog

WORKDIR /microblog

COPY ./requirements.txt ./requirements.txt
RUN python -m venv venv
RUN pip3 install -r ./requirements.txt
RUN pip3 install gunicorn
RUN pip3 install gunicorn pymysql cryptography

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./
RUN chmod +x boot.sh

ENV FLASK_APP microblog.py

RUN chown -R microblog:microblog ./
USER microblog

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]