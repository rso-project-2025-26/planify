-- Initialize databases for Planify services
-- Create schema for Keycloak
CREATE SCHEMA IF NOT EXISTS keycloak;
GRANT ALL PRIVILEGES ON SCHEMA keycloak TO planify;
