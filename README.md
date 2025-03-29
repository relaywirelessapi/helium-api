# Helium Monorepo

This repository is organized as a monorepo containing multiple projects:

## Projects

- `api/`: Ruby on Rails API backend

## Contributing

We're excited that you're interested in contributing to the Helium API! This guide will help you understand our development process and how you can contribute effectively.

### Getting Started

1. Fork the repository
2. Clone your fork locally
3. Set up the development environment using Docker:
   ```bash
   docker-compose up -d
   ```

### Development Process

1. **Create a Branch**: Create a branch for your work

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**: Write your code following our coding standards

   - Write clear, documented code
   - Include tests for new features
   - Follow existing patterns in the codebase

3. **Test Your Changes**:

   ```bash
   docker-compose exec web bundle exec rspec
   ```

4. **Submit a Pull Request**:
   - Provide a clear description of your changes
   - Reference any related issues
   - Ensure all tests pass
   - Update documentation if needed

### Code Standards

- Follow Ruby style guidelines
- Use Sorbet type annotations
- Write comprehensive tests
- Document public APIs
- Keep commits focused and atomic

### Testing Guidelines

- Write both unit and integration tests
- Use Factory Bot for test data
- Follow our RSpec patterns
- Aim for high test coverage

### Documentation

When adding new features, please:

1. Update API documentation
2. Add code comments where necessary
3. Update relevant guides
4. Include examples of usage

### Need Help?

- Join our Discord community
- Check existing issues and discussions
- Reach out to maintainers

Thank you for contributing to making the Helium API better for everyone!
