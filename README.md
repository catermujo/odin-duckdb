# Odin DuckDB

Root package provides typed DuckDB helpers:

```odin
import duckdb "vendor/duckdb"
```

- `open`, `connect`, `close`, and `disconnect` manage ownership.
- `execute` accepts typed `Query_Param` values.
- `query` fills tagged structs into dynamic arrays.
- `prepare`, bind, step, value, and destroy helpers support manual statements.
- `last_error` returns the last operation's borrowed error text.

Query results own cloned strings and blobs. Delete those fields, then delete
the result array after use.

Raw C bindings live in `vendor/duckdb/raw`:

```odin
import duckdb_raw "vendor/duckdb/raw"
```
