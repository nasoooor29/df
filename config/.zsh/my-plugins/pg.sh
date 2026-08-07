#
# Create a PostgreSQL user.
# Usage:
#   pg-user <user> <password>
pg-user() {
    local user="$1"
    local pass="$2"

    [[ $# -eq 2 ]] || {
        echo "Usage: pguser <user> <password>"
        return 1
    }

    sudo -u postgres psql <<EOF
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$user') THEN
        CREATE ROLE "$user" LOGIN PASSWORD '$pass';
    END IF;
END
\$\$;
EOF
}

# Create a PostgreSQL database owned by a user.
# Usage:
#   pg-db <database> <owner>
pg-db() {
    local db="$1"
    local owner="$2"

    [[ $# -eq 2 ]] || {
        echo "Usage: pgdb <database> <owner>"
        return 1
    }

    sudo -u postgres createdb -O "$owner" "$db"
}

# Connect to a database.
# Usage:
#   pg-c <database>
pg-c() {
    [[ $# -eq 1 ]] || {
        echo "Usage: pg-c <database>"
        return 1
    }
    sudo -u postgres psql "$1"
}
# List databases.
# Usage:
#   pg-dbls
pg-dbls() {
    sudo -u postgres psql -l
}
# List tables in a database.
# Usage:
#   pg-tables <database>
pg-tables() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: pg-tables <database>"
        return 1
    fi
    sudo -u postgres psql -d "$1" -c '\dt'
}
# List users/roles.
# Usage:
#   pg-users
pg-users() {
    sudo -u postgres psql -c '\du'
}
