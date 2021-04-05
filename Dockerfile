FROM python

RUN pip install flask

COPY src /tmp/src
COPY . /tmp

WORKDIR /tmp

EXPOSE 5000

#ENTRYPOINT ["/bin/bash"]
CMD ["python", "flask_app.py"]