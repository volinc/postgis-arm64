#!/bin/bash
set -e

export PGUSER="$POSTGRES_USER"

for DB in template_postgis "$POSTGRES_DB"; do
	echo "Updating PostGIS extensions in $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		ALTER EXTENSION postgis UPDATE;
		ALTER EXTENSION postgis_topology UPDATE;
		ALTER EXTENSION postgis_raster UPDATE;
EOSQL
done

