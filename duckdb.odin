package duckdb

import "core:strings"
import raw "raw"

State :: raw.duckdb_state
ERROR_MESSAGE_CAPACITY :: 256

Database :: struct {
    handle: raw.duckdb_database,
}

Connection :: struct {
    handle:        raw.duckdb_connection,
    error_message: [ERROR_MESSAGE_CAPACITY]byte,
    error_length:  int,
}

open :: proc(filename: string) -> (Database, State) {
    c_filename, err := strings.clone_to_cstring(filename)
    if err != nil {
        return Database{}, .DuckDBError
    }
    defer delete(c_filename)

    db: Database
    status := raw.open(c_filename, &db.handle)
    return db, status
}

connect :: proc(db: ^Database) -> (Connection, State) {
    if db == nil || db.handle == nil {
        return Connection{}, .DuckDBError
    }

    conn: Connection
    status := raw.connect(db.handle, &conn.handle)
    return conn, status
}

close :: proc(db: ^Database) {
    if db == nil || db.handle == nil {
        return
    }
    raw.close(&db.handle)
}

disconnect :: proc(conn: ^Connection) {
    if conn == nil {
        return
    }
    if conn.handle != nil {
        raw.disconnect(&conn.handle)
    }
    clear_error(conn)
}

last_error :: proc(conn: ^Connection) -> string {
    if conn == nil {
        return ""
    }
    return string(conn.error_message[:conn.error_length])
}

library_version :: proc() -> cstring {
    return raw.library_version()
}

@(private)
clear_error :: proc(conn: ^Connection) {
    if conn == nil {
        return
    }
    conn.error_length = 0
}

@(private)
set_error_text :: proc(conn: ^Connection, message: string) {
    if conn == nil {
        return
    }
    clear_error(conn)
    length := len(message)
    if length > len(conn.error_message) {
        length = len(conn.error_message)
    }
    copy(conn.error_message[:length], message[:length])
    conn.error_length = length
}
