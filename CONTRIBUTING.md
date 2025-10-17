# Contributing to Docker Stacks

First off, thank you for considering contributing to Docker Stacks! It's people like you that make this project better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by respect and professionalism. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples**
* **Describe the behavior you observed and what you expected**
* **Include logs and error messages**
* **Specify your environment** (OS, Docker version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

* **Use a clear and descriptive title**
* **Provide a detailed description of the suggested enhancement**
* **Explain why this enhancement would be useful**
* **List any alternatives you've considered**

### Adding New Services

Want to add a new database or service? Great! Please follow these guidelines:

1. **Create a new directory** for your service
2. **Include these files:**
   - `compose.yaml` - Docker Compose configuration
   - `.env` - Environment variables template
3. **Follow the existing patterns:**
   - Use specific image versions (not `:latest`)
   - Include health checks
   - Add restart policy: `unless-stopped`
   - Use named volumes for data persistence
   - Include clear environment variable names
4. **Update documentation:**
   - Add service to README.md table
   - Include connection examples
   - Document any special considerations
5. **Update Makefile:**
   - Add service to the loops in `up-all`, `down-all`, and `ps-all` targets

### Pull Request Process

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the style guidelines below
3. **Test your changes thoroughly:**
   ```bash
   # Test starting the service
   make up <service-name>
   
   # Verify health checks pass
   docker ps
   
   # Test stopping the service
   make down <service-name>
   
   # Test cleanup
   make clean <service-name>
   ```
4. **Update documentation** if needed
5. **Commit your changes** with clear, descriptive messages
6. **Push to your fork** and submit a pull request

#### Pull Request Guidelines

* **One feature per PR** - Keep PRs focused on a single enhancement or bug fix
* **Clear title and description** - Explain what changes you made and why
* **Reference issues** - Link to any related issues
* **Update CHANGELOG** - Add a line describing your change (if applicable)
* **No merge conflicts** - Rebase on latest main before submitting

## Style Guidelines

### Docker Compose Files

```yaml
services:
  service-name:
    image: specific-version  # Always use specific versions
    container_name: descriptive-name-container
    restart: unless-stopped  # Consistent restart policy
    environment:
      VAR_NAME: ${VAR_NAME}  # Use environment variables
    ports:
      - "port:port"
    volumes:
      - volume-name:/path/in/container
    healthcheck:  # Always include health checks
      test: ["CMD", "command", "args"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  volume-name:
    driver: local
```

### Environment Files

```bash
# Clear section headers
# ====================
# Service Name
# ====================

# Descriptive variable names
SERVICE_SETTING=value

# Include comments for complex settings
# This setting controls XYZ behavior
COMPLEX_SETTING=value
```

### Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

**Examples:**
```
Add PostgreSQL 17 support

Update MySQL to version 8.4
- Add health check configuration
- Update environment variables
- Fixes #123
```

### Documentation

* Use clear, concise language
* Include code examples where helpful
* Keep formatting consistent with existing docs
* Test all commands before documenting them

## Testing Checklist

Before submitting a PR, verify:

- [ ] Service starts successfully with `make up <service>`
- [ ] Health check passes (check with `docker ps`)
- [ ] Service can be accessed on specified ports
- [ ] Environment variables work correctly
- [ ] Service stops cleanly with `make down <service>`
- [ ] Volumes persist data correctly
- [ ] Clean operation removes everything (`make clean <service>`)
- [ ] Documentation is updated
- [ ] .env.example includes new variables (if applicable)
- [ ] Makefile works with new service (if applicable)

## Project Structure

```
stacks/
├── README.md              # Main documentation
├── LICENSE               # MIT License
├── CONTRIBUTING.md       # This file
├── Makefile             # Service management
├── .gitignore           # Git ignore patterns
├── .env.example         # Environment template
├── service-name/
│   ├── compose.yaml     # Docker Compose config
│   └── .env            # Environment variables (not committed)
└── ...
```

## Questions?

Feel free to open an issue with the `question` label or reach out to the maintainers.

## Recognition

Contributors will be recognized in the project documentation. Thank you for your contributions!

---

**Remember:** The goal is to keep local development environments clean and make it easy for developers to spin up services they need. Keep it simple, documented, and reliable.
