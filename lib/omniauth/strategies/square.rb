# frozen_string_literal: true

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Square < OmniAuth::Strategies::OAuth2
      option :name, 'square'
      option :client_options, {
        site: 'https://connect.squareup.com',
        authorize_url: 'oauth2/authorize',
        token_url: 'oauth2/token'
      }

      uid { raw_info['merchant'][0]['id'] }

      info do
        prune!(
          name: raw_info['merchant'][0]['business_name'],
          country: raw_info['merchant'][0]['country'],
          email: raw_info['email']
        )
      end

      extra do
        { raw_info: raw_info }
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def build_access_token
        options.token_params.merge!({client_id: options.client_id, client_secret: options.client_secret})
        super
      end

  private

      def raw_info
        @raw_info ||= access_token.get('/v2/merchants').parsed

        # Get merchant email
        log :info, "Getting merchant email"
        resp = access_token.post("/v2/team-members/search", {query: {filter: {is_owner: true}}}).parsed
        log :info, "Got merchant email: #{resp[:team_members][0]}"
        @raw_info.merge!({email: resp[:team_members][0].email_address})
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'square', 'Square'
