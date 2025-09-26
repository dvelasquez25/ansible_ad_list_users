# Ansible Active Directory User Listing - Microsoft AD Collection

This Ansible playbook queries Active Directory to list users using the official Microsoft AD collection. It accepts all parameters via command line and includes a configurable limit for the number of users returned.

## Features

- Uses official Microsoft AD collection for better reliability
- List Active Directory users with customizable limits
- Multiple output formats (table, JSON, detailed, CSV export)
- Flexible user name filtering
- Command-line parameter support
- Security best practices with Ansible Vault support
- Comprehensive error handling and validation

## Prerequisites

1. **Ansible**: Version 2.15 or higher (required for Microsoft AD collection)
2. **Collections**: Microsoft AD collection and Ansible Windows collection
3. **Network access**: Your Ansible control node must have access to the AD server
4. **AD credentials**: Valid Active Directory user account with read permissions

## Installation

1. Clone or download this repository:
   ```bash
   git clone <repository-url>
   cd ansible_ad_list_users
   ```

2. Install required Ansible collections:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

   Or manually:
   ```bash
   ansible-galaxy collection install microsoft.ad
   ansible-galaxy collection install ansible.windows
   ```

## Usage

### Basic Usage

```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e user_limit=50
```

### Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `ad_server` | Yes | - | Active Directory server hostname or IP |
| `ad_domain` | Yes | - | Active Directory domain (e.g., example.com) |
| `ad_username` | Yes | - | Username for AD authentication |
| `ad_password` | Yes | - | Password for AD authentication |
| `user_limit` | No | 100 | Maximum number of users to return |
| `output_format` | No | table | Output format: table, json, detailed, csv |
| `search_base` | No | Domain root | Custom LDAP search base DN |
| `user_filter` | No | * | User name filter pattern (wildcards supported) |

### Output Formats

#### Table Format (Default)
Displays users in a formatted table:
```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e output_format='table'
```

#### JSON Format
Returns structured JSON data:
```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e output_format='json'
```

#### Detailed Format
Shows comprehensive information for each user:
```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e output_format='detailed' \
  -e user_limit=10
```

#### CSV Export
Creates a timestamped CSV file:
```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e output_format='csv'
```

### Advanced Usage

#### Search Specific Organizational Unit
```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e search_base='OU=Employees,DC=example,DC=com'
```

#### Filter Users by Name Pattern
```bash
# Find users starting with "john"
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e user_filter='john*'

# Find users containing "smith"
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e user_filter='*smith*'
```

## Security Best Practices

### Using Ansible Vault

For production use, store sensitive credentials in an encrypted vault file:

1. Create a vault file:
   ```bash
   ansible-vault create ad_secrets.yml
   ```

2. Add credentials to the vault:
   ```yaml
   ad_username: 'administrator'
   ad_password: 'YourPassword123!'
   ```

3. Run the playbook with vault:
   ```bash
   ansible-playbook list_ad_users.yml \
     -e ad_server='dc01.example.com' \
     -e ad_domain='example.com' \
     -e user_limit=100 \
     --ask-vault-pass \
     -e @ad_secrets.yml
   ```

### Environment Variables

You can also use environment variables:
```bash
export AD_SERVER='dc01.example.com'
export AD_DOMAIN='example.com'
export AD_USERNAME='administrator'
export AD_PASSWORD='YourPassword123!'

ansible-playbook list_ad_users.yml \
  -e ad_server="$AD_SERVER" \
  -e ad_domain="$AD_DOMAIN" \
  -e ad_username="$AD_USERNAME" \
  -e ad_password="$AD_PASSWORD"
```

## Example Outputs

### Table Format
```
Username             Display Name                   Email                               Department      Title                Status    
----------------------------------------------------------------------------------------------------------------------------------
jdoe                 John Doe                       jdoe@example.com                    IT              Systems Admin        Enabled   
asmith               Alice Smith                    asmith@example.com                  HR              HR Manager           Enabled   
bwilson              Bob Wilson                     bwilson@example.com                 Finance         Accountant           Disabled  
```

### Detailed Format
```
==========================================
Username: jdoe
Display Name: John Doe
Email: jdoe@example.com
Department: IT
Title: Systems Administrator
Distinguished Name: CN=John Doe,OU=Users,DC=example,DC=com
Created: 2023-06-01 12:00:00
Last Logon: 2023-12-01 08:30:15
Account Status: Enabled
Groups: Domain Users, IT Staff, Administrators
```

### CSV Export
Creates a file like `ad_users_export_2023-12-01_14-30-25.csv`:
```csv
Username,Display Name,Email,Department,Title,Distinguished Name,Created,Account Status,Last Logon
"jdoe","John Doe","jdoe@example.com","IT","Systems Administrator","CN=John Doe,OU=Users,DC=example,DC=com","2023-06-01 12:00:00","Enabled","2023-12-01 08:30:15"
"asmith","Alice Smith","asmith@example.com","HR","HR Manager","CN=Alice Smith,OU=Users,DC=example,DC=com","2023-05-15 09:30:00","Enabled","2023-11-30 17:45:22"
```

## Key Differences from LDAP Approach

This implementation uses the Microsoft AD collection which provides:

1. **Better Integration**: Native support for Active Directory operations
2. **Simplified Authentication**: Direct domain authentication without complex LDAP bindings
3. **Rich Object Properties**: Access to AD-specific attributes and properties
4. **Error Handling**: Better error messages and handling for AD-specific issues
5. **Performance**: Optimized queries for Active Directory environments

## Troubleshooting

### Common Issues

1. **Collection not found**: Install Microsoft AD collection with `ansible-galaxy collection install microsoft.ad`
2. **Authentication failure**: Verify username format (use just username, not UPN format)
3. **Permission denied**: Ensure the user has read permissions on Active Directory
4. **Connection timeout**: Verify network connectivity to the domain controller

### Debug Mode

Run with verbose output for troubleshooting:
```bash
ansible-playbook list_ad_users.yml -vvv \
  -e ad_server='dc01.example.com' \
  [other parameters...]
```

### Test Connection

Test with a small limit first:
```bash
ansible-playbook list_ad_users.yml \
  -e ad_server='dc01.example.com' \
  -e ad_domain='example.com' \
  -e ad_username='administrator' \
  -e ad_password='YourPassword123!' \
  -e user_limit=1
```

## Files

- `list_ad_users.yml` - Main Ansible playbook using Microsoft AD collection
- `requirements.yml` - Required Ansible collections
- `run_examples.sh` - Example commands and usage patterns
- `README.md` - This documentation

## License

This project is provided as-is for educational and operational use. Please ensure compliance with your organization's security policies when using in production environments.

## Microsoft AD Collection Documentation

For more information about the Microsoft AD collection, visit:
- [Microsoft AD Collection Documentation](https://docs.ansible.com/ansible/latest/collections/microsoft/ad/)
- [microsoft.ad.user module](https://docs.ansible.com/ansible/latest/collections/microsoft/ad/user_module.html)
- [microsoft.ad.object module](https://docs.ansible.com/ansible/latest/collections/microsoft/ad/object_module.html)
