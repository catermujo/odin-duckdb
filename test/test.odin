package test

import duckdb ".."
import "core:fmt"

User :: struct {
    name:    string `duckdb:"name"`,
    score:   f64 `duckdb:"score"`,
    active:  bool `duckdb:"active"`,
    payload: []byte `duckdb:"payload"`,
}

main :: proc() {
    db, status := duckdb.open(":memory:")
    if status != .DuckDBSuccess {
        fmt.panicf("open failed: {}", status)
    }
    defer duckdb.close(&db)

    conn, connect_status := duckdb.connect(&db)
    if connect_status != .DuckDBSuccess {
        fmt.panicf("connect failed: {}", connect_status)
    }
    defer duckdb.disconnect(&conn)

    if result := duckdb.execute(
        &conn,
        "CREATE TABLE users (name VARCHAR, score DOUBLE, active BOOLEAN, payload BLOB)",
    ); result != .DuckDBSuccess {
        fmt.panicf("create failed: {}", duckdb.last_error(&conn))
    }
    if result := duckdb.execute(&conn, "INSERT INTO missing_table VALUES (1)"); result == .DuckDBSuccess {
        fmt.panicf("invalid insert unexpectedly succeeded")
    }
    if duckdb.last_error(&conn) == "" {
        fmt.panicf("invalid insert did not set an error")
    }
    if result := duckdb.execute(
        &conn,
        "INSERT INTO users VALUES (?, ?, ?, ?)",
        {
            {index = 1, value = "john"},
            {index = 2, value = f64(2.5)},
            {index = 3, value = true},
            {index = 4, value = []byte{1, 2, 3}},
        },
    ); result != .DuckDBSuccess {
        fmt.panicf("insert failed: {}", duckdb.last_error(&conn))
    }

    users: [dynamic]User
    if result := duckdb.query(
        &conn,
        &users,
        "SELECT name, score, active, payload FROM users WHERE active = ?",
        {{index = 1, value = true}},
    ); result != .DuckDBSuccess {
        fmt.panicf("query failed: {}", duckdb.last_error(&conn))
    }

    for &user in users {
        fmt.printfln("{} {} {} {}", user.name, user.score, user.active, len(user.payload))
        delete(user.name)
        delete(user.payload)
    }
    delete(users)

    statement, statement_status := duckdb.prepare(&conn, "SELECT name FROM users WHERE active = ?")
    if statement_status != .DuckDBSuccess {
        fmt.panicf("prepare failed: {}", duckdb.last_error(&conn))
    }
    defer duckdb.statement_destroy(&statement)

    if status := duckdb.bind_i64(&statement, 1, 1); status != .DuckDBSuccess {
        fmt.panicf("bind failed: {}", status)
    }
    step, step_status := duckdb.step(&statement)
    if step_status != .DuckDBSuccess || step != .Row {
        fmt.panicf("first step failed: {} {}", step, step_status)
    }
    value := duckdb.value_string(&statement, 0)
    if value.data == nil || value.size != 4 {
        fmt.panicf("string value failed")
    }
    duckdb.string_destroy(&value)

    step, step_status = duckdb.step(&statement)
    if step_status != .DuckDBSuccess || step != .Done {
        fmt.panicf("final step failed: {} {}", step, step_status)
    }
}
