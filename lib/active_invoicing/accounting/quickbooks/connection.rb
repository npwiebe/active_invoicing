# frozen_string_literal: true

require "oauth2"

module ActiveInvoicing
  module Accounting
    module Quickbooks
      class Connection
        QUICKBOOKS_OAUTH_DEFAULTS = {
          site: "https://appcenter.intuit.com/connect/oauth2",
          authorize_url: "https://appcenter.intuit.com/connect/oauth2",
          token_url: "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
        }

        QUICKBOOKS_OAUTH_REQUEST_DEFAULTS = {
          scope: "com.intuit.quickbooks.accounting",
          response_type: "code",
          grant_type: "authorization_code",
        }
        attr_reader :client_id, :client_secret, :redirect_uri, :realm_id, :scope, :code, :tokens

        def initialize(redirect_uri, scope = QUICKBOOKS_OAUTH_REQUEST_DEFAULTS[:scope], client_id = nil, client_secret = nil)
          @client_id = client_id || ActiveInvoicing.configuration.quickbooks_client_id
          @client_secret = client_secret || ActiveInvoicing.configuration.quickbooks_client_secret
          @redirect_uri = redirect_uri
          @scope = scope

          @client = OAuth2::Client.new(@client_id, @client_secret, **QUICKBOOKS_OAUTH_DEFAULTS)
        end

        def authorize_url
          @client.auth_code.authorize_url(redirect_uri: @redirect_uri, scope: @scope, state: SecureRandom.hex(12))
        end

        def get_token(code)
          @tokens = @client.auth_code.get_token(code, redirect_uri: @redirect_uri)
        end

        def access_token
          @tokens&.token
        end

        def refresh_token
          @tokens&.refresh_token
        end

        def refresh_access_token
          @tokens = @tokens.refresh!
        end

        def make_request(endpoint)
          response = @tokens.request(endpoint)
          yield(response) if block_given?
          response
        end
      end
    end
  end
end
