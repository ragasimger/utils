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

# Split schemas from comma-separated to individual --schema flags
SCHEMA_FLAGS=""
IFS=',' read -ra SCHEMAS <<< "$SCHEMA_LIST"
for schema in "${SCHEMAS[@]}"; do
  SCHEMA_FLAGS+=" --schema=$schema"
done

# Run pg_dump
pg_dump -h "$HOST" -p "$PORT" -U "$USER" -d "$DB_NAME" -F p -v -f "$OUTPUT_FILE" $SCHEMA_FLAGS
