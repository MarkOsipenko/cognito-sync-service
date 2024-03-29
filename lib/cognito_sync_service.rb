# frozen_string_literal: true

require 'cognito_sync_service/version'
require 'cognito_attributes_converter.rb'
# require 'cognito_pools_initializer.rb'
# require 'cognito_provider.rb'

module CognitoSyncService
  include ::CognitoAttributesConverter

  # username - can be email, phone_number or custom string depend on you cognito pool settings
  # attrs - hash of user attributes which will be saved in cognito pool
  # attrs = { email: 'qwe@qwe,com', phone_number:  '+12......0'}
  def ca_create!(attrs, username, temporary_password = nil)
    user_attributes = {
      user_pool_id: web_pool_id,
      username: username,
      user_attributes: convert_to_cognito(attrs),
      temporary_password: temporary_password
    }.compact

    user = cognito_provider.admin_create_user(user_attributes).user

    convert_from_cognito(user)
  end

  # user can be delete by email or phone_number depend on cognito pool settings
  def ca_delete!(username)
    cognito_provider.admin_delete_user(user_pool_id: web_pool_id, username: username)
  end

  # user can be find by email or phone_number depend on cognito pool settings
  def ca_find!(username)
    user = cognito_provider.admin_get_user(user_pool_id: web_pool_id, username: username)
    convert_from_cognito(user)
  end

  # username - can be email, phone_number or custom string depend on cognito pool settings
  # attrs - hash of user attributes which will be saved in cognito pool
  # attrs = { email: 'qwe@qwe,com', phone_number:  '+12......0'}
  def ca_update!(attrs, username)
    c_attributes = convert_to_cognito(attrs)
    cognito_provider.admin_update_user_attributes(user_pool_id: web_pool_id, username: username, user_attributes: c_attributes)
    ca_find!(username)
  end

  # user can be disable by email or phone_number depend on cognito pool settings
  def ca_disable!(username)
    cognito_provider.admin_disable_user(user_pool_id: web_pool_id, username: username)
  end

  # user can be authenticated by email or phone_number depend on cognito pool settings
  # password can be constant or temporary
  # "auth_flow" arg may differ depend on you authorization rules, we hardcode ADMIN_NO_SRP_AUTH like a common case
  # In future this action be more flexible
  # List of auth_flow args here - https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/initiate-auth.html
  def ca_initiate_auth!(username, password)
    cognito_provider.admin_initiate_auth(
      user_pool_id: web_pool_id,
      client_id: web_client_id,
      auth_flow: 'ADMIN_NO_SRP_AUTH',
      auth_parameters: {
        USERNAME: username,
        PASSWORD: password
      }
    )
  end

  # for now this method works only for password confirmation flow
  def ca_respond_to_auth_challenge!(username, password, session)
    cognito_provider.admin_respond_to_auth_challenge(
      user_pool_id: web_pool_id,
      client_id: web_client_id,
      challenge_name: 'NEW_PASSWORD_REQUIRED',
      session: session,
      challenge_responses: { USERNAME: username, NEW_PASSWORD: password }
    )
  end
end
