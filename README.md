# DNS / DHCP AWS Infrastructure

## Introduction

This repository contains the Terraform code to build the AWS infrastructure for the Ministry of Justice's DNS and DHCP platform. The infrastructure is implemented in AWS and applied using [AWS CodePipelines](https://aws.amazon.com/codepipeline/) specified in the Shared Services management account.

Where possible, the running applications are defined and run as docker containers using [AWS Fargate](https://aws.amazon.com/fargate/) or [ECS](https://aws.amazon.com/ecs/)

## Related Repositories

This repository defines the **system infrastructure only**. Specific components and applications are defined in their own logical external repositories.

- [Shared Services](https://github.com/ministryofjustice/pttp-shared-services-infrastructure)
- [DNS DHCP Admin Portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin)
- [DNS Server](https://github.com/ministryofjustice/staff-device-dns-server)
- [DHCP Server](https://github.com/ministryofjustice/staff-device-dhcp-server)
- [Docker Base Images](https://github.com/ministryofjustice/staff-device-docker-base-images)

The following documentation contains information on how to manage the infrastructure:

- [Authentication with Azure AD](documentation/azure_ad.md)
- [Development Environment](documentation/local_development.md)
- [Corsham Site Tests](documentation/corsham_test.md)

## Architecture

![architecture](diagrams/pttp-dns-dhcp-infra.png)
[Image Source](diagrams/pttp-dns-dhcp-infra.drawio)