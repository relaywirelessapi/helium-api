# typed: strict

class ComplexityAnalyzer < GraphQL::Analysis::QueryComplexity
  extend T::Sig

  ERROR_MESSAGE = <<~ERROR
    Usage limit will be exceeded with current query (complexity: %<complexity>).
    Your usage limit resets on %<reset_at>.
  ERROR

  sig { returns(T.nilable(GraphQL::AnalysisError)) }
  def result
    complexity = super

    current_user = query.context[:current_user]
    return unless current_user

    if current_user.api_usage_limit_exceeded_with?(complexity)
      message = ERROR_MESSAGE
        .gsub("%<complexity>", complexity.to_s)
        .gsub("%<reset_at>", current_user.next_api_usage_reset.to_s)
        .gsub("\n", " ")
        .strip

      return GraphQL::AnalysisError.new(message)
    end

    current_user.increment_api_usage_by(complexity)
    nil
  end
end
