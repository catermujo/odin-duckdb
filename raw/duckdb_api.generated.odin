// Generated from duckdb/src/include/duckdb.h. Do not edit.
package duckdb_raw

import "core:c"

when LINK == "system" {
    foreign import duckdb_api "system:duckdb"
} else {
    foreign import duckdb_api {LIB_PATH}
}

duckdb_error_type :: enum c.int {
    DUCKDB_ERROR_INVALID,
    DUCKDB_ERROR_OUT_OF_RANGE,
    DUCKDB_ERROR_CONVERSION,
    DUCKDB_ERROR_UNKNOWN_TYPE,
    DUCKDB_ERROR_DECIMAL,
    DUCKDB_ERROR_MISMATCH_TYPE,
    DUCKDB_ERROR_DIVIDE_BY_ZERO,
    DUCKDB_ERROR_OBJECT_SIZE,
    DUCKDB_ERROR_INVALID_TYPE,
    DUCKDB_ERROR_SERIALIZATION,
    DUCKDB_ERROR_TRANSACTION,
    DUCKDB_ERROR_NOT_IMPLEMENTED,
    DUCKDB_ERROR_EXPRESSION,
    DUCKDB_ERROR_CATALOG,
    DUCKDB_ERROR_PARSER,
    DUCKDB_ERROR_PLANNER,
    DUCKDB_ERROR_SCHEDULER,
    DUCKDB_ERROR_EXECUTOR,
    DUCKDB_ERROR_CONSTRAINT,
    DUCKDB_ERROR_INDEX,
    DUCKDB_ERROR_STAT,
    DUCKDB_ERROR_CONNECTION,
    DUCKDB_ERROR_SYNTAX,
    DUCKDB_ERROR_SETTINGS,
    DUCKDB_ERROR_BINDER,
    DUCKDB_ERROR_NETWORK,
    DUCKDB_ERROR_OPTIMIZER,
    DUCKDB_ERROR_NULL_POINTER,
    DUCKDB_ERROR_IO,
    DUCKDB_ERROR_INTERRUPT,
    DUCKDB_ERROR_FATAL,
    DUCKDB_ERROR_INTERNAL,
    DUCKDB_ERROR_INVALID_INPUT,
    DUCKDB_ERROR_OUT_OF_MEMORY,
    DUCKDB_ERROR_PERMISSION,
    DUCKDB_ERROR_PARAMETER_NOT_RESOLVED,
    DUCKDB_ERROR_PARAMETER_NOT_ALLOWED,
    DUCKDB_ERROR_DEPENDENCY,
    DUCKDB_ERROR_HTTP,
    DUCKDB_ERROR_MISSING_EXTENSION,
    DUCKDB_ERROR_AUTOLOAD,
    DUCKDB_ERROR_SEQUENCE,
    DUCKDB_INVALID_CONFIGURATION,
}

duckdb_cast_mode :: enum c.int {
    DUCKDB_CAST_NORMAL,
    DUCKDB_CAST_TRY,
}

duckdb_file_flag :: enum c.int {
    DUCKDB_FILE_FLAG_INVALID,
    DUCKDB_FILE_FLAG_READ,
    DUCKDB_FILE_FLAG_WRITE,
    DUCKDB_FILE_FLAG_CREATE,
    DUCKDB_FILE_FLAG_CREATE_NEW,
    DUCKDB_FILE_FLAG_APPEND,
}

duckdb_config_option_scope :: enum c.int {
    DUCKDB_CONFIG_OPTION_SCOPE_INVALID,
    DUCKDB_CONFIG_OPTION_SCOPE_LOCAL,
    DUCKDB_CONFIG_OPTION_SCOPE_SESSION,
    DUCKDB_CONFIG_OPTION_SCOPE_GLOBAL,
}

duckdb_catalog_entry_type :: enum c.int {
    DUCKDB_CATALOG_ENTRY_TYPE_INVALID,
    DUCKDB_CATALOG_ENTRY_TYPE_TABLE,
    DUCKDB_CATALOG_ENTRY_TYPE_SCHEMA,
    DUCKDB_CATALOG_ENTRY_TYPE_VIEW,
    DUCKDB_CATALOG_ENTRY_TYPE_INDEX,
    DUCKDB_CATALOG_ENTRY_TYPE_PREPARED_STATEMENT,
    DUCKDB_CATALOG_ENTRY_TYPE_SEQUENCE,
    DUCKDB_CATALOG_ENTRY_TYPE_COLLATION,
    DUCKDB_CATALOG_ENTRY_TYPE_TYPE,
    DUCKDB_CATALOG_ENTRY_TYPE_DATABASE,
}

sel_t :: c.uint32_t

duckdb_copy_callback_t :: ^proc "c" (arg0: rawptr) -> rawptr

duckdb_time_ns :: struct {
    nanos: c.int64_t,
}

duckdb_timestamp_s :: struct {
    seconds: c.int64_t,
}

duckdb_timestamp_ms :: struct {
    millis: c.int64_t,
}

duckdb_timestamp_ns :: struct {
    nanos: c.int64_t,
}

duckdb_selection_vector :: ^struct {
    internal_ptr: rawptr,
}

duckdb_bit :: struct {
    data: ^c.uint8_t,
    size: idx_t,
}

duckdb_bignum :: struct {
    data:        ^c.uint8_t,
    size:        idx_t,
    is_negative: bool,
}

