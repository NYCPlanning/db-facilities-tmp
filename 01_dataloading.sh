# Fast load spatial tableds
docker run --rm\
            --network=host\
             -v `pwd`:/home/db-facilities\
            -w /home/db-facilities/facdb/fast_load\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py

# run all the recipes
for f in facdb/recipes/*
do 
    name=$(basename $f .py) 
    docker exec facdb python $f
    docker exec fdb psql -h localhost -U postgres -f sql/$name.sql
done

# name=usdot_ports
# docker exec facdb python facdb/recipes/$name.py
# docker exec fdb psql -h localhost -U postgres -f sql/$name.sql