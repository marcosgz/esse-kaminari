# API Reference

## `Esse::Kaminari::Pagination::SearchQuery`

The module included into `Esse::Search::Query` on gem load. You call these methods on the query object returned by `Index#search`.

### Instance methods

| Method | Description |
|--------|-------------|
| `page(n)` | Set the current page (1-indexed). Resets cached response. Returns `self`. |
| `per(n)` | Set items per page. Inherited from `Kaminari::PageScopeMethods`. |
| `limit(n)` | Set the ES `size`. Returns `self`. |
| `offset(n)` | Set the ES `from`. Clears `@page`. Returns `self`. |
| `limit_value` | Returns the current `size` (defaults to `Kaminari.config.default_per_page`). |
| `offset_value` | Returns the current `from`. |
| `total_count` | Total hits from the response (executes if not yet executed). |
| `paginated_results` | Returns `Kaminari::PaginatableArray` wrapping the response hits. |

### Kaminari config delegations

Forwarded to `Kaminari.config`:

- `default_per_page`
- `max_per_page`
- `max_pages`

### Included Kaminari module

`::Kaminari::PageScopeMethods` is included, providing standard Kaminari query helpers:

- `per(num)`
- `padding(num)` (use `.offset(num)` instead for ES)
- Various helpers for page math.

## Integration

On `require 'esse/kaminari'` (or via Gemfile autoload):

```ruby
Esse::Search::Query.__send__(:include, Esse::Kaminari::Pagination::SearchQuery)
```

No plugin registration, no configuration — it's active as soon as the gem is loaded.

## Return type

`paginated_results` returns a `Kaminari::PaginatableArray` built from:

- `limit:` current `limit_value`
- `offset:` current `offset_value`
- `total_count:` response total

This means Kaminari view helpers (`paginate`, `page_entries_info`, `link_to_prev_page`, etc.) work out of the box.

## Notes

- Hits are the raw ES/OS hit hashes — use `hit['_source']` to read document fields.
- For large datasets prefer `.scroll_hits` / `.search_after_hits` rather than deep pagination; ES by default caps `from + size` at 10k.
