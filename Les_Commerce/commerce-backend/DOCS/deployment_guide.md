# Dukkadee Deployment Guide

## Overview

This document provides comprehensive instructions for deploying the Dukkadee e-commerce platform in various environments. It covers both Dukkadee-hosted and self-hosted deployment options, with detailed configuration steps for each scenario.

## Deployment Options

### 1. Dukkadee-Hosted Solution (Managed)

For merchants using the Dukkadee-hosted solution, deployment is handled automatically by the Dukkadee platform. This section is primarily for Dukkadee platform administrators.

#### Infrastructure Setup

- **Application Servers**: Kubernetes cluster with autoscaling
- **Database**: PostgreSQL with read replicas
- **Caching**: Redis cluster
- **Load Balancing**: NGINX with SSL termination
- **CDN**: Cloudflare for static assets

#### Deployment Process

1. **CI/CD Pipeline**:
   - GitHub Actions for automated testing and deployment
   - Staging environment for pre-production validation
   - Blue-green deployment strategy for zero-downtime updates

2. **Database Migrations**:
   - Automated schema migrations with rollback capability
   - Data migrations for tenant-specific updates

3. **Monitoring and Alerting**:
   - Prometheus for metrics collection
   - Grafana for visualization
   - PagerDuty for on-call alerts

### 2. Self-Hosted Solution

For merchants who prefer to host their own store, the following deployment options are available:

#### Option A: Docker Deployment

1. **Prerequisites**:
   - Docker and Docker Compose
   - 4GB RAM minimum (8GB recommended)
   - 20GB storage minimum

2. **Installation Steps**:
   ```bash
   # Clone the repository
   git clone https://github.com/dukkadee/self-hosted.git
   cd self-hosted

   # Configure environment variables
   cp .env.example .env
   # Edit .env with your settings

   # Start the application
   docker-compose up -d
   ```

3. **Configuration**:
   - Database connection in `.env`
   - API keys for third-party services
   - Domain settings and SSL certificates

4. **Updates**:
   ```bash
   git pull
   docker-compose down
   docker-compose up -d
   ```

#### Option B: Traditional Server Deployment

1. **Prerequisites**:
   - Elixir 1.18.2
   - Erlang/OTP 25
   - PostgreSQL 14+
   - Node.js 16+
   - NGINX or Apache

2. **Installation Steps**:
   ```bash
   # Install dependencies
   mix deps.get
   
   # Setup database
   mix ecto.setup
   
   # Compile assets
   cd assets && npm install && npm run deploy
   cd ..
   
   # Compile application
   MIX_ENV=prod mix compile
   
   # Generate release
   MIX_ENV=prod mix release
   ```

