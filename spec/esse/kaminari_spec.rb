# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Esse::Kaminari do
  it 'has a version number' do
    expect(Esse::Kaminari::VERSION).not_to be nil
  end

  describe 'Search Query' do
    let(:index) do
      Class.new(Esse::Index)
    end
    let(:definition) { '*' }
    let(:params) { {} }
    let(:query) { index.search(definition, **params) }

    before { allow(::Kaminari.config).to receive_messages(default_per_page: 17) }

    it { expect(query.limit_value).to eq(17) }

    it 'modifies the :from value of query definition' do
      expect {
        query.page(4)
      }.to change { query.definition.values_at(:from, :size) }.from([nil, nil]).to([51, 17])
    end

    it 'modifies the query :from and :size values of query definition' do
      expect {
        query.page(3).per(10)
      }.to change { query.definition.values_at(:from, :size) }.from([nil, nil]).to([20, 10])
    end

    shared_examples_for 'a search request that can be paginated' do
      let(:response) { Esse::Search::Response.new(query, raw_response) }

      before { allow(query).to receive(:response).and_return(response) }

      it { expect(query.results.class).to eq(Kaminari::PaginatableArray) }
      it { expect(query.results.total_count).to eq(100) }
      it { expect(query.results.limit_value).to eq(17) }
      it { expect(query.results.offset_value).to eq(0) }

      context 'when paginating' do
        let(:params) { { from: 4, size: 2 } }

        it { expect(query.results.class).to eq(Kaminari::PaginatableArray) }
        it { expect(query.results.total_count).to eq(100) }
        it { expect(query.results.limit_value).to eq(2) }
        it { expect(query.results.offset_value).to eq(4) }
      end
    end

    context 'when Elasticsearch version is >= 7.0' do
      let(:raw_response) do
        { 'took' => '5', 'timed_out' => false, '_shards' => {'one' => 'OK'},
          'hits' => { 'total' => { 'value' => 100, 'relation' => 'eq' }, 'hits' => (1..17).to_a.map { |i| { '_id' => i } } } }
      end

      it_behaves_like 'a search request that can be paginated'
    end

    context 'when Elasticsearch version is < 7.0' do
      let(:raw_response) do
        {
          'took' => '5', 'timed_out' => false, '_shards' => {'one' => 'OK'},
          'hits' => { 'total' => 100, 'hits' => (1..17).to_a.map { |i| { '_id' => i } } }
        }
      end

      it_behaves_like 'a search request that can be paginated'
    end
  end
end
