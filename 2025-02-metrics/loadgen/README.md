Use the Python script to generate load for testing purposes.

`docker run -v $PWD/highload.py:/app/highload.py --rm -it $(docker build -q .)`