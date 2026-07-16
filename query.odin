package duckdb

import "core:c"
import "core:fmt"
import "core:mem"
import "core:reflect"
import "core:strings"
import raw "raw"

Query_Error :: Maybe(string)

Query_Param_Value :: union {
    i32,
    i64,
    f64,
    []byte,
    bool,
    string,
}

Query_Param :: struct {
    index: int,
    value: Query_Param_Value,
}

Statement :: struct {
    prepared:   raw.duckdb_prepared_statement,
    result:     raw.duckdb_result,
    has_result: bool,
    executed:   bool,
    row_index:  raw.idx_t,
}

Step :: enum {
    Row,
    Done,
}

String_Value :: raw.duckdb_string

execute :: proc(conn: ^Connection, sql: string, params: []Query_Param = {}) -> State {
    if conn == nil || conn.handle == nil {
        return .DuckDBError
    }

    if len(params) == 0 {
        result: raw.duckdb_result
        status := run_query(conn, &result, sql)
        defer raw.destroy_result(&result)
        if status != .DuckDBSuccess {
            set_error_text(conn, "DuckDB query failed")
        } else {
            clear_error(conn)
        }
        return status
    }

    stmt: raw.duckdb_prepared_statement
    prepare_statement(conn, &stmt, sql, params) or_return
    defer raw.destroy_prepare(&stmt)

    result: raw.duckdb_result
    status := raw.execute_prepared(stmt, &result)
    defer raw.destroy_result(&result)
    if status != .DuckDBSuccess {
        set_error_text(conn, "DuckDB prepared query failed")
    } else {
        clear_error(conn)
    }
    return status
}

prepare :: proc(conn: ^Connection, sql: string) -> (Statement, State) {
    statement: Statement
    status := prepare_statement(conn, &statement.prepared, sql, {})
    if status != .DuckDBSuccess {
        return {}, status
    }
    return statement, .DuckDBSuccess
}

bind_text :: proc(statement: ^Statement, index: int, value: string) -> State {
    if statement == nil || statement.prepared == nil || index <= 0 {
        return .DuckDBError
    }

    c_value, err := strings.clone_to_cstring(value)
    if err != nil {
        return .DuckDBError
    }
    defer delete(c_value)

    return raw.bind_varchar_length(statement.prepared, raw.idx_t(index), c_value, raw.idx_t(len(value)))
}

bind_i64 :: proc(statement: ^Statement, index: int, value: i64) -> State {
    if statement == nil || statement.prepared == nil || index <= 0 {
        return .DuckDBError
    }
    return raw.bind_int64(statement.prepared, raw.idx_t(index), c.int64_t(value))
}

bind_blob :: proc(statement: ^Statement, index: int, value: rawptr, length: int) -> State {
    if statement == nil || statement.prepared == nil || index <= 0 || length < 0 {
        return .DuckDBError
    }
    return raw.bind_blob(statement.prepared, raw.idx_t(index), value, raw.idx_t(length))
}

step :: proc(statement: ^Statement) -> (Step, State) {
    if statement == nil || statement.prepared == nil {
        return .Done, .DuckDBError
    }

    if statement.executed {
        if raw.result_return_type(statement.result) == .DUCKDB_RESULT_TYPE_QUERY_RESULT &&
           statement.row_index + 1 < raw.row_count(&statement.result) {
            statement.row_index += 1
            return .Row, .DuckDBSuccess
        }
        return .Done, .DuckDBSuccess
    }

    statement.executed = true
    status := raw.execute_prepared(statement.prepared, &statement.result)
    statement.has_result = true
    if status != .DuckDBSuccess {
        return .Done, status
    }
    if raw.result_return_type(statement.result) != .DUCKDB_RESULT_TYPE_QUERY_RESULT ||
       raw.row_count(&statement.result) == 0 {
        return .Done, .DuckDBSuccess
    }
    return .Row, .DuckDBSuccess
}

value_int64 :: proc(statement: ^Statement, column: int) -> i64 {
    return i64(raw.value_int64(&statement.result, raw.idx_t(column), statement.row_index))
}

value_string :: proc(statement: ^Statement, column: int) -> String_Value {
    return raw.value_string(&statement.result, raw.idx_t(column), statement.row_index)
}

string_destroy :: proc(value: ^String_Value) {
    if value != nil && value.data != nil {
        raw.free(rawptr(value.data))
    }
    if value != nil {
        value^ = {}
    }
}

