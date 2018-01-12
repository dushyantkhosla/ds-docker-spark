# Spark on Docker!


### Pull the image

- `docker pull eadlab/ds-docker-spark`

### Run the container

- `docker run -it -p 8080:8080 eadlab/ds-docker-spark`

### Run PySpark in a Jupiter Notebook

- Just run `pyspark` on the command-line, it will launch in a notebook. 
Everything else is configured.


#### Optional: Get omf and a theme

1. Run `curl -L https://get.oh-my.fish | fish`
2. Run `omf install bobthefish`