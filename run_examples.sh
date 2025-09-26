#!/bin/bash

# Example script to run the Active Directory user listing playbook
# Using Microsoft AD Collection
# Replace the example values with your actual AD server details

echo "=========================================="
echo "Ansible AD User Listing - Microsoft AD Collection"
echo "=========================================="
echo ""

# Basic example with required parameters
echo "=== Basic Example (Table Output) ==="
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e ad_username='administrator' \\"
echo "  -e ad_password='YourPassword123!' \\"
echo "  -e user_limit=50"
echo ""

# Example with specific search base (OU)
echo "=== Example with Specific OU ==="
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e ad_username='administrator' \\"
echo "  -e ad_password='YourPassword123!' \\"
echo "  -e search_base='OU=Users,DC=example,DC=com' \\"
echo "  -e user_limit=100"
echo ""

# Example with user filter
echo "=== Example with User Name Filter ==="
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e ad_username='administrator' \\"
echo "  -e ad_password='YourPassword123!' \\"
echo "  -e user_filter='john*' \\"
echo "  -e user_limit=25"
echo ""

# Example with JSON output
echo "=== Example with JSON Output ==="
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e ad_username='administrator' \\"
echo "  -e ad_password='YourPassword123!' \\"
echo "  -e output_format='json' \\"
echo "  -e user_limit=25"
echo ""

# Example with detailed output
echo "=== Example with Detailed Output ==="
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e ad_username='administrator' \\"
echo "  -e ad_password='YourPassword123!' \\"
echo "  -e output_format='detailed' \\"
echo "  -e user_limit=10"
echo ""

# Example with CSV export
echo "=== Example with CSV Export ==="
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e ad_username='administrator' \\"
echo "  -e ad_password='YourPassword123!' \\"
echo "  -e output_format='csv' \\"
echo "  -e user_limit=500"
echo ""

# Example using vault for security
echo "=== Example with Ansible Vault (Recommended) ==="
echo "# First create a vault file:"
echo "ansible-vault create ad_secrets.yml"
echo ""
echo "# Add the following content to ad_secrets.yml:"
echo "# ad_username: 'administrator'"
echo "# ad_password: 'YourPassword123!'"
echo ""
echo "# Then run the playbook:"
echo "ansible-playbook list_ad_users.yml \\"
echo "  -e ad_server='dc01.example.com' \\"
echo "  -e ad_domain='example.com' \\"
echo "  -e user_limit=100 \\"
echo "  --ask-vault-pass \\"
echo "  -e @ad_secrets.yml"
echo ""

# Installation instructions
echo "=== Installation Requirements ==="
echo "# Install Microsoft AD collection:"
echo "ansible-galaxy collection install -r requirements.yml"
echo ""
echo "# Or manually:"
echo "ansible-galaxy collection install microsoft.ad"
echo "ansible-galaxy collection install ansible.windows"
echo ""

# Common parameters
echo "=== Available Parameters ==="
echo "Required:"
echo "  ad_server       - AD Domain Controller hostname/IP"
echo "  ad_domain       - AD domain name (e.g., example.com)"
echo "  ad_username     - AD username for authentication"
echo "  ad_password     - AD password for authentication"
echo ""
echo "Optional:"
echo "  user_limit      - Max users to return (default: 100)"
echo "  output_format   - table|json|detailed|csv (default: table)"
echo "  search_base     - Custom LDAP search base DN"
echo "  user_filter     - User name filter pattern (default: *)"
echo ""

# Troubleshooting
echo "=== Troubleshooting ==="
echo "# Run with verbose output:"
echo "ansible-playbook list_ad_users.yml -vvv [parameters...]"
echo ""
echo "# Test connectivity:"
echo "ansible-playbook list_ad_users.yml -e user_limit=1 [parameters...]"
echo ""
