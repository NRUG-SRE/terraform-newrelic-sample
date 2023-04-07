package config

import (
	env "github.com/caarlos0/env/v7"
)

type (
	AppConfig struct {
		ApmApplicationName    string `env:"APM_APPLICATION_NAME" envDefault:"demo"`
		ApmNewrelicLicenseKey string `env:"APM_NEWRELIC_LICENSE_KEY"`
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
