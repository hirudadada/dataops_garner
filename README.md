# Changelog

## [Unreleased]

## [1.0.0] - 2024-05-31
- v0.0.1 Settings changed
- v0.0.2 Handles for tls of elastic apm server
- v0.0.3.2 Changed table schema from source db
- v0.0.3.3 Elastic apm service provider for customization of config
- Initial release

### Changed
- Use transformations for mapping from inventory
- Use formatter for service name for Elastic Apm agent

### Removed
- Dynamic Repository Instantiation
- Usage of `ELASTIC_APM_SERVICE_NAME` as env

### Fixed
- Bugfix: scanned vulnerability CVE-2024-27281 RDoc RCE vulnerability with .rdoc_options
- Bugfix: provider cannot utilize env `ELASTIC_APM_SERVICE_NAME` if empty as configuration

