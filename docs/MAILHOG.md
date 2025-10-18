# MailHog Documentation

## 📦 Service Details

| Property        | Value                  |
| --------------- | ---------------------- |
| **Version**     | v1.0.1                 |
| **SMTP Port**   | 1025                   |
| **Web UI Port** | 8025                   |
| **Container**   | mailhog-container      |
| **Image**       | mailhog/mailhog:v1.0.1 |

---

## 🎯 What is MailHog?

MailHog is an email testing tool for developers. It captures emails sent from your application and displays them in a web interface - perfect for testing without sending real emails.

### Key Features:

- 📧 **Email Capture** - Catches all outgoing emails
- 🌐 **Web Interface** - View emails in browser
- 🔍 **Search & Filter** - Find emails quickly
- 📱 **Responsive UI** - Works on mobile
- 🔌 **API Access** - RESTful API for automation
- 💾 **No Database** - Simple and lightweight

---

## 🚀 Quick Start

```bash
# Start MailHog
make up mailhog

# Access Web UI
# http://localhost:8025

# Check status
make ps mailhog

# View logs
make logs mailhog
```

---

## 🔧 Configuration

### Ports

- **SMTP Server:** 1025 (for sending emails)
- **Web UI:** 8025 (for viewing emails)

### SMTP Settings

Configure your application to send emails through MailHog:

```
Host: localhost
Port: 1025
Username: (leave empty)
Password: (leave empty)
TLS/SSL: No
```

---

## 🔌 Using MailHog

### Python (smtplib)

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Create message
msg = MIMEMultipart()
msg['From'] = 'sender@example.com'
msg['To'] = 'recipient@example.com'
msg['Subject'] = 'Test Email'

body = 'This is a test email sent through MailHog'
msg.attach(MIMEText(body, 'plain'))

# Send via MailHog
with smtplib.SMTP('localhost', 1025) as server:
    server.send_message(msg)

print("Email sent! Check http://localhost:8025")
```

### Node.js (nodemailer)

```javascript
const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransporter({
  host: "localhost",
  port: 1025,
  secure: false,
  ignoreTLS: true,
});

const mailOptions = {
  from: "sender@example.com",
  to: "recipient@example.com",
  subject: "Test Email",
  text: "This is a test email sent through MailHog",
  html: "<p>This is a <strong>test email</strong> sent through MailHog</p>",
};

await transporter.sendMail(mailOptions);
console.log("Email sent! Check http://localhost:8025");
```

### PHP (PHPMailer)

```php
<?php
use PHPMailer\PHPMailer\PHPMailer;

$mail = new PHPMailer();
$mail->isSMTP();
$mail->Host = 'localhost';
$mail->Port = 1025;
$mail->SMTPAuth = false;

$mail->setFrom('sender@example.com');
$mail->addAddress('recipient@example.com');
$mail->Subject = 'Test Email';
$mail->Body = 'This is a test email sent through MailHog';

$mail->send();
echo 'Email sent! Check http://localhost:8025';
?>
```

### Django Settings

```python
# settings.py
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'localhost'
EMAIL_PORT = 1025
EMAIL_USE_TLS = False
EMAIL_USE_SSL = False
```

### Laravel Config

```php
// .env
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

### Ruby on Rails

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'localhost',
  port: 1025
}
```

---

## 🌐 Web Interface

### Features

Access http://localhost:8025 to:

- 📬 **View all captured emails**
- 🔍 **Search emails** by subject, sender, recipient
- 📄 **View HTML and plain text** versions
- 📎 **Download attachments**
- 🗑️ **Delete emails** (clear inbox)
- 🔄 **Auto-refresh** for new emails

### API Endpoints

MailHog provides a RESTful API:

```bash
# Get all messages
curl http://localhost:8025/api/v2/messages

# Get specific message
curl http://localhost:8025/api/v2/messages/{message_id}

# Delete all messages
curl -X DELETE http://localhost:8025/api/v1/messages

