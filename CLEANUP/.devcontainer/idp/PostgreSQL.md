## PostgreSQL DevContainer

> psql --host=localhost --port=5432 --username=postgres

```postgres=#
  \c postgres;
  ALTER USER postgres PASSWORD 'idppassword';
  
  drop database idpdb;
  drop user idpuser;
  
  create database idpdb;
  create user idpuser with encrypted password 'idppassword';
  grant all privileges on database idpdb to idpuser;

  # grant all privileges on database idpdb to postgres;

  \c idpdb;
  # drop database postgres;
```

* psql
  * `\l`  to list all the databases
  * `\c`  databasename to connect to connect specific database
  * `\dt` to list tables in that database


## Install with Homebrew:

```bash
$ brew install postgresql@14
```

(The version number `14` needs to be explicitly stated. The `@` mark designates a version number is specified. If you need an older version of postgres, use `postgresql@13`, for example.)

Run server:

```bash
$ pg_ctl -D /opt/homebrew/var/postgresql@14 start
```

Note: if you’re on Intel, the `/opt/homebrew` probably is `/usr/local`.

Start psql and open database `postgres`, which is the database postgres uses itself to store roles, permissions, and structure:

```bash
$ psql postgres
```

We need to create a role (user) with permissions to login (`LOGIN`) and create databases (`CREATEDB`). In PostgreSQL, there is no difference between users and roles. A user is simply a role with login permissions. The first line below could be rewritten as `CREATE USER myuser;`:

```postgres
postgres-# CREATE ROLE myuser WITH LOGIN;
postgres-# ALTER ROLE myuser CREATEDB;
```

Note that the user has no password. Listing users `\du` should look like this:

```postgres
postgres-# \du
                                    List of roles
  Role name  |                         Attributes                         | Member of 
-------------+------------------------------------------------------------+-----------
 <root user> | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 myuser      | Create DB                                                  | {}
```

Quit psql, because we will login with the new user to create a database:

```postgres
postgres-# \q
```

On shell, open psql with `postgres` database with user `myuser`:

```bash
$ psql postgres -U myuser
```

Note that the postgres prompt looks different, because we’re not logged in as a root user anymore. We’ll create a database and grant all privileges to our user:

```postgres
postgres-> CREATE DATABASE mydatabase;
postgres-> GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
```

List databases to verify:

```postgres
postgres-> \list
```

If you want to connect to a database and list all tables:

```postgres
postgres-> \c mydatabase
mydatabase-> \dt
```

...should print `Did not find any relations.` for an empty database. To quit the postgres CLI:

```
mydatabase-> \q
```

Finally, in a `.env` file for Node.js software development, your database connection string should look like this:

```
PG_CONNECTION_STRING=postgres://myuser@localhost/mydatabase
```

## ~~Installing [PostgreSQL 16 on MacOS](https://www.enterprisedb.com/postgres-tutorials/installation-postgresql-mac-os)~~

```
echo "Checking the process ..."
ps -ef | grep postgres

echo "DOCKERHOST/POSTGRES_HOST Getting dynamically the host IP address in Linux/OSX ..."
export POSTGRES_HOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
```
