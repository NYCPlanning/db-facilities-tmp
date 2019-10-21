# run all the recipes
for f in facdb/recipes/*
do 
    docker exec facdb python $f
done

# load spatial boundries
docker run --rm\
            --network=host\
             -v `pwd`:/home/db-facilities\
            -w /home/db-facilities/facdb/spatial_boundaries\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py