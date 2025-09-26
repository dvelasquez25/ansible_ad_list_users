# List User Accounts Ansible Playbook for Tower/AWX

This playbook queries user accounts from Active Directory (Windows) or LDAP (Linux) systems and provides flexible filtering and output options. It's optimized for Ansible Tower/AWX deployment.

## 🎯 Features

- **Multi-platform support**: Works with Windows Active Directory and Linux LDAP
- **Tower/AWX optimized**: Uses `hosts: all,!localhost` pattern with limit functionality
- **Flexible filtering**: Filter by username patterns, organizational units, and account status
- **Multiple output formats**: JSON and CSV output options
- **Group membership**: Optional inclusion of group memberships
- **Variable validation**: Ensures required variables are provided
- **Error handling**: Comprehensive error handling and reporting

## 📋 Requirements

### Ansible Collections
Install required collections in Tower/AWX:
```bash
ansible-galaxy collection install -r requirements.yml
```

### Target Systems

#### Windows Targets (Active Directory)
- PowerShell 5.0 or later
- Active Directory PowerShell module
- WinRM configured and accessible
- Service account with read permissions to Active Directory

#### Linux Targets (LDAP)
- Python 3.x
- python-ldap package
- Network access to LDAP server
- Service account with read permissions to LDAP directory

## � Required Variables

These variables **MUST** be provided via Tower/AWX job template extra_vars or survey:

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `action` | string | Operation to perform | `"list_accounts"` |
| `search_filter` | string | Username pattern filter | `"john*"` or `"*"` |
| `account_status_filter` | string | Account status filter | `"enabled"`, `"disabled"`, `"locked"`, `"all"` |
| `operation_timestamp` | string | Timestamp for this operation | `"2025-09-25T10:30:00Z"` |
| `requested_by` | string | Who/what initiated this request | `"ansible_agent"` |

## 🎛️ Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `organizational_unit` | string | `""` | Specific OU to search within |
| `output_format` | string | `"json"` | Output format: `"json"` or `"csv"` |
| `include_groups` | boolean | `false` | Include user group memberships |
| `max_results` | integer | `1000` | Maximum number of results to return |
| `include_attributes` | list | See playbook | User attributes to retrieve |

## 🚀 Tower/AWX Setup

### 1. Import Project
1. Create or use existing project in Tower/AWX
2. Point to repository containing this playbook
3. Sync the project

### 2. Create Job Template
```yaml
Name: "List User Accounts"
Job Type: "Run"
Inventory: "Your Domain Controllers/LDAP Servers"
Project: "Your Project Name"
Playbook: "list_user_accounts.yml"
Credentials: "Domain/LDAP Credentials"
```

### 3. Configure Host Patterns & Limits
- **Host Pattern**: `all,!localhost` (this excludes localhost from execution)
- **Limit**: Use Tower's limit functionality to target specific hosts
  - Example: `dc01.company.com,dc02.company.com`
  - Example: `domain_controllers` (inventory group)
  - Example: `ldap_servers`

### 4. Extra Variables Configuration
```yaml
action: "list_accounts"
search_filter: "*"
account_status_filter: "enabled"
operation_timestamp: "{{ tower_job_launched }}"
requested_by: "tower_user_{{ tower_user_name }}"
organizational_unit: "OU=Users,DC=company,DC=com"
output_format: "json"
include_groups: false
max_results: 1000
```

### 5. Survey Configuration (Optional)
Create a survey in Tower/AWX for easier variable input:

```yaml
Survey Questions:
1. Search Filter:
   - Variable Name: search_filter
   - Question: "Username pattern to search for (* for all)"
   - Answer Type: Text
   - Default: "*"
   
2. Account Status:
   - Variable Name: account_status_filter
   - Question: "Account status filter"
   - Answer Type: Multiple Choice (Single Select)
   - Choices: ["all", "enabled", "disabled", "locked"]
   - Default: "enabled"
   
3. Organizational Unit:
   - Variable Name: organizational_unit
   - Question: "Organizational Unit (leave blank for all)"
   - Answer Type: Text
   - Default: ""
   
4. Output Format:
   - Variable Name: output_format
   - Question: "Output format"
   - Answer Type: Multiple Choice (Single Select)
   - Choices: ["json", "csv"]
   - Default: "json"
   
5. Include Groups:
   - Variable Name: include_groups
   - Question: "Include group memberships"
   - Answer Type: Multiple Choice (Single Select)
   - Choices: ["true", "false"]
   - Default: "false"
```

## 📊 Output Format

### JSON Output
```json
{
  "accounts": [
    {
      "username": "jsmith",
      "display_name": "John Smith",
      "email": "jsmith@company.com",
      "enabled": true,
      "locked": false,
      "last_login": "2025-01-10T14:30:00Z",
      "groups": ["Domain Users", "Developers"]
    }
  ],
  "metadata": {
    "total_accounts": 1,
    "filtered_by": "enabled accounts only",
    "search_filter": "j*",
    "timestamp": "2025-01-15T10:00:00Z"
  }
}
```

### CSV Output
```csv
username,display_name,email,enabled,locked,last_login,groups
jsmith,"John Smith",jsmith@company.com,true,false,2025-01-10T14:30:00Z,"Domain Users;Developers"
```

## 🐛 Troubleshooting

### Common Issues

1. **No results returned**: Check your search filter and ensure target hosts are accessible
2. **Permission errors**: Verify service account has proper AD/LDAP read permissions
3. **Connection timeouts**: Check network connectivity and WinRM/SSH configuration
4. **Invalid OU specified**: Ensure organizational unit path is correct

### Debug Mode
Enable debug output by adding to job template extra variables:
```yaml
debug_output: true
```

## 🔐 Security Considerations

- Use encrypted credentials in Tower/AWX
- Limit service account permissions to read-only
- Consider using vault for sensitive variables
- Review and audit account access regularly

## 📚 Integration with Agent Framework

This playbook is designed to work with the Ansible Agent tools:
- `ansible_list_accounts_tool`: Calls this playbook via Tower API
- Results are parsed and returned to the requesting agent
- Variables are passed through the Tower job template

### Agent Integration Variables
When called via the agent framework, additional variables are automatically set:
- `operation_timestamp`: Current UTC timestamp
- `requested_by`: Identifier of the requesting agent/user
- `action`: Always set to "list_accounts"

## 🚀 Advanced Usage

### Custom Attribute Selection
Modify `include_attributes` to retrieve specific user properties:
```yaml
include_attributes:
  - "sAMAccountName"
  - "displayName"
  - "mail"
  - "department"
  - "title"
  - "manager"
```

### Targeting Specific Domains
Use Tower's limit functionality to target different domains:
```bash
# Job Template Limit field:
prod_domain_controllers    # For production domain
test_domain_controllers    # For test domain
```

