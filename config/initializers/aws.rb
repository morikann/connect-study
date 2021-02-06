creds = Aws::Credentials.new(
  Rails.application.credentials.dig(:aws_ses, :access_key_id),
  Rails.application.credentials.dig(:aws_ses, :secret_access_key)
)

Aws::Rails.add_action_mailer_delivery_method(
  :ses,
  credentials: creds,
  region: 'ap-northeast-1'
)