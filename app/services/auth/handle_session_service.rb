# frozen_string_literal: true

module Auth
  class HandleSessionService
    def initialize(user:, user_agent:, app:, ip_address:, player_id: nil)
      @user = user
      @player_id = player_id
      @user_agent = user_agent
      @app = app
      @ip_address = ip_address
    end

    def call
      handle_session
    end

    private

    attr_reader :user, :player_id, :user_agent, :app, :ip_address

    def handle_session
      session = user.sessions.active.find_by(user_agent: user_agent)

      return create_session unless session

      update_fields = { live: true, last_login: Time.current, last_activity: Time.current }
      update_fields[:player_id] = player_id if player_id.present?

      session.update(update_fields)
    end

    def create_session
      Session.new.tap do |s|
        s.app = app
        s.user = user
        s.ip_address = ip_address
        s.user_agent = user_agent
        s.token_valid_until = 1.minute.from_now # 1.day
        s.last_activity = Time.current
        s.last_login = Time.current
        s.player_id = player_id

        client = DeviceDetector.new(user_agent)
        s.device_name = client.device_name
        s.device_type = client.device_type
        s.device_client_name = client.name
        s.device_client_full_version = client.full_version
        s.device_os = client.os_name
        s.device_os_full_version = client.os_full_version
        s.device_known = client.known?

        s.token_salt = loop do
          token_salt = SecureRandom.urlsafe_base64(50, false)
          break token_salt unless Session.where(token_salt: token_salt).exists?
        end

        app_secret = Auth::AppSecretService.new(app_type: app.app_type).call

        s.token = JWT.encode({ access_token: s.token_salt }, app_secret + user_agent, 'HS512')
        s.live = true
        s.save
      end
    end
  end
end