duckdb_instance_cache :: ^struct {
    internal_ptr: rawptr,
}

duckdb_client_context :: ^struct {
    internal_ptr: rawptr,
}

duckdb_table_description :: ^struct {
    internal_ptr: rawptr,
}

duckdb_config_option :: ^struct {
    internal_ptr: rawptr,
}

duckdb_create_type_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_profiling_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_error_data :: ^struct {
    internal_ptr: rawptr,
}

duckdb_expression :: ^struct {
    internal_ptr: rawptr,
}

duckdb_extension_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_scalar_function :: ^struct {
    internal_ptr: rawptr,
}

duckdb_scalar_function_set :: ^struct {
    internal_ptr: rawptr,
}

duckdb_scalar_function_bind_t :: ^proc "c" (arg0: duckdb_bind_info)

duckdb_scalar_function_init_t :: ^proc "c" (arg0: duckdb_init_info)

duckdb_scalar_function_t :: ^proc "c" (arg0: duckdb_function_info, arg1: duckdb_data_chunk, arg2: duckdb_vector)

duckdb_aggregate_function :: ^struct {
    internal_ptr: rawptr,
}

duckdb_aggregate_function_set :: ^struct {
    internal_ptr: rawptr,
}

duckdb_aggregate_state :: ^struct {
    internal_ptr: rawptr,
}

duckdb_aggregate_state_size :: ^proc "c" (arg0: duckdb_function_info) -> idx_t

duckdb_aggregate_init_t :: ^proc "c" (arg0: duckdb_function_info, arg1: duckdb_aggregate_state)

duckdb_aggregate_destroy_t :: ^proc "c" (arg0: ^duckdb_aggregate_state, arg1: idx_t)

duckdb_aggregate_update_t :: ^proc "c" (
    arg0: duckdb_function_info,
    arg1: duckdb_data_chunk,
    arg2: ^duckdb_aggregate_state,
)

duckdb_aggregate_combine_t :: ^proc "c" (
    arg0: duckdb_function_info,
    arg1: ^duckdb_aggregate_state,
    arg2: ^duckdb_aggregate_state,
    arg3: idx_t,
)

duckdb_aggregate_finalize_t :: ^proc "c" (
    arg0: duckdb_function_info,
    arg1: ^duckdb_aggregate_state,
    arg2: duckdb_vector,
    arg3: idx_t,
    arg4: idx_t,
)

duckdb_copy_function :: ^struct {
    internal_ptr: rawptr,
}

duckdb_copy_function_bind_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_copy_function_global_init_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_copy_function_sink_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_copy_function_finalize_info :: ^struct {
    internal_ptr: rawptr,
}

duckdb_copy_function_bind_t :: ^proc "c" (arg0: duckdb_copy_function_bind_info)

duckdb_copy_function_global_init_t :: ^proc "c" (arg0: duckdb_copy_function_global_init_info)

duckdb_copy_function_sink_t :: ^proc "c" (arg0: duckdb_copy_function_sink_info, arg1: duckdb_data_chunk)

duckdb_copy_function_finalize_t :: ^proc "c" (arg0: duckdb_copy_function_finalize_info)

duckdb_cast_function :: ^struct {
    internal_ptr: rawptr,
}

duckdb_cast_function_t :: ^proc "c" (
    arg0: duckdb_function_info,
    arg1: idx_t,
    arg2: duckdb_vector,
    arg3: duckdb_vector,
) -> bool

duckdb_arrow_converted_schema :: ^struct {
    internal_ptr: rawptr,
}

duckdb_arrow_options :: ^struct {
    internal_ptr: rawptr,
}

duckdb_file_open_options :: ^struct {
    internal_ptr: rawptr,
}

duckdb_file_system :: ^struct {
    internal_ptr: rawptr,
}

duckdb_file_handle :: ^struct {
    internal_ptr: rawptr,
}

duckdb_catalog :: ^struct {
    internal_ptr: rawptr,
}

duckdb_catalog_entry :: ^struct {
    internal_ptr: rawptr,
}

duckdb_log_storage :: ^struct {
    internal_ptr: rawptr,
}

duckdb_logger_write_log_entry_t :: ^proc "c" (
    arg0: rawptr,
    arg1: ^duckdb_timestamp,
    arg2: cstring,
    arg3: cstring,
    arg4: cstring,
)

duckdb_extension_access :: struct {
    set_error:    ^proc "c" (_: duckdb_extension_info, _: cstring),
    get_database: ^proc "c" (_: duckdb_extension_info) -> ^duckdb_database,
    get_api:      ^proc "c" (_: duckdb_extension_info, _: cstring) -> rawptr,
}

