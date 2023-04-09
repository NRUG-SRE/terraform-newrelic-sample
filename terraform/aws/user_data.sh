#!/usr/bin/env bash
set -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum install -y git docker
echo "export NEW_RELIC_LICENSE_KEY=${new_relic_license_key}" >> /root/.bash_profile
echo "export APM_APPLICATION_NAME=${apm_application_name}" >> /root/.bash_profile

wget https://go.dev/dl/go1.20.3.linux-arm64.tar.gz
tar -C /usr/local -xzf go1.20.3.linux-arm64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bash_profile

# https://docs.newrelic.com/docs/infrastructure/install-infrastructure-agent/linux-installation/install-infrastructure-monitoring-agent-linux/
echo "license_key: ${new_relic_license_key}" | tee -a /etc/newrelic-infra.yml
curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2/aarch64/newrelic-infra.repo
yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
yum install newrelic-infra -y

# https://matsuand.github.io/docs.docker.jp.onthefly/compose/install/#install-compose-on-linux-systems
mkdir -p /root/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-aarch64 -o /root/.docker/cli-plugins/docker-compose
chmod +x /root/.docker/cli-plugins/docker-compose

systemctl start docker
systemctl enable docker

# TODO: リポジトリ公開後はghコマンドインストールは削除する
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#amazon-linux-2-yum
type -p yum-config-manager >/dev/null || yum install yum-utils -y
yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
yum install gh -y
