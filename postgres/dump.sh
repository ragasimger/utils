# Usage: ./backup_pg.sh <host> <port> <user> <database_name> <output_file.sql> <schema1,schema2,...>
# This script will export the db in sql format which can be restored for most of the versions with pg_restore

HOST=$1
PORT=$2
USER=$3
DB_NAME=$4
OUTPUT_FILE=$5
SCHEMA_LIST=$6

# Validate arguments
if [[ -z "$HOST" || -z "$PORT" || -z "$USER" || -z "$DB_NAME" || -z "$OUTPUT_FILE" || -z "$SCHEMA_LIST" ]]; then
  echo "❌ Error: Missing arguments."
  echo "Usage: $0 <host> <port> <user> <database_name> <output_file.sql> <schema1,schema2,...>"
  exit 1
fi


# Normalize schema list: remove spaces after commas
SCHEMA_LIST=$(echo "$SCHEMA_LIST" | sed 's/, */,/g')

# Split schemas by comma
IFS=',' read -ra SCHEMAS <<< "$SCHEMA_LIST"

# Split schemas from comma-separated to individual --schema flags
SCHEMA_FLAGS=""
for schema in "${SCHEMAS[@]}"; do
  SCHEMA_FLAGS+=" --schema=$schema"
done


echo "Dumping database '$DB_NAME' from host '$HOST' port '$PORT' with user '$USER'"
echo "Schemas: $SCHEMA_LIST"
echo "Output file: $OUTPUT_FILE"


# Run pg_dump
pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB_NAME" -F p -v -f "$OUTPUT_FILE" $SCHEMA_FLAGS
