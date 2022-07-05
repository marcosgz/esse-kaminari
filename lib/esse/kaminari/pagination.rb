# frozen_string_literal: true

module Esse
  module Kaminari
    module Pagination
      module SearchQuery
        def self.included(base)
          base.__send__ :include, ::Kaminari::PageScopeMethods
          base.__send__ :extend, Forwardable
          base.__send__ :def_delegators, :_kaminari_config, :default_per_page, :max_per_page, :max_pages

          base.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # Define the `page` Kaminari method
            #
            # @param [Integer] page
            # @return [self]
            def #{::Kaminari.config.page_method_name}(num=nil)
              reset!

              definition.update(
                size: limit_value,
                from: (limit_value * ([num.to_i, 1].max - 1))
              )

              self
            end
          RUBY
        end

        def limit_value
          (raw_limit_value || default_per_page).to_i
        end

        def offset_value
          raw_offset_value.to_i
        end

        def total_count
          response.total 
        end

        def paginated_results
          ::Kaminari.paginate_array(response.hits, limit: limit_value, offset: offset_value, total_count: total_count)
        end

        def limit(value)
          definition.update(size: value)
          self
        end

        def offset(value)
          definition.update(from: value)
          self
        end

        private

        def _kaminari_config
          ::Kaminari.config
        end
      end
    end
  end
end
