# typed: strict

module Connections
  class ActiveRecordConnection < GraphQL::Pagination::Connection
    extend T::Sig

    sig { returns(T::Array[T.untyped]) }
    def nodes
      sort_column, sort_direction = extract_sort_info
      query = apply_cursor_filters(items, sort_column, sort_direction)
      query = apply_limit(query)
      query.to_a
    end

    sig { returns(T::Boolean) }
    def has_next_page
      return false if nodes.empty?

      sort_column, sort_direction = extract_sort_info
      last_node = nodes.last
      items.where("#{sort_column} #{sort_direction == :asc ? '>' : '<'} ?", last_node.public_send(sort_column)).exists?
    end

    sig { returns(T::Boolean) }
    def has_previous_page
      return false if nodes.empty?

      sort_column, sort_direction = extract_sort_info
      first_node = nodes.first
      items.where("#{sort_column} #{sort_direction == :asc ? '<' : '>'} ?", first_node.public_send(sort_column)).exists?
    end

    sig { params(item: T.untyped).returns(String) }
    def cursor_for(item)
      sort_column, _sort_direction = extract_sort_info
      Base64.strict_encode64(item.public_send(sort_column).to_s)
    end

    private

    sig { params(query: T.untyped, sort_column: String, sort_direction: Symbol).returns(T.untyped) }
    def apply_cursor_filters(query, sort_column, sort_direction)
      if after
        cursor_value = Base64.strict_decode64(after)
        query = query.where("#{sort_column} #{sort_direction == :asc ? '>' : '<'} ?", cursor_value)
      end

      if before
        cursor_value = Base64.strict_decode64(before)
        query = query.where("#{sort_column} #{sort_direction == :asc ? '<' : '>'} ?", cursor_value)
      end

      query
    end

    sig { params(query: T.untyped).returns(T.untyped) }
    def apply_limit(query)
      if first
        query.limit(first)
      elsif last
        query.limit(last)
      else
        query
      end
    end

    sig { returns([ String, Symbol ]) }
    def extract_sort_info
      relation = items.is_a?(GraphQL::Pagination::ActiveRecordRelationConnection) ? items.items : items
      order_clause = relation.order_values.first

      if order_clause.is_a?(Arel::Nodes::Ordering)
        column = order_clause.expr.name
        direction = T.unsafe(order_clause).direction.downcase.to_sym
      else
        column, direction = order_clause.to_s.split(" ")
        direction = direction&.downcase&.to_sym || :asc
      end

      [ column, direction ]
    end
  end
end
