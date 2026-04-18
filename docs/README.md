# esse-kaminari

[Kaminari](https://github.com/kaminari/kaminari) pagination for [Esse](../../esse/docs/README.md) search queries.

## Contents

- [Usage guide](usage.md)
- [API reference](api.md)

## Install

```ruby
# Gemfile
gem 'esse'
gem 'kaminari'
gem 'esse-kaminari'
```

No configuration is needed. The gem automatically mixes pagination methods into every `Esse::Search::Query`.

## Quick start

```ruby
@search = UsersIndex
  .search(body: { query: { match: { name: params[:q] } } })
  .page(params[:page])
  .per(10)

@users = @search.paginated_results
```

In the view:

```erb
<%= paginate @users %>
<% @users.each do |hit| %>
  <%= hit['_source']['name'] %>
<% end %>
```

## What's added

Methods added to `Esse::Search::Query`:

- `.page(n)` — set the current page (chainable).
- `.per(n)` — inherited from Kaminari; set per-page size.
- `.limit(n)` / `.offset(n)` — low-level alternatives.
- `.total_count` — total hits.
- `.paginated_results` — Kaminari `PaginatableArray` of hits.

## Version

- Version: **0.1.1**
- Ruby: `>= 2.4.0`
- Depends on: `esse`, `kaminari`

## License

MIT.
