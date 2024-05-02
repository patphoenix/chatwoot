require 'graphlient'

class Linear
  BASE_URL = 'https://api.linear.app/graphql'.freeze

  def initialize(api_key)
    @api_key = api_key
    raise ArgumentError, 'Missing Credentials' if @api_key.blank?

    @client = Graphlient::Client.new(
      BASE_URL,
      headers: {
        'Authorization' => @api_key,
        'Content-Type' => 'application/json'
      }
    )
  end

  def teams
    query = <<~GRAPHQL
      query {
        teams {
          nodes {
            id
            name
          }
        }
      }
    GRAPHQL
    execute_query(query)
  end

  def labels(team_id)
    query = <<~GRAPHQL
      query {
        team(id: "#{team_id}") {
          labels {
            nodes {
              id
              name
            }
          }
        }
      }
    GRAPHQL
    execute_query(query)
  end

  private

  def execute_query(query)
    @client.query(query).data.to_h
  rescue Graphlient::Errors::GraphQLError => e
    { error: "GraphQL Error: #{e.message}" }
  rescue Graphlient::Errors::ServerError => e
    { error: "Server Error: #{e.message}" }
  rescue StandardError => e
    { error: "Unexpected Error: #{e.message}" }
  end
end
