# PostgreSQL dump and Restore script
You can run the PostgreSQL dump, and restore script directly from GitHub without cloning the repo.

## PostgreSQL Dump Script

### Usage

While passing the schemas, pass in string like this: <code>"public, staging"</code>

```
bash <(curl -sSL https://raw.githubusercontent.com/ragasimger/utils/main/postgres/dump.sh) localhost 5432 admin test_db test_db_file.sql "public,staging"
```
