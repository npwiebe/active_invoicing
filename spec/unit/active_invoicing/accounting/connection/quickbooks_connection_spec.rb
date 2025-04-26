# frozen_string_literal: true

require "spec_helper"

RSpec.describe(ActiveInvoicing::Accounting::Connection::QuickbooksConnection) do
  let(:client_id) { "test_client_id" }
  let(:client_secret) { "test_client_secret" }
  let(:redirect_uri) { "http://localhost/callback" }
  let(:scope) { "com.intuit.quickbooks.accounting" }
  let(:connection) { described_class.new(client_id, client_secret, redirect_uri, scope) }

  describe "#initialize" do
    it "sets the client_id, client_secret, and redirect_uri" do
      expect(connection.client_id).to(eq(client_id))
      expect(connection.client_secret).to(eq(client_secret))
      expect(connection.redirect_uri).to(eq(redirect_uri))
    end
  end

  describe "#authorize_url" do
    it "generates the correct authorization URL" do
      url = connection.authorize_url
      expect(url).to(include("https://appcenter.intuit.com/connect/oauth2"))
      expect(url).to(include("redirect_uri=#{CGI.escape(redirect_uri)}"))
      expect(url).to(include("scope=#{CGI.escape(scope)}"))
    end
  end

  describe "#get_access_token" do
    it "retrieves an access token using the authorization code" do
      mock_token = instance_double("OAuth2::AccessToken")
      mock_client = instance_double("OAuth2::Client")
      mock_auth_code = instance_double("OAuth2::Strategy::AuthCode")

      allow(mock_auth_code).to(receive(:get_token).with("test_code", redirect_uri: redirect_uri, state: kind_of(String)).and_return(mock_token))
      allow(mock_client).to(receive(:auth_code).and_return(mock_auth_code))

      connection.instance_variable_set(:@client, mock_client)

      token = connection.get_access_token("test_code")
      expect(token).to(eq(mock_token))
    end
  end

  describe "#make_request" do
    it "makes a request to the given endpoint and parses the response" do
      mock_response = instance_double("OAuth2::Response", body: { "account" => "test_account" }.to_json)
      mock_access_token = instance_double("OAuth2::AccessToken")

      endpoint = "https://api.quickbooks.com/v3/company/12345/account"

      allow(mock_access_token).to(receive(:get).with(endpoint).and_return(mock_response))

      result = connection.make_request(mock_access_token, endpoint)
      expect(result).to(eq({ "account" => "test_account" }))
    end
  end

  describe "error handling" do
    context "when an error occurs during #get_access_token" do
      it "raises an appropriate error" do
        mock_client = instance_double("OAuth2::Client")
        mock_auth_code = instance_double("OAuth2::Strategy::AuthCode")

        allow(mock_auth_code).to(receive(:get_token).and_raise(OAuth2::Error.new("Invalid code")))
        allow(mock_client).to(receive(:auth_code).and_return(mock_auth_code))

        connection.instance_variable_set(:@client, mock_client)

        expect { connection.get_access_token("invalid_code") }.to(raise_error(OAuth2::Error, "Invalid code"))
      end
    end

    context "when an error occurs during #make_request" do
      it "raises an appropriate error" do
        mock_access_token = instance_double("OAuth2::AccessToken")
        endpoint = "https://api.quickbooks.com/v3/company/12345/account"

        allow(mock_access_token).to(receive(:get).with(endpoint).and_raise(OAuth2::Error.new("Request failed")))

        expect { connection.make_request(mock_access_token, endpoint) }.to(raise_error(OAuth2::Error, "Request failed"))
      end
    end
  end
end
