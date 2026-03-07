# CLAUDE.md

Project context for AI-assisted development on the Relay API monorepo.

## What is Relay?

REST API that simplifies access to Helium network data. Instead of requiring customers to interact with Helium's raw AWS S3 protobuf files, Relay serves that data via clean REST endpoints. SaaS subscriptions via Stripe.

## Repository Structure

Monorepo with three components:

```
api/          Rails 8 API backend (Ruby 3.4.1)
docs/         Docusaurus documentation site
terraform/    AWS infrastructure (ECS, S3, etc.)
```

All application code lives under the `api/` directory. Work from there for any Rails changes.

## Key Commands

All commands run inside Docker. Start services first:

```bash
docker-compose up -d
```

### Tests
```bash
docker-compose exec web bundle exec rspec                    # full suite
docker-compose exec web bundle exec rspec spec/requests/     # request specs only
docker-compose exec web bundle exec rspec spec/models/       # model specs only
docker-compose exec web bundle exec rspec spec/path_spec.rb  # single file
```

### Linting
```bash
docker-compose exec web bin/rubocop                          # check style
docker-compose exec web bin/rubocop -A                       # auto-fix
```

### Type Checking
```bash
docker-compose exec web bundle exec spoom srb tc             # Sorbet typecheck
```

### Security
```bash
docker-compose exec web bin/brakeman --no-pager              # security scan
```

### Database
```bash
docker-compose exec web bundle exec rails db:prepare         # create + migrate
docker-compose exec web bundle exec rails db:migrate         # run migrations
docker-compose exec web bundle exec rails db:seed            # seed data
```

## Architecture

### Namespace

Everything is namespaced under `Relay::`. Controllers, models, jobs, blueprints, and lib code all live under this namespace.

### API Routes

Routes are structured as `v1/helium/{layer}/{resource}`:

- **L1 (legacy blockchain)**: accounts, transactions, transaction_actors, dc_burns, gateways, packets, rewards
- **L2 (current Solana era)**: iot_reward_shares, mobile_reward_shares, makers, hotspots
- **Webhooks**: helius (Solana), stripe (billing)

### Key Directories

```
api/app/controllers/relay/api/helium/l1/   # L1 API controllers
api/app/controllers/relay/api/helium/l2/   # L2 API controllers
api/app/controllers/relay/webhooks/        # Webhook handlers
api/app/models/relay/                      # Domain models
api/app/blueprints/relay/api/helium/       # Blueprinter serializers
api/app/jobs/relay/                        # Sidekiq background jobs
api/app/lib/relay/                         # Business logic
api/app/lib/relay/importing/               # S3 data ingestion
api/app/lib/relay/helium/                  # Helium-specific logic
api/app/lib/relay/solana/                  # Solana blockchain integration
api/app/lib/relay/billing/                 # Subscription/payment logic
api/spec/                                  # RSpec tests
```

### Resource Controller Pattern

API controllers inherit from `Relay::Api::ResourceController`. Follow existing controllers as examples when adding new endpoints.

### Serialization

Uses Blueprinter for JSON serialization. Blueprints live in `api/app/blueprints/relay/api/`. Each API resource has a corresponding blueprint.

## Coding Conventions

### Sorbet

- All Ruby files must have a `# typed:` sigil (enforced by RuboCop)
- Add `sig` annotations to new methods
- Run `spoom srb tc` to verify — CI will reject type errors

### RuboCop

- Style based on `rubocop-rails-omakase` with `rubocop-sorbet` plugin
- All new cops enabled (`NewCops: enable`)
- Run `bin/rubocop` before committing — CI will reject offenses

### Testing

- RSpec with FactoryBot for test data, Faker for fake values
- WebMock for HTTP stubbing, VCR for recording external API responses
- Request specs go in `spec/requests/`
- Model specs go in `spec/models/`
- Support helpers in `spec/support/`

### Dependencies

- Sidekiq Pro for background jobs (requires Contribsys gem server credentials)
- PostgreSQL and Redis for data and job queues
- `google-protobuf` for Helium data decoding
- `aws-sdk-s3` for S3 data access
- `solana-ruby-web3js` for Solana integration

## What NOT to Modify

- `terraform/` — infrastructure changes need careful review and planning
- `api/config/credentials*` — managed separately
- `docker-compose.yml` — changes affect all developers
- `api/Gemfile.lock` — only update via `bundle install` after Gemfile changes
- Sidekiq Pro configuration — requires license credentials

## CI Pipeline

CI runs automatically on PRs via GitHub Actions (`.github/workflows/ci.yml`):
1. **lint-ruby**: RuboCop, Brakeman, Sorbet (matrix)
2. **lint-js**: importmap audit
3. **test-ruby**: RSpec suite with Postgres
4. **lint-tf**: Terraform validate
5. **verify-docs**: Docusaurus gen-api-docs check

All checks must pass before merging.
