#!/bin/bash
HELM_DOCS_VERSION="1.7.0"

curl --silent --show-error --fail --location --output /tmp/helm-docs.tar.gz https://github.com/norwoodj/helm-docs/releases/download/v"${HELM_DOCS_VERSION}"/helm-docs_"${HELM_DOCS_VERSION}"_Linux_x86_64.tar.gz
tar -xf /tmp/helm-docs.tar.gz -C /tmp helm-docs
chmod +x /tmp/helm-docs
/tmp/helm-docs -c $1
