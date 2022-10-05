# DNS / DHCP AWS Infrastructure

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=flat&logo=github&labelColor=32393F&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fstaff-device-dns-dhcp-infrastructure)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#staff-device-dns-dhcp-infrastructure "Link to report")

## Introduction

This repository contains the Terraform code to build the AWS infrastructure for the Ministry of Justice's DNS and DHCP platform. The infrastructure is implemented in AWS and applied using [AWS CodePipelines](https://aws.amazon.com/codepipeline/) specified in the Shared Services management account.

The running applications are defined and run as docker containers using [AWS Fargate](https://aws.amazon.com/fargate/)

## Related Repositories

This repository defines the **system infrastructure only**. Specific components and applications are defined in their own logical external repositories.

- [Shared Services](https://github.com/ministryofjustice/staff-device-shared-services-infrastructure)
- [DNS DHCP Admin Portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin)
- [DNS Server](https://github.com/ministryofjustice/staff-device-dns-server)
- [DHCP Server](https://github.com/ministryofjustice/staff-device-dhcp-server)
- [Docker Base Images](https://github.com/ministryofjustice/staff-device-docker-base-images)
- [Disaster Recovery](https://github.com/ministryofjustice/staff-device-dns-dhcp-disaster-recovery)
- [Integration Test Scripts](https://github.com/ministryofjustice/staff-device-logging-dns-dhcp-integration-tests)

## Other Documentation

- [Getting Started](documentation/getting-started.md)
- [Authentication with Azure AD](documentation/azure-ad.md)
- [Corsham Site Tests](documentation/corsham-test.md)
- [Deployment](documentation/deployment.md)
- [Secrets Management](documentation/secrets-management.md)
- [Security Logging](documentation/security-logging.md)
- [Networking](documentation/networking.md)
- [Disaster Recovery](documentation/disaster-recovery.md)
- [Incident Reports](documentation/incident-reports.md)

## Architecture

![architecture](diagrams/pttp-dns-dhcp-infra.png)
[Image Source](diagrams/pttp-dns-dhcp-infra.drawio)