# Search messages
curl http://localhost:8025/api/v2/search?kind=to&query=user@example.com
```

### Python API Example

```python
import requests

# Fetch all emails
response = requests.get('http://localhost:8025/api/v2/messages')
messages = response.json()

for msg in messages['items']:
    print(f"From: {msg['From']['Mailbox']}@{msg['From']['Domain']}")
    print(f"Subject: {msg['Content']['Headers']['Subject'][0]}")
    print(f"Body: {msg['Content']['Body']}")
    print("---")

# Delete all emails
requests.delete('http://localhost:8025/api/v1/messages')
```

---

## 🔌 Integration with Other Services

### From Docker Network

When running applications in Docker, use the container name:

```python
# Python example for dockerized app
with smtplib.SMTP('mailhog-container', 1025) as server:
    server.send_message(msg)
```

### Testing Email Workflows

```python
# Test registration email
def test_user_registration():
    # Register user
    register_user(email='test@example.com')

    # Check MailHog for confirmation email
    response = requests.get('http://localhost:8025/api/v2/messages')
    messages = response.json()['items']

    # Verify email was sent
    assert any(
        'test@example.com' in msg['To'][0]['Mailbox']
        for msg in messages
    )

    # Extract confirmation link
    latest_email = messages[0]
    body = latest_email['Content']['Body']
    confirmation_link = extract_link(body)

    # Test confirmation
    confirm_email(confirmation_link)
```

---

## 💡 Common Use Cases

### 1. **Local Development**

Test email functionality without sending real emails.

### 2. **Integration Testing**

Verify email workflows in automated tests.

### 3. **Email Design**

Preview HTML emails before deployment.

### 4. **Debugging**

Inspect email content and headers.

### 5. **Demo Environments**

Capture emails in staging/demo environments.

---

## 🐛 Troubleshooting

### Cannot Access Web UI

```bash
# Check if container is running
docker ps | grep mailhog

# Check logs
make logs mailhog

# Restart service
make restart mailhog
```

### Emails Not Appearing

1. Verify SMTP settings (host: localhost, port: 1025)
2. Check MailHog logs for errors
3. Try sending test email via curl:

```bash
curl smtp://localhost:1025 \
  --mail-from sender@example.com \
  --mail-rcpt recipient@example.com \
  --upload-file - << EOF
From: sender@example.com
To: recipient@example.com
Subject: Test Email

This is a test.
EOF
```

---

## 📚 Resources

- **Official Docs:** https://github.com/mailhog/MailHog
- **API Documentation:** https://github.com/mailhog/MailHog/blob/master/docs/APIv2.md
- **Docker Hub:** https://hub.docker.com/r/mailhog/mailhog

---

## 🎯 Best Practices

1. **Don't use in production** - MailHog is for development/testing only
2. **Clear emails regularly** - Prevents memory buildup
3. **Use for automated tests** - Verify email content in CI/CD
4. **Check both HTML and text** - Ensure both versions render correctly
5. **Test with real email addresses** - Some validation might check format

---

## 📈 Advanced Tips

### Automated Email Testing

```python
import pytest
import requests
import time

@pytest.fixture
def clear_mailhog():
    """Clear MailHog before each test"""
    requests.delete('http://localhost:8025/api/v1/messages')
    yield
    requests.delete('http://localhost:8025/api/v1/messages')

def test_welcome_email(clear_mailhog):
    # Trigger email
    send_welcome_email('user@example.com')

    # Wait for email
    time.sleep(1)

    # Fetch from MailHog
    response = requests.get('http://localhost:8025/api/v2/messages')
    messages = response.json()['items']

    # Assertions
    assert len(messages) == 1
    assert 'Welcome' in messages[0]['Content']['Headers']['Subject'][0]
    assert 'user@example.com' in messages[0]['To'][0]['Mailbox']
```

---

**Need help?** Check the [main README](../README.md) or [MailHog GitHub](https://github.com/mailhog/MailHog).
