package connection

import (
	"fmt"
	"time"

	"github.com/jmoiron/sqlx"
	_ "github.com/newrelic/go-agent/v3/integrations/nrmysql"
)

type (
	Database interface {
		Writer() *sqlx.DB
		Reader() *sqlx.DB
		AllClose()
	}

	database struct {
		writer *sqlx.DB
		reader *sqlx.DB
	}
)

func NewDatabase(writerDSN, readerDSN string, connMaxLife time.Duration) (conns Database, err error) {
	writer, err := newSqlxConn(writerDSN, connMaxLife)
	if err != nil {
		return nil, fmt.Errorf("writer newSqlxConn failed: %v", err)
	}

	reader, err := newSqlxConn(readerDSN, connMaxLife)
	if err != nil {
		return nil, fmt.Errorf("reader newSqlxConn failed: %v", err)
	}

	conns = &database{writer: writer, reader: reader}
	return conns, nil
}

func newSqlxConn(dsn string, connMaxLife time.Duration) (conn *sqlx.DB, err error) {
	conn, err = sqlx.Connect("nrmysql", dsn)
	if err != nil {
		return conn, fmt.Errorf("sql.Open failed: %v", err)
	}
	conn.SetConnMaxLifetime(connMaxLife)
	conn.SetMaxOpenConns(0)
	conn.SetMaxIdleConns(2)
	return conn, nil
}

func (c *database) Writer() *sqlx.DB {
	return c.writer
}

func (c *database) Reader() *sqlx.DB {
	return c.reader
}

func (c *database) AllClose() {
	_ = c.writer.Close()
	_ = c.reader.Close()
}
