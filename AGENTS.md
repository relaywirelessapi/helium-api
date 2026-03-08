# AGENTS.md

## Purpose

- Production monorepo for Relay API — a REST data-access product for Helium network data (L1 blockchain + L2 Solana/Oracle)
- Includes API backend, billing/dashboard UI, background ingestion, docs site, and infrastructure definitions
- Optimize for: preserving public API contracts, using existing patterns, minimal diffs

## Required workflow

All commands run inside Docker from the repo root.

```bash
# Start services
docker-compose up -d

# Tests (MUST pass before submitting changes)
docker-compose exec web bundle exec rspec                     # full suite
docker-compose exec web bundle exec rspec spec/requests/      # request specs
docker-compose exec web bundle exec rspec spec/path_spec.rb   # single file

# Lint (MUST pass)
docker-compose exec web bin/rubocop         # check
docker-compose exec web bin/rubocop -A      # auto-fix

# Type check (MUST pass)
docker-compose exec web bundle exec spoom srb tc

# Security scan (MUST pass)
docker-compose exec web bin/brakeman --no-pager

# Database
docker-compose exec web bundle exec rails db:prepare          # create + migrate
docker-compose exec web bundle exec rails db:migrate          # migrations only
```

CI runs all of the above automatically on PRs via `.github/workflows/ci.yml`. All checks must pass before merge.

## Implementation rules

### Hard requirements

- Every Ruby file must have a `# typed:` sigil at the top (enforced by RuboCop `Sorbet/HasSigil`)
- All API controllers must inherit from `Relay::Api::ResourceController` — it provides auth, rate limiting, usage accounting, pagination, error handling, and analytics. Never bypass these.
- Use `build_and_validate_contract(ContractClass)` for parameter validation in controllers. Define contracts as inner classes inheriting `Relay::Api::Contract`.
- Use Blueprinter for all JSON serialization. One blueprint per resource at `api/app/blueprints/relay/api/helium/`.
- Use `paginate()` and `render_collection()` from ResourceController for list endpoints. Pagination defaults: 50/page, max 100 (Kaminari config).
- Request specs are the contract tests for public API endpoints. Any API change requires a corresponding request spec.
- All code is namespaced under `Relay::`.

### Where things go

| What | Where |
|------|-------|
| API controllers | `api/app/controllers/relay/api/helium/{l1,l2}/` |
| Models | `api/app/models/relay/` |
| Blueprints | `api/app/blueprints/relay/api/helium/` |
| Business logic | `api/app/lib/relay/` |
| Background jobs | `api/app/jobs/relay/` |
| Request specs | `api/spec/requests/relay/helium/{l1,l2}/` |
| Model specs | `api/spec/models/relay/` |
| Factories | `api/spec/factories/` |

### Do not modify without explicit approval

- `terraform/` — infrastructure definitions
- `docker-compose.yml` — shared dev environment
- `api/config/initializers/sidekiq.rb` — Sidekiq Pro config
- `api/config/initializers/pay.rb` — billing config
- `api/config/initializers/devise.rb` — auth config
- `api/app/controllers/relay/api/resource_controller.rb` — shared API base (auth, rate limits, usage)
- Rate limit values (120/min authenticated, 60/min unauthenticated)
- Public API response envelope structure (`{ records: [], meta: { pagination: {} } }`)

## Repository-specific conventions

### API response format

Collections return: `{ records: [...], meta: { pagination: { count, total_pages, current_page, next_page, prev_page } } }`.
Single resources return the object directly (no wrapper).

### Controller pattern

```ruby
# typed: false
module Relay::Api::Helium::L1
  class ThingsController < Relay::Api::ResourceController
    class IndexContract < Relay::Api::ResourceController::IndexContract
      attribute :some_filter, :string
      # add filter-specific validations
    end

    def index
      contract = build_and_validate_contract(IndexContract)
      things = Relay::Helium::L1::Thing.all
      things = things.where(some_filter: contract.some_filter) if contract.some_filter.present?
      render json: render_collection(paginate(things), blueprint: ThingBlueprint)
    end
  end
end
```

### Test pattern

```ruby
# typed: false
RSpec.describe "/helium/l1/things", type: :request do
  describe "GET /" do
    it "returns a list of things" do
      thing = create(:helium_l1_thing)
      api_get(helium_l1_things_path)
      expect(parsed_response).to be_paginated_collection.with([thing])
    end
  end
end
```

Test helpers available in request specs:
- `api_get(path, params:, headers:)` — makes authenticated GET request (creates user automatically)
- `parsed_response` — parsed JSON response body
- `be_paginated_collection.with(records)` — custom matcher for paginated responses

### Style

- RuboCop config: `rubocop-rails-omakase` + `rubocop-sorbet`, all new cops enabled
- Ruby 3.4.1, Rails 8

## Pitfalls

- **Sidekiq Pro**: `bundle install` requires `BUNDLE_GEMS__CONTRIBSYS__COM` env var with a valid Contribsys token. Without it, the build fails. This is set as a Docker build arg in docker-compose.yml — ensure `.env` has it.
- **Big integers**: `config.active_record.raise_int_wider_than_64bit = false` is set intentionally for Helium L2 reward amounts. Do not re-enable.
- **Sorbet + Spoom**: Typecheck command is `bundle exec spoom srb tc`, not `bundle exec srb tc` directly.
- **Brakeman**: Uses `--ensure-latest` flag (see `bin/brakeman`). Exit code 5 means security warnings — these block CI.
- **BlueprinterActiveRecord**: Auto-preloader is enabled. Blueprints automatically optimize N+1 queries — do not add manual `includes` unless the preloader misses something.
- **Feature gating**: Some endpoints require plan-level feature flags via `require_feature!(FeatureClass)`. Check existing controllers for the pattern.
- **Ingestion pipeline**: Data comes from scheduled S3 pulls (Clockwork → `ScheduleFileDefinitionPullsJob`, hourly). Changes to importing logic, file definitions, or webhook handlers affect downstream API data correctness.
- **Usage accounting**: Every API request increments the user's usage counter (`after_action :increment_api_usage`). This is product-critical billing behavior.
- **VCR cassettes**: External HTTP calls in tests may be recorded. If you add new external calls, record cassettes with `VCR.use_cassette`.
- **No ActiveStorage, ActionCable, ActionMailbox, or ActionText** — these are explicitly not loaded.

## Minimal architecture context

- **Monorepo**: `api/` (Rails), `docs/` (Docusaurus), `terraform/` (AWS/ECS)
- **API layer**: REST under `/v1/helium/{l1,l2}/`. L1 = legacy blockchain data. L2 = current Solana-era Oracle data.
- **Data flow**: S3 protobuf files → Sidekiq import jobs → PostgreSQL → REST API
- **Auth**: Bearer API key (not Devise sessions) for API endpoints. Devise for dashboard UI.
- **Billing**: Stripe via Pay gem. Usage-based limits enforced per-request in ResourceController.
- **Background**: Sidekiq Pro (jobs), Clockwork (scheduler), Redis (queues)
