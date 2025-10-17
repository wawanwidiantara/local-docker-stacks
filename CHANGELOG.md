# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-10-17

### Added
- Initial release of Docker Stacks
- MySQL 8.4 service with health checks
- MS SQL Server 2022-CU14 service with health checks
- PostgreSQL 17 Alpine service with health checks
- Redis 7.4 Alpine service with AOF persistence and health checks
- MongoDB 8.0 service with health checks
- MinIO object storage service with health checks
- Makefile for easy service management
- Comprehensive README with usage instructions
- MIT License
- Contributing guidelines
- .gitignore for security
- .env.example template
- Environment variable configurations for all services
- Named volumes for data persistence
- Consistent restart policies across all services
- Production-ready configurations following Docker best practices

### Security
- All services use specific image versions (no `:latest` tags)
- Environment variables for sensitive credentials
- .env files excluded from version control
- Password-protected Redis configuration
- Authentication enabled for all database services

[Unreleased]: https://github.com/your-username/stacks/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/your-username/stacks/releases/tag/v1.0.0
