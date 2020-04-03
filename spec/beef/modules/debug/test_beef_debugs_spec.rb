#
# Copyright (c) 2006-2020 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - http://beefproject.com
# See the file 'doc/COPYING' for copying permission
#

require 'rest-client'
require 'json'
require_relative '../../../support/constants'
require_relative '../../../support/beef_test'

RSpec.describe 'BeEF Debug Command Modules:' do

    before(:each) do
        # Grab config and set creds in variables for ease of access
        @config = BeEF::Core::Configuration.instance
        @username = @config.get('beef.credentials.user')
        @password = @config.get('beef.credentials.passwd')

        # Authenticate to RESTful API endpoint to generate token for future tests
        auth_response = RestClient.post "#{RESTAPI_ADMIN}/login",
                                   { 'username': "#{@username}",
                                     'password': "#{@password}"}.to_json,
                                   :content_type => :json,
                                   :accept => :json
        @token = JSON.parse(auth_response)['token']
        hooks_response = RestClient.get "#{RESTAPI_HOOKS}",
                                        {:params => {:token => @token}}
        @session = JSON.parse(hooks_response)['hooked-browsers']['online']['0']['session']
    end

    it 'Test_beef.debug() successfully executes' do
        response = RestClient.post "#{RESTAPI_MODULES}/#{@session}/27?token=#{@token}",
                                   { "msg": "Testing Test_beef.debug() command module" }.to_json,
                                   content_type: :json,
                                   accept: :json
        result_data = JSON.parse(response.body)
        expect(result_data['success']).to eq "true"
    end

    it 'Return ASCII Characters successfully executes' do
        response = RestClient.post "#{RESTAPI_MODULES}/#{@session}/25?token=#{@token}",
                                   {}.to_json,
                                   content_type: :json,
                                   accept: :json
        result_data = JSON.parse(response.body)
        expect(result_data['success']).to eq "true"    
    end

end