3. **NGINX Configuration**:
   ```nginx
   server {
       listen 80;
       server_name your-store-domain.com;
       
       location / {
           proxy_pass http://localhost:4000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

4. **Systemd Service**:
   ```
   [Unit]
   Description=Dukkadee E-commerce Platform
   After=network.target postgresql.service

   [Service]
   Type=simple
   User=dukkadee
   Group=dukkadee
   WorkingDirectory=/opt/dukkadee
   ExecStart=/opt/dukkadee/_build/prod/rel/dukkadee/bin/dukkadee start
   Restart=on-failure
   RestartSec=5
   Environment=PORT=4000
   Environment=LANG=en_US.UTF-8

   [Install]
   WantedBy=multi-user.target
   ```

#### Option C: Cloud Platform Deployment

##### AWS Deployment

1. **Infrastructure Setup**:
   - EC2 instances or ECS for application servers
   - RDS for PostgreSQL database
   - ElastiCache for Redis
   - S3 for file storage
   - CloudFront for CDN

2. **Deployment Steps**:
   - Use Terraform scripts provided in `/deployment/aws`
   - Configure AWS credentials
   - Adjust parameters in `terraform.tfvars`
   - Run `terraform apply`

##### Azure Deployment

1. **Infrastructure Setup**:
   - Azure App Service for application
   - Azure Database for PostgreSQL
   - Azure Cache for Redis
   - Azure Blob Storage for files
   - Azure CDN for content delivery

2. **Deployment Steps**:
   - Use ARM templates provided in `/deployment/azure`
   - Configure using Azure CLI or Portal
   - Set up CI/CD with Azure DevOps

##### Google Cloud Platform

1. **Infrastructure Setup**:
   - Google Kubernetes Engine for application
   - Cloud SQL for PostgreSQL
   - Memorystore for Redis
   - Cloud Storage for files
   - Cloud CDN for content delivery

2. **Deployment Steps**:
   - Use Kubernetes manifests in `/deployment/gcp`
   - Configure using Google Cloud CLI
   - Set up CI/CD with Cloud Build

## Custom Domain Configuration

### 1. DNS Configuration

For custom domains, configure the following DNS records:

- **A Record**: Point your domain to the server IP address
- **CNAME Record**: For subdomains, point to the main domain
- **MX Records**: For email services if needed
- **TXT Records**: For domain verification

### 2. SSL Certificate Setup

Options for SSL certificates:

1. **Let's Encrypt** (recommended for self-hosted):
   ```bash
   # Install certbot
   apt-get install certbot python3-certbot-nginx
   
   # Obtain certificate
   certbot --nginx -d your-store-domain.com
   ```

2. **Commercial SSL** (optional):
   - Purchase from trusted provider
   - Install according to provider instructions

3. **Managed SSL** (for cloud platforms):
   - AWS Certificate Manager
   - Azure App Service Managed Certificates
   - Google-managed SSL certificates

## Performance Optimization

### 1. Database Optimization

- Implement connection pooling
- Set up read replicas for heavy read operations
- Configure proper indexes for frequently queried fields
- Regular VACUUM and maintenance

### 2. Caching Strategy

- Configure Redis for session storage and caching
- Implement page caching for static content
- Use fragment caching for dynamic components
- Configure proper cache invalidation

### 3. Asset Optimization

- Enable gzip compression
- Configure proper cache headers
- Use a CDN for static assets
- Implement image optimization

## Backup and Disaster Recovery

### 1. Database Backups

- Daily automated backups
- Point-in-time recovery capability
- Offsite backup storage
- Regular backup testing

### 2. Application Backups

- Version-controlled configuration
- Regular snapshots of application state
- Documented recovery procedures

### 3. Disaster Recovery Plan

- Defined RPO (Recovery Point Objective) and RTO (Recovery Time Objective)
- Documented recovery procedures
- Regular disaster recovery drills

## Security Considerations

### 1. Network Security

- Firewall configuration
- DDoS protection
- Network segmentation
- Regular security scanning

### 2. Application Security

- Regular dependency updates
- Security patching
- OWASP Top 10 mitigation
- Regular penetration testing

### 3. Data Security

- Encryption at rest
- Encryption in transit
- Data access controls
- Regular security audits

## Monitoring and Maintenance

### 1. Application Monitoring

- Error tracking and alerting
- Performance monitoring
- User experience monitoring
- Business metrics tracking

### 2. Infrastructure Monitoring

- Server resource utilization
- Database performance
- Network traffic analysis
- Security event monitoring

### 3. Maintenance Procedures

- Scheduled maintenance windows
- Update and patching procedures
- Scaling procedures
- Incident response plan

## Troubleshooting

### Common Issues and Solutions

1. **Database Connection Issues**:
   - Check connection string in configuration
   - Verify network connectivity
   - Check database server status

2. **Application Startup Failures**:
   - Check application logs
   - Verify environment variables
   - Check file permissions

3. **Performance Issues**:
   - Check database query performance
   - Analyze application logs for bottlenecks
   - Monitor resource utilization

4. **SSL/TLS Issues**:
   - Verify certificate installation
   - Check certificate expiration
   - Confirm proper SSL configuration

## Support and Resources

- **Documentation**: [Technical Architecture](technical_architecture.md)
- **Community Forum**: [community.dukkadee.com](https://community.dukkadee.com)
- **Support Email**: support@dukkadee.com
- **GitHub Repository**: [github.com/dukkadee/dukkadee](https://github.com/dukkadee/dukkadee)