@(default_calling_convention = "c", link_prefix = "duckdb_")
foreign duckdb_api {
    create_instance_cache :: proc() -> duckdb_instance_cache ---
    get_or_create_from_cache :: proc(instance_cache: duckdb_instance_cache, path: cstring, out_database: ^duckdb_database, config: duckdb_config, out_error: ^^c.char) -> duckdb_state ---
    destroy_instance_cache :: proc(instance_cache: ^duckdb_instance_cache) ---
    connection_get_client_context :: proc(connection: duckdb_connection, out_context: ^duckdb_client_context) ---
    connection_get_arrow_options :: proc(connection: duckdb_connection, out_arrow_options: ^duckdb_arrow_options) ---
    client_context_get_connection_id :: proc(context_: duckdb_client_context) -> idx_t ---
    destroy_client_context :: proc(context_: ^duckdb_client_context) ---
    destroy_arrow_options :: proc(arrow_options: ^duckdb_arrow_options) ---
    get_table_names :: proc(connection: duckdb_connection, query: cstring, qualified: bool) -> duckdb_value ---
    create_error_data :: proc(type: duckdb_error_type, message: cstring) -> duckdb_error_data ---
    destroy_error_data :: proc(error_data: ^duckdb_error_data) ---
    error_data_error_type :: proc(error_data: duckdb_error_data) -> duckdb_error_type ---
    error_data_message :: proc(error_data: duckdb_error_data) -> cstring ---
    error_data_has_error :: proc(error_data: duckdb_error_data) -> bool ---
    result_get_arrow_options :: proc(result: ^duckdb_result) -> duckdb_arrow_options ---
    result_error_type :: proc(result: ^duckdb_result) -> duckdb_error_type ---
    string_t_length :: proc(string: duckdb_string_t) -> c.uint32_t ---
    string_t_data :: proc(string: ^duckdb_string_t) -> cstring ---
    valid_utf8_check :: proc(str: cstring, len: idx_t) -> duckdb_error_data ---
    is_finite_timestamp_s :: proc(ts: duckdb_timestamp_s) -> bool ---
    is_finite_timestamp_ms :: proc(ts: duckdb_timestamp_ms) -> bool ---
    is_finite_timestamp_ns :: proc(ts: duckdb_timestamp_ns) -> bool ---
    param_logical_type :: proc(prepared_statement: duckdb_prepared_statement, param_idx: idx_t) -> duckdb_logical_type ---
    prepared_statement_column_count :: proc(prepared_statement: duckdb_prepared_statement) -> idx_t ---
    prepared_statement_column_name :: proc(prepared_statement: duckdb_prepared_statement, col_idx: idx_t) -> cstring ---
    prepared_statement_column_logical_type :: proc(prepared_statement: duckdb_prepared_statement, col_idx: idx_t) -> duckdb_logical_type ---
    prepared_statement_column_type :: proc(prepared_statement: duckdb_prepared_statement, col_idx: idx_t) -> duckdb_type ---
    bind_timestamp_tz :: proc(prepared_statement: duckdb_prepared_statement, param_idx: idx_t, val: duckdb_timestamp) -> duckdb_state ---
    extract_statements_error :: proc(extracted_statements: duckdb_extracted_statements) -> cstring ---
    create_bool :: proc(input: bool) -> duckdb_value ---
    create_int8 :: proc(input: c.int8_t) -> duckdb_value ---
    create_uint8 :: proc(input: c.uint8_t) -> duckdb_value ---
    create_int16 :: proc(input: c.int16_t) -> duckdb_value ---
    create_uint16 :: proc(input: c.uint16_t) -> duckdb_value ---
    create_int32 :: proc(input: c.int32_t) -> duckdb_value ---
    create_uint32 :: proc(input: c.uint32_t) -> duckdb_value ---
    create_uint64 :: proc(input: c.uint64_t) -> duckdb_value ---
    create_hugeint :: proc(input: duckdb_hugeint) -> duckdb_value ---
    create_uhugeint :: proc(input: duckdb_uhugeint) -> duckdb_value ---
    create_bignum :: proc(input: duckdb_bignum) -> duckdb_value ---
    create_decimal :: proc(input: duckdb_decimal) -> duckdb_value ---
    create_float :: proc(input: c.float) -> duckdb_value ---
    create_double :: proc(input: c.double) -> duckdb_value ---
    create_date :: proc(input: duckdb_date) -> duckdb_value ---
    create_time :: proc(input: duckdb_time) -> duckdb_value ---
    create_time_ns :: proc(input: duckdb_time_ns) -> duckdb_value ---
    create_time_tz_value :: proc(value: duckdb_time_tz) -> duckdb_value ---
    create_timestamp :: proc(input: duckdb_timestamp) -> duckdb_value ---
    create_timestamp_tz :: proc(input: duckdb_timestamp) -> duckdb_value ---
    create_timestamp_tz_ns :: proc(input: duckdb_timestamp_ns) -> duckdb_value ---
    create_timestamp_s :: proc(input: duckdb_timestamp_s) -> duckdb_value ---
    create_timestamp_ms :: proc(input: duckdb_timestamp_ms) -> duckdb_value ---
    create_timestamp_ns :: proc(input: duckdb_timestamp_ns) -> duckdb_value ---
    create_interval :: proc(input: duckdb_interval) -> duckdb_value ---
    create_blob :: proc(data: ^c.uint8_t, length: idx_t) -> duckdb_value ---
    create_bit :: proc(input: duckdb_bit) -> duckdb_value ---
    create_uuid :: proc(input: duckdb_uhugeint) -> duckdb_value ---
    get_bool :: proc(val: duckdb_value) -> bool ---
    get_int8 :: proc(val: duckdb_value) -> c.int8_t ---
    get_uint8 :: proc(val: duckdb_value) -> c.uint8_t ---
    get_int16 :: proc(val: duckdb_value) -> c.int16_t ---
    get_uint16 :: proc(val: duckdb_value) -> c.uint16_t ---
    get_int32 :: proc(val: duckdb_value) -> c.int32_t ---
    get_uint32 :: proc(val: duckdb_value) -> c.uint32_t ---
    get_uint64 :: proc(val: duckdb_value) -> c.uint64_t ---
    get_hugeint :: proc(val: duckdb_value) -> duckdb_hugeint ---
    get_uhugeint :: proc(val: duckdb_value) -> duckdb_uhugeint ---
    get_bignum :: proc(val: duckdb_value) -> duckdb_bignum ---
    get_decimal :: proc(val: duckdb_value) -> duckdb_decimal ---
    get_float :: proc(val: duckdb_value) -> c.float ---
    get_double :: proc(val: duckdb_value) -> c.double ---
    get_date :: proc(val: duckdb_value) -> duckdb_date ---
    get_time :: proc(val: duckdb_value) -> duckdb_time ---
    get_time_ns :: proc(val: duckdb_value) -> duckdb_time_ns ---
    get_time_tz :: proc(val: duckdb_value) -> duckdb_time_tz ---
    get_timestamp :: proc(val: duckdb_value) -> duckdb_timestamp ---
    get_timestamp_tz :: proc(val: duckdb_value) -> duckdb_timestamp ---
    get_timestamp_tz_ns :: proc(val: duckdb_value) -> duckdb_timestamp_ns ---
    get_timestamp_s :: proc(val: duckdb_value) -> duckdb_timestamp_s ---
    get_timestamp_ms :: proc(val: duckdb_value) -> duckdb_timestamp_ms ---
    get_timestamp_ns :: proc(val: duckdb_value) -> duckdb_timestamp_ns ---
    get_interval :: proc(val: duckdb_value) -> duckdb_interval ---
    get_value_type :: proc(val: duckdb_value) -> duckdb_logical_type ---
    get_blob :: proc(val: duckdb_value) -> duckdb_blob ---
    get_bit :: proc(val: duckdb_value) -> duckdb_bit ---
    get_uuid :: proc(val: duckdb_value) -> duckdb_uhugeint ---
    create_map_value :: proc(map_type: duckdb_logical_type, keys: ^duckdb_value, values: ^duckdb_value, entry_count: idx_t) -> duckdb_value ---
    create_union_value :: proc(union_type: duckdb_logical_type, tag_index: idx_t, value: duckdb_value) -> duckdb_value ---
    get_map_size :: proc(value: duckdb_value) -> idx_t ---
    get_map_key :: proc(value: duckdb_value, index: idx_t) -> duckdb_value ---
    get_map_value :: proc(value: duckdb_value, index: idx_t) -> duckdb_value ---
    is_null_value :: proc(value: duckdb_value) -> bool ---
    create_null_value :: proc() -> duckdb_value ---
    get_list_size :: proc(value: duckdb_value) -> idx_t ---
    get_list_child :: proc(value: duckdb_value, index: idx_t) -> duckdb_value ---
    create_enum_value :: proc(type: duckdb_logical_type, value: c.uint64_t) -> duckdb_value ---
    get_enum_value :: proc(value: duckdb_value) -> c.uint64_t ---
    get_struct_child :: proc(value: duckdb_value, index: idx_t) -> duckdb_value ---
    value_to_string :: proc(value: duckdb_value) -> ^c.char ---
    logical_type_set_alias :: proc(type: duckdb_logical_type, alias: cstring) ---
    register_logical_type :: proc(con: duckdb_connection, type: duckdb_logical_type, info: duckdb_create_type_info) -> duckdb_state ---
    create_vector :: proc(type: duckdb_logical_type, capacity: idx_t) -> duckdb_vector ---
    destroy_vector :: proc(vector: ^duckdb_vector) ---
    unsafe_vector_assign_string_element_len :: proc(vector: duckdb_vector, index: idx_t, str: cstring, str_len: idx_t) ---
    slice_vector :: proc(vector: duckdb_vector, sel: duckdb_selection_vector, len: idx_t) ---
    vector_copy_sel :: proc(src: duckdb_vector, dst: duckdb_vector, sel: duckdb_selection_vector, src_count: idx_t, src_offset: idx_t, dst_offset: idx_t) ---
    vector_reference_value :: proc(vector: duckdb_vector, value: duckdb_value) ---
    vector_reference_vector :: proc(to_vector: duckdb_vector, from_vector: duckdb_vector) ---
    create_scalar_function :: proc() -> duckdb_scalar_function ---
    destroy_scalar_function :: proc(scalar_function: ^duckdb_scalar_function) ---
    scalar_function_set_name :: proc(scalar_function: duckdb_scalar_function, name: cstring) ---
    scalar_function_set_varargs :: proc(scalar_function: duckdb_scalar_function, type: duckdb_logical_type) ---
    scalar_function_set_special_handling :: proc(scalar_function: duckdb_scalar_function) ---
    scalar_function_set_volatile :: proc(scalar_function: duckdb_scalar_function) ---
    scalar_function_add_parameter :: proc(scalar_function: duckdb_scalar_function, type: duckdb_logical_type) ---
    scalar_function_set_return_type :: proc(scalar_function: duckdb_scalar_function, type: duckdb_logical_type) ---
    scalar_function_set_extra_info :: proc(scalar_function: duckdb_scalar_function, extra_info: rawptr, destroy: duckdb_delete_callback_t) ---
    scalar_function_set_bind :: proc(scalar_function: duckdb_scalar_function, bind: duckdb_scalar_function_bind_t) ---
    scalar_function_set_bind_data :: proc(info: duckdb_bind_info, bind_data: rawptr, destroy: duckdb_delete_callback_t) ---
    scalar_function_set_bind_data_copy :: proc(info: duckdb_bind_info, copy: duckdb_copy_callback_t) ---
    scalar_function_bind_set_error :: proc(info: duckdb_bind_info, error: cstring) ---
    scalar_function_set_function :: proc(scalar_function: duckdb_scalar_function, function: duckdb_scalar_function_t) ---
    register_scalar_function :: proc(con: duckdb_connection, scalar_function: duckdb_scalar_function) -> duckdb_state ---
    scalar_function_get_extra_info :: proc(info: duckdb_function_info) -> rawptr ---
    scalar_function_bind_get_extra_info :: proc(info: duckdb_bind_info) -> rawptr ---
    scalar_function_get_bind_data :: proc(info: duckdb_function_info) -> rawptr ---
    scalar_function_get_client_context :: proc(info: duckdb_bind_info, out_context: ^duckdb_client_context) ---
    scalar_function_set_error :: proc(info: duckdb_function_info, error: cstring) ---
    create_scalar_function_set :: proc(name: cstring) -> duckdb_scalar_function_set ---
    destroy_scalar_function_set :: proc(scalar_function_set: ^duckdb_scalar_function_set) ---
    add_scalar_function_to_set :: proc(set: duckdb_scalar_function_set, function: duckdb_scalar_function) -> duckdb_state ---
    register_scalar_function_set :: proc(con: duckdb_connection, set: duckdb_scalar_function_set) -> duckdb_state ---
    scalar_function_bind_get_argument_count :: proc(info: duckdb_bind_info) -> idx_t ---
    scalar_function_bind_get_argument :: proc(info: duckdb_bind_info, index: idx_t) -> duckdb_expression ---
    scalar_function_get_state :: proc(info: duckdb_function_info) -> rawptr ---
    scalar_function_set_init :: proc(scalar_function: duckdb_scalar_function, init: duckdb_scalar_function_init_t) ---
    scalar_function_init_set_error :: proc(info: duckdb_init_info, error: cstring) ---
    scalar_function_init_set_state :: proc(info: duckdb_init_info, state: rawptr, destroy: duckdb_delete_callback_t) ---
    scalar_function_init_get_client_context :: proc(info: duckdb_init_info, out_context: ^duckdb_client_context) ---
    scalar_function_init_get_bind_data :: proc(info: duckdb_init_info) -> rawptr ---
    scalar_function_init_get_extra_info :: proc(info: duckdb_init_info) -> rawptr ---
    create_selection_vector :: proc(size: idx_t) -> duckdb_selection_vector ---
    destroy_selection_vector :: proc(sel: duckdb_selection_vector) ---
    selection_vector_get_data_ptr :: proc(sel: duckdb_selection_vector) -> ^sel_t ---
    create_aggregate_function :: proc() -> duckdb_aggregate_function ---
    destroy_aggregate_function :: proc(aggregate_function: ^duckdb_aggregate_function) ---
    aggregate_function_set_name :: proc(aggregate_function: duckdb_aggregate_function, name: cstring) ---
    aggregate_function_add_parameter :: proc(aggregate_function: duckdb_aggregate_function, type: duckdb_logical_type) ---
    aggregate_function_set_return_type :: proc(aggregate_function: duckdb_aggregate_function, type: duckdb_logical_type) ---
    aggregate_function_set_functions :: proc(aggregate_function: duckdb_aggregate_function, state_size: duckdb_aggregate_state_size, state_init: duckdb_aggregate_init_t, update: duckdb_aggregate_update_t, combine: duckdb_aggregate_combine_t, finalize: duckdb_aggregate_finalize_t) ---
    aggregate_function_set_destructor :: proc(aggregate_function: duckdb_aggregate_function, destroy: duckdb_aggregate_destroy_t) ---
    register_aggregate_function :: proc(con: duckdb_connection, aggregate_function: duckdb_aggregate_function) -> duckdb_state ---
    aggregate_function_set_special_handling :: proc(aggregate_function: duckdb_aggregate_function) ---
    aggregate_function_set_extra_info :: proc(aggregate_function: duckdb_aggregate_function, extra_info: rawptr, destroy: duckdb_delete_callback_t) ---
    aggregate_function_get_extra_info :: proc(info: duckdb_function_info) -> rawptr ---
    aggregate_function_set_error :: proc(info: duckdb_function_info, error: cstring) ---
    create_aggregate_function_set :: proc(name: cstring) -> duckdb_aggregate_function_set ---
    destroy_aggregate_function_set :: proc(aggregate_function_set: ^duckdb_aggregate_function_set) ---
    add_aggregate_function_to_set :: proc(set: duckdb_aggregate_function_set, function: duckdb_aggregate_function) -> duckdb_state ---
    register_aggregate_function_set :: proc(con: duckdb_connection, set: duckdb_aggregate_function_set) -> duckdb_state ---
    table_function_get_client_context :: proc(info: duckdb_bind_info, out_context: ^duckdb_client_context) ---
    get_profiling_info :: proc(connection: duckdb_connection) -> duckdb_profiling_info ---
    profiling_info_get_value :: proc(info: duckdb_profiling_info, key: cstring) -> duckdb_value ---
    profiling_info_get_metrics :: proc(info: duckdb_profiling_info) -> duckdb_value ---
    profiling_info_get_child_count :: proc(info: duckdb_profiling_info) -> idx_t ---
    profiling_info_get_child :: proc(info: duckdb_profiling_info, index: idx_t) -> duckdb_profiling_info ---
    appender_create :: proc(connection: duckdb_connection, schema: cstring, table: cstring, out_appender: ^duckdb_appender) -> duckdb_state ---
    appender_create_ext :: proc(connection: duckdb_connection, catalog: cstring, schema: cstring, table: cstring, out_appender: ^duckdb_appender) -> duckdb_state ---
    appender_create_query :: proc(connection: duckdb_connection, query: cstring, column_count: idx_t, types: ^duckdb_logical_type, table_name: cstring, column_names: ^cstring, out_appender: ^duckdb_appender) -> duckdb_state ---
    appender_error_data :: proc(appender: duckdb_appender) -> duckdb_error_data ---
    appender_clear :: proc(appender: duckdb_appender) -> duckdb_state ---
    appender_add_column :: proc(appender: duckdb_appender, name: cstring) -> duckdb_state ---
    appender_clear_columns :: proc(appender: duckdb_appender) -> duckdb_state ---
    append_default :: proc(appender: duckdb_appender) -> duckdb_state ---
    append_default_to_chunk :: proc(appender: duckdb_appender, chunk: duckdb_data_chunk, col: idx_t, row: idx_t) -> duckdb_state ---
    append_bool :: proc(appender: duckdb_appender, value: bool) -> duckdb_state ---
    append_int8 :: proc(appender: duckdb_appender, value: c.int8_t) -> duckdb_state ---
    append_int16 :: proc(appender: duckdb_appender, value: c.int16_t) -> duckdb_state ---
    append_int32 :: proc(appender: duckdb_appender, value: c.int32_t) -> duckdb_state ---
    append_int64 :: proc(appender: duckdb_appender, value: c.int64_t) -> duckdb_state ---
    append_hugeint :: proc(appender: duckdb_appender, value: duckdb_hugeint) -> duckdb_state ---
    append_uint8 :: proc(appender: duckdb_appender, value: c.uint8_t) -> duckdb_state ---
    append_uint16 :: proc(appender: duckdb_appender, value: c.uint16_t) -> duckdb_state ---
    append_uint32 :: proc(appender: duckdb_appender, value: c.uint32_t) -> duckdb_state ---
    append_uint64 :: proc(appender: duckdb_appender, value: c.uint64_t) -> duckdb_state ---
    append_uhugeint :: proc(appender: duckdb_appender, value: duckdb_uhugeint) -> duckdb_state ---
    append_float :: proc(appender: duckdb_appender, value: c.float) -> duckdb_state ---
    append_double :: proc(appender: duckdb_appender, value: c.double) -> duckdb_state ---
    append_date :: proc(appender: duckdb_appender, value: duckdb_date) -> duckdb_state ---
    append_time :: proc(appender: duckdb_appender, value: duckdb_time) -> duckdb_state ---
    append_timestamp :: proc(appender: duckdb_appender, value: duckdb_timestamp) -> duckdb_state ---
    append_interval :: proc(appender: duckdb_appender, value: duckdb_interval) -> duckdb_state ---
    append_varchar :: proc(appender: duckdb_appender, val: cstring) -> duckdb_state ---
    append_varchar_length :: proc(appender: duckdb_appender, val: cstring, length: idx_t) -> duckdb_state ---
    append_blob :: proc(appender: duckdb_appender, data: rawptr, length: idx_t) -> duckdb_state ---
    append_null :: proc(appender: duckdb_appender) -> duckdb_state ---
    append_value :: proc(appender: duckdb_appender, value: duckdb_value) -> duckdb_state ---
    append_data_chunk :: proc(appender: duckdb_appender, chunk: duckdb_data_chunk) -> duckdb_state ---
    table_description_create :: proc(connection: duckdb_connection, schema: cstring, table: cstring, out: ^duckdb_table_description) -> duckdb_state ---
    table_description_create_ext :: proc(connection: duckdb_connection, catalog: cstring, schema: cstring, table: cstring, out: ^duckdb_table_description) -> duckdb_state ---
    table_description_destroy :: proc(table_description: ^duckdb_table_description) ---
    table_description_error :: proc(table_description: duckdb_table_description) -> cstring ---
    column_has_default :: proc(table_description: duckdb_table_description, index: idx_t, out: ^bool) -> duckdb_state ---
    table_description_get_column_count :: proc(table_description: duckdb_table_description) -> idx_t ---
    table_description_get_column_name :: proc(table_description: duckdb_table_description, index: idx_t) -> ^c.char ---
    table_description_get_column_type :: proc(table_description: duckdb_table_description, index: idx_t) -> duckdb_logical_type ---
    to_arrow_schema :: proc(arrow_options: duckdb_arrow_options, types: ^duckdb_logical_type, names: ^cstring, column_count: idx_t, out_schema: rawptr) -> duckdb_error_data ---
    data_chunk_to_arrow :: proc(arrow_options: duckdb_arrow_options, chunk: duckdb_data_chunk, out_arrow_array: rawptr) -> duckdb_error_data ---
    schema_from_arrow :: proc(connection: duckdb_connection, schema: rawptr, out_types: ^duckdb_arrow_converted_schema) -> duckdb_error_data ---
    data_chunk_from_arrow :: proc(connection: duckdb_connection, arrow_array: rawptr, converted_schema: duckdb_arrow_converted_schema, out_chunk: ^duckdb_data_chunk) -> duckdb_error_data ---
    destroy_arrow_converted_schema :: proc(arrow_converted_schema: ^duckdb_arrow_converted_schema) ---
    query_arrow_error :: proc(result: duckdb_arrow) -> cstring ---
    fetch_chunk :: proc(result: duckdb_result) -> duckdb_data_chunk ---
    create_cast_function :: proc() -> duckdb_cast_function ---
    cast_function_set_source_type :: proc(cast_function: duckdb_cast_function, source_type: duckdb_logical_type) ---
    cast_function_set_target_type :: proc(cast_function: duckdb_cast_function, target_type: duckdb_logical_type) ---
    cast_function_set_implicit_cast_cost :: proc(cast_function: duckdb_cast_function, cost: c.int64_t) ---
    cast_function_set_function :: proc(cast_function: duckdb_cast_function, function: duckdb_cast_function_t) ---
    cast_function_set_extra_info :: proc(cast_function: duckdb_cast_function, extra_info: rawptr, destroy: duckdb_delete_callback_t) ---
    cast_function_get_extra_info :: proc(info: duckdb_function_info) -> rawptr ---
    cast_function_get_cast_mode :: proc(info: duckdb_function_info) -> duckdb_cast_mode ---
    cast_function_set_error :: proc(info: duckdb_function_info, error: cstring) ---
    cast_function_set_row_error :: proc(info: duckdb_function_info, error: cstring, row: idx_t, output: duckdb_vector) ---
    register_cast_function :: proc(con: duckdb_connection, cast_function: duckdb_cast_function) -> duckdb_state ---
    destroy_cast_function :: proc(cast_function: ^duckdb_cast_function) ---
    destroy_expression :: proc(expr: ^duckdb_expression) ---
    expression_return_type :: proc(expr: duckdb_expression) -> duckdb_logical_type ---
    expression_is_foldable :: proc(expr: duckdb_expression) -> bool ---
    expression_fold :: proc(context_: duckdb_client_context, expr: duckdb_expression, out_value: ^duckdb_value) -> duckdb_error_data ---
    client_context_get_file_system :: proc(context_: duckdb_client_context) -> duckdb_file_system ---
    destroy_file_system :: proc(file_system: ^duckdb_file_system) ---
    file_system_error_data :: proc(file_system: duckdb_file_system) -> duckdb_error_data ---
    file_system_open :: proc(file_system: duckdb_file_system, path: cstring, options: duckdb_file_open_options, out_file: ^duckdb_file_handle) -> duckdb_state ---
    create_file_open_options :: proc() -> duckdb_file_open_options ---
    file_open_options_set_flag :: proc(options: duckdb_file_open_options, flag: duckdb_file_flag, value: bool) -> duckdb_state ---
    destroy_file_open_options :: proc(options: ^duckdb_file_open_options) ---
    destroy_file_handle :: proc(file_handle: ^duckdb_file_handle) ---
    file_handle_error_data :: proc(file_handle: duckdb_file_handle) -> duckdb_error_data ---
    file_handle_read :: proc(file_handle: duckdb_file_handle, buffer: rawptr, size: c.int64_t) -> c.int64_t ---
    file_handle_write :: proc(file_handle: duckdb_file_handle, buffer: rawptr, size: c.int64_t) -> c.int64_t ---
    file_handle_tell :: proc(file_handle: duckdb_file_handle) -> c.int64_t ---
    file_handle_size :: proc(file_handle: duckdb_file_handle) -> c.int64_t ---
    file_handle_seek :: proc(file_handle: duckdb_file_handle, position: c.int64_t) -> duckdb_state ---
    file_handle_sync :: proc(file_handle: duckdb_file_handle) -> duckdb_state ---
    file_handle_close :: proc(file_handle: duckdb_file_handle) -> duckdb_state ---
    create_config_option :: proc() -> duckdb_config_option ---
    destroy_config_option :: proc(option: ^duckdb_config_option) ---
    config_option_set_name :: proc(option: duckdb_config_option, name: cstring) ---
    config_option_set_type :: proc(option: duckdb_config_option, type: duckdb_logical_type) ---
    config_option_set_default_value :: proc(option: duckdb_config_option, default_value: duckdb_value) ---
    config_option_set_default_scope :: proc(option: duckdb_config_option, default_scope: duckdb_config_option_scope) ---
    config_option_set_description :: proc(option: duckdb_config_option, description: cstring) ---
    register_config_option :: proc(connection: duckdb_connection, option: duckdb_config_option) -> duckdb_state ---
    client_context_get_config_option :: proc(context_: duckdb_client_context, name: cstring, out_scope: ^duckdb_config_option_scope) -> duckdb_value ---
    create_copy_function :: proc() -> duckdb_copy_function ---
    copy_function_set_name :: proc(copy_function: duckdb_copy_function, name: cstring) ---
    copy_function_set_extra_info :: proc(copy_function: duckdb_copy_function, extra_info: rawptr, destructor: duckdb_delete_callback_t) ---
    register_copy_function :: proc(connection: duckdb_connection, copy_function: duckdb_copy_function) -> duckdb_state ---
    destroy_copy_function :: proc(copy_function: ^duckdb_copy_function) ---
    copy_function_set_bind :: proc(copy_function: duckdb_copy_function, bind: duckdb_copy_function_bind_t) ---
    copy_function_bind_set_error :: proc(info: duckdb_copy_function_bind_info, error: cstring) ---
    copy_function_bind_get_extra_info :: proc(info: duckdb_copy_function_bind_info) -> rawptr ---
    copy_function_bind_get_client_context :: proc(info: duckdb_copy_function_bind_info) -> duckdb_client_context ---
    copy_function_bind_get_column_count :: proc(info: duckdb_copy_function_bind_info) -> idx_t ---
    copy_function_bind_get_column_type :: proc(info: duckdb_copy_function_bind_info, col_idx: idx_t) -> duckdb_logical_type ---
    copy_function_bind_get_options :: proc(info: duckdb_copy_function_bind_info) -> duckdb_value ---
    copy_function_bind_set_bind_data :: proc(info: duckdb_copy_function_bind_info, bind_data: rawptr, destructor: duckdb_delete_callback_t) ---
    copy_function_set_global_init :: proc(copy_function: duckdb_copy_function, init: duckdb_copy_function_global_init_t) ---
    copy_function_global_init_set_error :: proc(info: duckdb_copy_function_global_init_info, error: cstring) ---
    copy_function_global_init_get_extra_info :: proc(info: duckdb_copy_function_global_init_info) -> rawptr ---
    copy_function_global_init_get_client_context :: proc(info: duckdb_copy_function_global_init_info) -> duckdb_client_context ---
    copy_function_global_init_get_bind_data :: proc(info: duckdb_copy_function_global_init_info) -> rawptr ---
    copy_function_global_init_get_file_path :: proc(info: duckdb_copy_function_global_init_info) -> cstring ---
    copy_function_global_init_set_global_state :: proc(info: duckdb_copy_function_global_init_info, global_state: rawptr, destructor: duckdb_delete_callback_t) ---
    copy_function_set_sink :: proc(copy_function: duckdb_copy_function, function: duckdb_copy_function_sink_t) ---
    copy_function_sink_set_error :: proc(info: duckdb_copy_function_sink_info, error: cstring) ---
    copy_function_sink_get_extra_info :: proc(info: duckdb_copy_function_sink_info) -> rawptr ---
    copy_function_sink_get_client_context :: proc(info: duckdb_copy_function_sink_info) -> duckdb_client_context ---
    copy_function_sink_get_bind_data :: proc(info: duckdb_copy_function_sink_info) -> rawptr ---
    copy_function_sink_get_global_state :: proc(info: duckdb_copy_function_sink_info) -> rawptr ---
    copy_function_set_finalize :: proc(copy_function: duckdb_copy_function, finalize: duckdb_copy_function_finalize_t) ---
    copy_function_finalize_set_error :: proc(info: duckdb_copy_function_finalize_info, error: cstring) ---
    copy_function_finalize_get_extra_info :: proc(info: duckdb_copy_function_finalize_info) -> rawptr ---
    copy_function_finalize_get_client_context :: proc(info: duckdb_copy_function_finalize_info) -> duckdb_client_context ---
    copy_function_finalize_get_bind_data :: proc(info: duckdb_copy_function_finalize_info) -> rawptr ---
    copy_function_finalize_get_global_state :: proc(info: duckdb_copy_function_finalize_info) -> rawptr ---
    copy_function_set_copy_from_function :: proc(copy_function: duckdb_copy_function, table_function: duckdb_table_function) ---
    table_function_bind_get_result_column_count :: proc(info: duckdb_bind_info) -> idx_t ---
    table_function_bind_get_result_column_name :: proc(info: duckdb_bind_info, col_idx: idx_t) -> cstring ---
    table_function_bind_get_result_column_type :: proc(info: duckdb_bind_info, col_idx: idx_t) -> duckdb_logical_type ---
    client_context_get_catalog :: proc(context_: duckdb_client_context, catalog_name: cstring) -> duckdb_catalog ---
    catalog_get_type_name :: proc(catalog: duckdb_catalog) -> cstring ---
    catalog_get_entry :: proc(catalog: duckdb_catalog, context_: duckdb_client_context, entry_type: duckdb_catalog_entry_type, schema_name: cstring, entry_name: cstring) -> duckdb_catalog_entry ---
    destroy_catalog :: proc(catalog: ^duckdb_catalog) ---
    catalog_entry_get_type :: proc(entry: duckdb_catalog_entry) -> duckdb_catalog_entry_type ---
    catalog_entry_get_name :: proc(entry: duckdb_catalog_entry) -> cstring ---
    destroy_catalog_entry :: proc(entry: ^duckdb_catalog_entry) ---
    create_log_storage :: proc() -> duckdb_log_storage ---
    destroy_log_storage :: proc(log_storage: ^duckdb_log_storage) ---
    log_storage_set_write_log_entry :: proc(log_storage: duckdb_log_storage, function: duckdb_logger_write_log_entry_t) ---
    log_storage_set_extra_data :: proc(log_storage: duckdb_log_storage, extra_data: rawptr, delete_callback: duckdb_delete_callback_t) ---
    log_storage_set_name :: proc(log_storage: duckdb_log_storage, name: cstring) ---
    register_log_storage :: proc(database: duckdb_database, log_storage: duckdb_log_storage) -> duckdb_state ---
    geometry_type_get_crs :: proc(type: duckdb_logical_type) -> ^c.char ---
}
