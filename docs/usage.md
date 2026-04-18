# Usage Guide

## Installation

```ruby
# Gemfile
gem 'esse'
gem 'kaminari'
gem 'esse-kaminari'
```

On load the gem `include`s `Esse::Kaminari::Pagination::SearchQuery` into `Esse::Search::Query`. Nothing else to configure.

## Paginating a search

```ruby
query = UsersIndex
  .search(body: { query: { match_all: {} } })
  .page(params[:page])
  .per(20)

query.total_count         # total hits
query.limit_value         # => 20
query.offset_value        # => (page - 1) * 20
```

## Rendering with Kaminari helpers

`paginated_results` returns a `Kaminari::PaginatableArray` so standard Kaminari helpers work:

```erb
<%= paginate @search.paginated_results %>
<% @search.paginated_results.each do |hit| %>
  <li><%= hit.dig('_source', 'name') %></li>
<% end %>
```

Note that `paginated_results` wraps the raw ES hits — use `hit['_source']` to reach your document fields.

## Mix-and-match with `limit` / `offset`

You can use the lower-level methods interchangeably:

```ruby
query = UsersIndex.search(body: { ... }).limit(50).offset(200)
```

Calling `.offset` clears `.page`, and vice versa, to avoid conflicting state.

## Chaining with other modifiers

```ruby
query = UsersIndex
  .search(body: { query: { match: { name: 'john' } } })
  .page(3)
  .per(25)

query.response.total
query.paginated_results
```

`.response` triggers the actual HTTP call — everything before that is lazy.

## Kaminari configuration

Standard Kaminari defaults apply:

```ruby
# config/initializers/kaminari.rb
Kaminari.configure do |config|
  config.default_per_page = 25
  config.max_per_page = 100
  config.max_pages = 1_000
end
```

Access them from a query:

```ruby
query.default_per_page
query.max_per_page
query.max_pages
```

## Patterns

### Search service with pagination

```ruby
class UserSearch
  def initialize(q:, page: 1, per: 20)
    @q, @page, @per = q, page, per
  end

  def call
    UsersIndex
      .search(body: body)
      .page(@page)
      .per(@per)
  end

  private

  def body
    {
      query: { multi_match: { query: @q, fields: %w[name email] } },
      sort:  [{ created_at: 'desc' }]
    }
  end
end

result = UserSearch.new(q: 'john', page: params[:page]).call
result.paginated_results
```

### Iterating all pages

For iterating all results, prefer `.scroll_hits` from core Esse rather than paging:

```ruby
UsersIndex.search(body: { query: { match_all: {} } }).scroll_hits(batch_size: 1_000) do |batch|
  batch.each { |hit| ... }
end
```

Pagination is best for user-facing pages with `.page(n).per(x)`.
