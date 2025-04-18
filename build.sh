docker build -t scramjet-build .
docker run -v "$(pwd)/dist:/app/output" scramjet-build