# run all the recipes
for f in facdb/recipes/*
do 
    docker exec facdb python $f
done