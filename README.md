# db-facilities-tmp

## Development environment
+ Dataloading environment
    ```
    docker run -itd --name=etl\
            -v `pwd`:/home/db-facilities\
            -v `pwd`
            --network=host\
            -w /home/db-facilities\
            sptkl/docker-dataloading bash 
    ```
+ Postgis
    ```
    docker run -itd --name=db\
            --network=host\
            mdillon/postgis 
    ```

```
        docker run -itd --name=etl1\
                -v /db-facilities-tmp:/home/db-facilities\
                -v /db-data-recipes:/home/db-data-recipes\
                -w /home/db-data-recipes\
                sptkl/docker-dataloading:latest bash
```