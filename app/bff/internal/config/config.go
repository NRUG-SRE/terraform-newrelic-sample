package config

import (
	"time"

	env "github.com/caarlos0/env/v7"
)

type (
	AppConfig struct {
		ApmApplicationName      string `env:"APM_APPLICATION_NAME" envDefault:"demo"`
		ApmNewrelicLicenseKey   string `env:"APM_NEWRELIC_LICENSE_KEY"`
		DatabaseDSNWriter       string `env:"DATABASE_DSN_WRITER,notEmpty"`
		DatabaseDSNReader       string `env:"DATABASE_DSN_READER,notEmpty"`
		DatabaseConnMaxLifeTime uint   `env:"DATABASE_CONN_MAX_LIFE_TIME" envDefault:"3600"`
	}
)

func NewAppConfig() (*AppConfig, error) {
	cfg := &AppConfig{}
	if err := env.Parse(cfg); err != nil {
		return nil, err
	}
	return cfg, nil
}

func (c *AppConfig) GetNewRelicConfig() (appName string, licenseKey string) {
	return c.ApmApplicationName, c.ApmNewrelicLicenseKey
}

func (c *AppConfig) GetDatabaseConfig() (dsnWriter string, dsnReader string, connMaxLifeTime time.Duration) {
	return c.DatabaseDSNWriter, c.DatabaseDSNReader, time.Duration(c.DatabaseConnMaxLifeTime) * time.Second
}
