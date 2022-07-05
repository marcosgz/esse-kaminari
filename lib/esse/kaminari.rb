# frozen_string_literal: true

require 'esse'
require 'kaminari'
require_relative 'kaminari/version'
require_relative 'kaminari/pagination'

Esse::Search::Query.__send__ :include, Esse::Kaminari::Pagination::SearchQuery
