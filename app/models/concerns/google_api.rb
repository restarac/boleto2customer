require 'google/api_client'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'google/api_client/client_secrets'

module GoogleApi
  extend ActiveSupport::Concern

  class GoogleDriveDownload
    CREDENTIALS_FILE = Rails.root.join('tmp', 'google_api_credentials.json')

    def initialize
      credentials_storage = ::Google::APIClient::FileStorage.new(CREDENTIALS_FILE)
      @client = ::Google::APIClient.new(
        application_name:    'MyApp',
        application_version: '1.0.0'
      )
      @client.authorization = credentials_storage.authorization || begin
        installed_app_flow = ::Google::APIClient::InstalledAppFlow.new(
          client_id:     Settings.google.api.client_id,
          client_secret: Settings.google.api.client_secret,
          scope:         Settings.google.api.scope
        )
        installed_app_flow.authorize(credentials_storage)
      end
      @drive = @client.discovered_api('drive', 'v2')
    end

    def download_latest_proxylist(search_period = 1.week.ago)
      result = @client.execute(
        api_method: @drive.files.list,
        parameters: {
          q: %(title contains "proxylist" and modifiedDate > "#{search_period.strftime('%Y-%m-%dT%H:%M:%S%z')}")
        }
      )
      file = result.data['items'].first
      download_url = file['downloadUrl']
      result = @client.execute(uri: download_url)
      output_file = Rails.root.join('tmp', file['originalFilename'])
      IO.binwrite output_file, result.body
      file['createdDate']
    end
  end

  class GoogleDriveUpload

    API_VERSION = 'v2'
    CACHED_API_FILE = "drive-#{API_VERSION}.cache"
    CREDENTIAL_STORE_FILE = "#{$0}-oauth2.json"

    # Handles authentication and loading of the API.
    def setup()
      log_file = File.open('drive.log', 'a+')
      log_file.sync = true
      logger = Logger.new(log_file)
      logger.level = Logger::DEBUG

      client = Google::APIClient.new(:application_name => 'Ruby Drive sample',
          :application_version => '1.0.0')

      # FileStorage stores auth credentials in a file, so they survive multiple runs
      # of the application. This avoids prompting the user for authorization every
      # time the access token expires, by remembering the refresh token.
      # Note: FileStorage is not suitable for multi-user applications.
      file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
      if file_storage.authorization.nil?
        client_secrets = Google::APIClient::ClientSecrets.load
        # The InstalledAppFlow is a helper class to handle the OAuth 2.0 installed
        # application flow, which ties in with FileStorage to store credentials
        # between runs.
        flow = Google::APIClient::InstalledAppFlow.new(
          :client_id => client_secrets.client_id,
          :client_secret => client_secrets.client_secret,
          :scope => ['https://www.googleapis.com/auth/drive']
        )
        client.authorization = flow.authorize(file_storage)
      else
        client.authorization = file_storage.authorization
      end

      drive = nil
      # Load cached discovered API, if it exists. This prevents retrieving the
      # discovery document on every run, saving a round-trip to API servers.
      if File.exists? CACHED_API_FILE
        File.open(CACHED_API_FILE) do |file|
          drive = Marshal.load(file)
        end
      else
        drive = client.discovered_api('drive', API_VERSION)
        File.open(CACHED_API_FILE, 'w') do |file|
          Marshal.dump(drive, file)
        end
      end

      return client, drive
    end

    # Handles files.insert call to Drive API.
    def insert_file(client, drive)
      # Insert a file
      file = drive.files.insert.request_schema.new({
        'title' => 'My document',
        'description' => 'A test document',
        'mimeType' => 'text/plain'
      })

      media = Google::APIClient::UploadIO.new('document.txt', 'text/plain')
      result = client.execute(
        :api_method => drive.files.insert,
        :body_object => file,
        :media => media,
        :parameters => {
          'uploadType' => 'multipart',
          'alt' => 'json'})

      # Pretty print the API result
      jj result.data.to_hash
    end
    # if __FILE__ == $0
    #   client, drive = setup()
    #   insert_file(client, drive)
    # end
  end
end