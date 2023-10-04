#!/bin/sh

## Configure env
ARCH=$(uname -m)
OS=$(uname -s| tr '[:upper:]' '[:lower:]')
VERSION="1.6.2"
NOMAD_ADDR=http://127.0.0.1:4646
JOB_VARS="-var=\"OS=${OS}\" -var=\"ARCH=${ARCH}\""

## Download Nomad

wget -O nomad.zip "https://releases.hashicorp.com/nomad/1.6.2/nomad_${VERSION}_${OS}_${ARCH}.zip"
unzip -o nomad.zip
rm nomad.zip

## Run Nomad in dev mode
nomad agent -dev &

sleep 10
nomad job run -var="OS=${OS}" -var="ARCH=${ARCH}" jobs/backend.nomad.hcl
nomad job run -var="OS=${OS}" -var="ARCH=${ARCH}" jobs/frontend.nomad.hcl


