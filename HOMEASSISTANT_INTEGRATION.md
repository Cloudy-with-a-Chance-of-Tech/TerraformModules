# Home Assistant Integration Guide

This guide explains how to set up webhook notifications from the Terraform CI/CD pipelines to Home Assistant.

## 🏠 Home Assistant Setup

### 1. Create a Webhook Automation in Home Assistant

Add this to your `configuration.yaml` or create it via the UI:

```yaml
automation:
  - alias: "Terraform Pipeline Notification"
    trigger:
      - platform: webhook
        webhook_id: terraform-pipeline
    action:
      - service: notify.persistent_notification
        data:
          title: "Terraform Pipeline"
          message: >
            Repository: {{ trigger.json.repository }}
            Branch: {{ trigger.json.branch }}
            Status: {{ trigger.json.status }}
            Triggered by: {{ trigger.json.actor }}
      - service: notify.mobile_app_your_device  # Optional: send to mobile
        data:
          title: "Terraform Pipeline {{ trigger.json.status }}"
          message: "{{ trigger.json.repository }} on {{ trigger.json.branch }}"
```

### 2. Get Your Webhook URL

Your webhook URL will be:
```
https://your-homeassistant-url/api/webhook/terraform-pipeline
```

## 🔧 GitHub Actions Configuration

### 1. Add Repository Secret

In your GitHub repository settings, add:
- Secret name: `HOMEASSISTANT_WEBHOOK_URL`
- Secret value: `https://your-homeassistant-url/api/webhook/terraform-pipeline`

### 2. Uncomment the Notification Job

In `.github/workflows/terraform-tests.yml`, uncomment the `notify-homeassistant` job:

```yaml
  notify-homeassistant:
    name: Notify Home Assistant
    runs-on: ubuntu-latest
    needs: [terraform-validation, terraform-security-scan, terraform-plan, integration-tests]
    if: always() && (github.event_name == 'push' && github.ref == 'refs/heads/main')
    
    steps:
    - name: Send Home Assistant Notification
      run: |
        curl -X POST "${{ secrets.HOMEASSISTANT_WEBHOOK_URL }}" \
          -H "Content-Type: application/json" \
          -d '{
            "repository": "${{ github.repository }}",
            "branch": "${{ github.ref_name }}",
            "commit": "${{ github.sha }}",
            "status": "${{ job.status }}",
            "actor": "${{ github.actor }}",
            "title": "Terraform Tests Completed"
          }'
```

## 🚀 Azure DevOps Configuration

### 1. Add Pipeline Variable

In your Azure DevOps pipeline, add a variable:
- Variable name: `HOMEASSISTANT_WEBHOOK_URL`
- Variable value: `https://your-homeassistant-url/api/webhook/terraform-pipeline`
- Keep this value secret: ✅

### 2. Uncomment the Notification Job

In `azure-pipelines.yml`, uncomment the notification job and replace the placeholder.

## 📱 Advanced Home Assistant Integration

### Create a Dashboard Card

```yaml
type: entities
title: Terraform Pipeline Status
entities:
  - entity_id: sensor.last_terraform_pipeline
    name: Last Pipeline
  - entity_id: sensor.terraform_pipeline_status
    name: Status
```

### Create Template Sensors

```yaml
template:
  - sensor:
      - name: "Last Terraform Pipeline"
        state: "{{ states.automation.terraform_pipeline_notification.attributes.last_triggered | default('Never') }}"
      
      - name: "Terraform Pipeline Status"
        state: "{{ state_attr('automation.terraform_pipeline_notification', 'last_status') | default('Unknown') }}"
```

## 🔔 Notification Examples

### Success Notification
```json
{
  "repository": "Cloudy-with-a-Chance-of-Tech/TerraformModules",
  "branch": "main",
  "commit": "7264a6e",
  "status": "success",
  "actor": "thomas",
  "title": "Terraform Tests Completed"
}
```

### Failure Notification
```json
{
  "repository": "Cloudy-with-a-Chance-of-Tech/TerraformModules",
  "branch": "feature-branch",
  "commit": "abc1234",
  "status": "failure",
  "actor": "thomas",
  "title": "Terraform Tests Completed"
}
```

## 🛡️ Security Considerations

1. **Use HTTPS**: Always use HTTPS for webhook URLs
2. **Firewall**: Ensure your Home Assistant instance is accessible from GitHub/Azure
3. **Authentication**: Consider adding webhook authentication if needed
4. **Rate Limiting**: Be aware of Home Assistant's rate limits for webhooks

## 🧪 Testing the Integration

Test your webhook manually:

```bash
curl -X POST "https://your-homeassistant-url/api/webhook/terraform-pipeline" \
  -H "Content-Type: application/json" \
  -d '{
    "repository": "test-repo",
    "branch": "test",
    "status": "success",
    "actor": "test-user",
    "title": "Test Notification"
  }'
```

This should trigger your Home Assistant automation and create a notification.
