# Spark on Docker!


### Pull the image

- `docker pull eadlab/ds-docker-spark`

### Run the container

```
docker run -it -v (pwd):/home \
               -p 8080:8080 \
               -p 5000:5000 \
               -e GIT_USER_NAME="Dushyant Khosla" \
               -e GIT_USER_MAIL="dushyant.khosla@yahoo.com" \
               eadlab/ds-docker-spark
```

### Run PySpark in a Jupyter Notebook

- Just run `pyspark` on the command-line, it will launch in a notebook. 
Everything else is configured.