statement_destroy :: proc(statement: ^Statement) {
    if statement == nil {
        return
    }
    if statement.has_result {
        raw.destroy_result(&statement.result)
    }
    raw.destroy_prepare(&statement.prepared)
    statement^ = {}
}

query :: proc(conn: ^Connection, out: ^[dynamic]$T, sql: string, params: []Query_Param = {}) -> State {
    if conn == nil || conn.handle == nil {
        return .DuckDBError
    }

    result: raw.duckdb_result
    result_initialized := false
    defer if result_initialized {
        raw.destroy_result(&result)
    }
    if len(params) == 0 {
        status := run_query(conn, &result, sql)
        result_initialized = true
        if status != .DuckDBSuccess {
            set_error_text(conn, "DuckDB query failed")
            return status
        }
    } else {
        stmt: raw.duckdb_prepared_statement
        prepare_statement(conn, &stmt, sql, params) or_return
        defer raw.destroy_prepare(&stmt)
        status := raw.execute_prepared(stmt, &result)
        result_initialized = true
        if status != .DuckDBSuccess {
            set_error_text(conn, "DuckDB prepared query failed")
            return status
        }
    }

    status := read_all_rows(conn, &result, out)
    if status == .DuckDBSuccess {
        clear_error(conn)
    }
    return status
}

@(private)
run_query :: proc(conn: ^Connection, result: ^raw.duckdb_result, sql: string) -> State {
    c_sql, err := strings.clone_to_cstring(sql)
    if err != nil {
        set_error_text(conn, "could not allocate SQL string")
        return .DuckDBError
    }
    defer delete(c_sql)
    return raw.query(conn.handle, c_sql, result)
}

@(private)
prepare_statement :: proc(
    conn: ^Connection,
    stmt: ^raw.duckdb_prepared_statement,
    sql: string,
    params: []Query_Param,
) -> State {
    prepared := false
    defer if !prepared && stmt^ != nil {
        raw.destroy_prepare(stmt)
    }

    c_sql, err := strings.clone_to_cstring(sql)
    if err != nil {
        set_error_text(conn, "could not allocate SQL string")
        return .DuckDBError
    }
    defer delete(c_sql)

    status := raw.prepare(conn.handle, c_sql, stmt)
    if status != .DuckDBSuccess {
        set_error_text(conn, "DuckDB prepare failed")
        return status
    }

    for &param in params {
        status = bind_parameter(stmt^, param)
        if status != .DuckDBSuccess {
            set_error_text(conn, "could not bind DuckDB query parameter")
            return status
        }
    }

    prepared = true
    clear_error(conn)
    return .DuckDBSuccess
}

@(private)
bind_parameter :: proc(stmt: raw.duckdb_prepared_statement, param: Query_Param) -> State {
    if param.index <= 0 {
        return .DuckDBError
    }
    index := raw.idx_t(param.index)

    if param.value == nil {
        return raw.bind_null(stmt, index)
    } else if value, is_i32 := param.value.(i32); is_i32 {
        return raw.bind_int32(stmt, index, c.int32_t(value))
    } else if value, is_i64 := param.value.(i64); is_i64 {
        return raw.bind_int64(stmt, index, c.int64_t(value))
    } else if value, is_f64 := param.value.(f64); is_f64 {
        return raw.bind_double(stmt, index, c.double(value))
    } else if value, is_blob := param.value.([]byte); is_blob {
        return raw.bind_blob(stmt, index, raw_data(value), raw.idx_t(len(value)))
    } else if value, is_bool := param.value.(bool); is_bool {
        return raw.bind_boolean(stmt, index, value)
    } else if value, is_string := param.value.(string); is_string {
        c_value, err := strings.clone_to_cstring(value)
        if err != nil {
            return .DuckDBError
        }
        defer delete(c_value)
        return raw.bind_varchar_length(stmt, index, c_value, raw.idx_t(len(value)))
    }

    return .DuckDBError
}

