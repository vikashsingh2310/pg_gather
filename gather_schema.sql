--Schema for pg_gather
set client_min_messages=ERROR;
DROP TABLE IF EXISTS pg_gather;
DROP TABLE IF EXISTS pg_get_activity;
DROP TABLE IF EXISTS pg_get_class;
DROP TABLE IF EXISTS pg_get_confs;
DROP TABLE IF EXISTS pg_get_file_confs;
DROP TABLE IF EXISTS pg_get_db;
DROP TABLE IF EXISTS pg_get_index;
DROP TABLE IF EXISTS pg_get_rel;
--DROP TABLE IF EXISTS pg_get_wait;
DROP TABLE IF EXISTS pg_srvr;
DROP TABLE IF EXISTS pg_get_block;
DROP TABLE IF EXISTS pg_pid_wait;
DROP TABLE IF EXISTS pg_replication_stat;
DROP TABLE IF EXISTS pg_archiver_stat;
DROP TABLE IF EXISTS pg_tab_bloat;
DROP TABLE IF EXISTS pg_get_toast;
DROP TABLE IF EXISTS pg_get_statements;
DROP TABLE IF EXISTS pg_get_bgwriter;
DROP TABLE IF EXISTS pg_get_roles;
DROP TABLE IF EXISTS pg_get_extension;

CREATE UNLOGGED TABLE pg_srvr (
    connstr text
);

CREATE UNLOGGED TABLE pg_gather (
    collect_ts timestamp with time zone,
    usr text,
    db text,
    ver text,
    pg_start_ts timestamp with time zone,
    recovery bool,
    client inet,
    server inet,
    reload_ts timestamp with time zone,
    current_wal pg_lsn
);

CREATE UNLOGGED TABLE pg_get_activity (
    datid oid, 
    pid integer,
    usesysid oid,
    application_name text,
    state text,
    query text,
    wait_event_type text,
    wait_event text,
    xact_start timestamp with time zone,
    query_start timestamp with time zone,
    backend_start timestamp with time zone,
    state_change timestamp with time zone,
    client_addr inet,
    client_hostname text,
    client_port integer,
    backend_xid xid,
    backend_xmin xid,
    backend_type text,
    ssl boolean,
    sslversion text,
    sslcipher text,
    sslbits integer,
    sslcompression boolean,
    ssl_client_dn text,
    ssl_client_serial numeric,
    ssl_issuer_dn text,
    gss_auth boolean,
    gss_princ text,
    gss_enc boolean,
    leader_pid integer,
    query_id bigint
);

CREATE UNLOGGED TABLE pg_get_statements(
    userid oid,
    dbid oid,
    query text,
    calls bigint,
    total_time double precision
);

--CREATE UNLOGGED TABLE pg_get_wait(
--    itr integer,
--    pid integer,
--    wait_event text
--);

CREATE UNLOGGED TABLE pg_pid_wait(
    itr SERIAL,
    pid integer,
    wait_event text
);


CREATE UNLOGGED TABLE pg_get_db (
    datid oid,
    datname text,
    xact_commit bigint,
    xact_rollback bigint,
    blks_fetch bigint,
    blks_hit bigint,
    tup_returned bigint,
    tup_fetched bigint,
    tup_inserted bigint,
    tup_updated bigint,
    tup_deleted bigint,
    temp_files bigint,
    temp_bytes bigint,
    deadlocks bigint,
    blk_read_time double precision,
    blk_write_time double precision,
    db_size bigint,
    age integer,
    stats_reset timestamp with time zone
);

CREATE UNLOGGED TABLE pg_get_roles (
    oid oid,
    rolname text,
    rolsuper boolean,
    rolreplication boolean,
    rolconnlimit integer,
    rolconfig text[]
);

CREATE UNLOGGED TABLE pg_get_confs (
    name text,
    setting text,
    unit text,
    source text
);

CREATE UNLOGGED TABLE pg_get_file_confs (
    sourcefile text,
    name text,
    setting text,
    applied boolean,
    error text
);

--TODO : Add relpersistence to the table for identifying the temporary tables
CREATE UNLOGGED TABLE pg_get_class (
    reloid oid,
    relname text,
    relkind char(1),
    relnamespace oid
);

CREATE UNLOGGED TABLE pg_get_index (
    indexrelid oid,
    indrelid oid,
    indisunique boolean,
    indisprimary boolean,
    numscans bigint,
    size bigint
);
--indexrelid - oid of the index
--indrelid - oid of the corresponding table

CREATE UNLOGGED TABLE pg_get_rel (
    relid oid,
    relnamespace oid,
    blks bigint,
    n_live_tup bigint,
    n_dead_tup bigint,
    rel_size bigint,
    tot_tab_size bigint,
    tab_ind_size bigint,
    rel_age bigint,
    last_vac timestamp with time zone,
    last_anlyze timestamp with time zone,
    vac_nos bigint
);

--rel_size is "main" fork size
--tab_size includes toast also

CREATE UNLOGGED TABLE pg_get_block (
    blocked_pid integer,
    blocked_user text,
    blocked_client_addr text,
    blocked_client_hostname text,
    blocked_application_name text,
    blocked_wait_event_type text,
    blocked_wait_event text,
    blocked_statement text,
    blocked_xact_start timestamp with time zone,
    blocking_pid integer,
    blocking_user text,
    blocking_user_addr text,
    blocking_client_hostname text,
    blocking_application_name text,
    blocking_wait_event_type text,
    blocking_wait_event text,
    statement_in_blocking_process text,
    blocking_xact_start timestamp with time zone
);

CREATE UNLOGGED TABLE pg_replication_stat (
    usename text,
    client_addr text,
    client_hostname text,
    state text,
    --xmin_age int,
    sent_lsn pg_lsn,
    write_lsn pg_lsn,
    flush_lsn pg_lsn,
    replay_lsn pg_lsn,
    sync_state text
);

CREATE UNLOGGED TABLE pg_archiver_stat(
    archived_count bigint,
    last_archived_wal text,
    last_archived_time timestamp with time zone,
    last_failed_wal text,
    last_failed_time timestamp with time zone
);


CREATE UNLOGGED TABLE pg_get_toast(
    relid oid,
    toastid oid
);


CREATE UNLOGGED TABLE pg_tab_bloat (
    table_oid oid,
    est_pages bigint
);

CREATE UNLOGGED TABLE pg_get_bgwriter(
    checkpoints_timed bigint,
    checkpoints_req  bigint,
    checkpoint_write_time double precision,
    checkpoint_sync_time double precision,
    buffers_checkpoint bigint,
    buffers_clean bigint,
    maxwritten_clean bigint,
    buffers_backend bigint,
    buffers_backend_fsync bigint,
    buffers_alloc bigint,
    stats_reset timestamp with time zone
);

CREATE UNLOGGED TABLE pg_get_extension(
    oid oid,
    extname text,
    extowner oid,
    extnamespace oid,
    extrelocatable boolean,
    extversion text
);

-- psql -X -f gather.sql > out.txt
-- sed -i '/^Pager/d; /^Tuples/d; /^Output/d; /^SELECT/d; /^PREPARE/d; /^$/d' out.txt; psql -f gather_schema.sql -f out.txt

---Report
-- psql -q -X -f gather_report.sql > out.html