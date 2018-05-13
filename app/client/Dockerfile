FROM jfloff/alpine-python

ADD client.py /app/client.py
ADD requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

# this probably can be removed in the future
RUN apk add --no-cache curl

ENTRYPOINT [ "python" ]

CMD [ "client.py" ]