@(private)
read_all_rows :: proc(conn: ^Connection, result: ^raw.duckdb_result, out: ^[dynamic]$T) -> State {
    fields, err := get_type_fields(T)
    if err != nil {
        message := err.(string)
        set_error_text(conn, message)
        free_query_error(err)
        return .DuckDBError
    }
    defer delete_field_types(fields)

    if raw.column_count(result) != raw.idx_t(len(fields)) {
        set_error_text(conn, fmt.tprintf("column count does not match {}", typeid_of(T)))
        return .DuckDBError
    }

    field_map: map[string]^Field_Type
    defer delete(field_map)
    for &field in fields {
        field_map[field.tag] = &field
    }

    columns := int(raw.column_count(result))
    rows := int(raw.row_count(result))
    for row in 0 ..< rows {
        item: T
        for column_index in 0 ..< columns {
            column_name := raw.column_name(result, raw.idx_t(column_index))
            if column_name == nil {
                set_error_text(conn, "DuckDB returned a NULL column name")
                return .DuckDBError
            }

            column := strings.clone_from_cstring(column_name)
            field, ok := field_map[column]
            if !ok {
                set_error_text(conn, fmt.tprintf("could not find tag {} in {}", column, typeid_of(T)))
                return .DuckDBError
            }

            field_err := write_struct_field_from_result(&item, field, result, raw.idx_t(column_index), raw.idx_t(row))
            delete(column)
            if field_err != nil {
                message := field_err.(string)
                set_error_text(conn, message)
                free_query_error(field_err)
                return .DuckDBError
            }
        }
        append(out, item)
    }

    return .DuckDBSuccess
}

@(private)
write_struct_field_from_result :: proc(
    obj: ^$T,
    field: ^Field_Type,
    result: ^raw.duckdb_result,
    column: raw.idx_t,
    row: raw.idx_t,
) -> Query_Error {
    if raw.value_is_null(result, column, row) {
        return fmt.tprintf("cannot read NULL into {}", field.type.id)
    }

    switch field.type.id {
    case typeid_of(string):
        value := raw.value_string(result, column, row)
        defer if value.data != nil {
            raw.free(cast(rawptr)value.data)
        }
        if value.data == nil && value.size != 0 {
            return fmt.tprintf("DuckDB returned an invalid string")
        }
        bytes := mem.slice_ptr(cast(^byte)value.data, int(value.size))
        text, err := strings.clone_from_bytes(bytes)
        if err != nil {
            return fmt.tprintf("could not copy string result: {}", err)
        }
        write_struct_field(obj, field^, text) or_return

    case typeid_of(bool):
        write_struct_field(obj, field^, bool(raw.value_boolean(result, column, row))) or_return
    case typeid_of(int):
        write_struct_field(obj, field^, int(raw.value_int32(result, column, row))) or_return
    case typeid_of(uint):
        write_struct_field(obj, field^, uint(raw.value_uint32(result, column, row))) or_return
    case typeid_of(i8):
        write_struct_field(obj, field^, i8(raw.value_int8(result, column, row))) or_return
    case typeid_of(u8):
        write_struct_field(obj, field^, u8(raw.value_uint8(result, column, row))) or_return
    case typeid_of(i16):
        write_struct_field(obj, field^, i16(raw.value_int16(result, column, row))) or_return
    case typeid_of(u16):
        write_struct_field(obj, field^, u16(raw.value_uint16(result, column, row))) or_return
    case typeid_of(i32):
        write_struct_field(obj, field^, i32(raw.value_int32(result, column, row))) or_return
    case typeid_of(u32):
        write_struct_field(obj, field^, u32(raw.value_uint32(result, column, row))) or_return
    case typeid_of(i64):
        write_struct_field(obj, field^, i64(raw.value_int64(result, column, row))) or_return
    case typeid_of(u64):
        write_struct_field(obj, field^, u64(raw.value_uint64(result, column, row))) or_return
    case typeid_of(f32):
        write_struct_field(obj, field^, f32(raw.value_float(result, column, row))) or_return
    case typeid_of(f64):
        write_struct_field(obj, field^, f64(raw.value_double(result, column, row))) or_return
    case typeid_of([]byte):
        value := raw.value_blob(result, column, row)
        defer if value.data != nil {
            raw.free(value.data)
        }
        bytes := make([]byte, int(value.size))
        if len(bytes) > 0 {
            mem.copy(raw_data(bytes), value.data, len(bytes))
        }
        write_struct_field(obj, field^, bytes) or_return

    case:
        if reflect.is_enum(field.type) {
            value := i64(raw.value_int64(result, column, row))
            for enum_value in reflect.enum_field_values(field.type.id) {
                if i64(enum_value) == value {
                    write_struct_field(obj, field^, value) or_return
                    return nil
                }
            }
            return fmt.tprintf("expected enum value {} in {}", value, field.type.id)
        }
        return fmt.tprintf("unhandled data type {}", field.type.id)
    }

    return nil
}

@(private)
free_query_error :: proc(err: Query_Error) {
    delete(err.(string), context.temp_allocator)
}
