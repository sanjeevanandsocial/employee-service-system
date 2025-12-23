require 'httparty'

class BrevoEmailService
  include HTTParty
  base_uri 'https://api.brevo.com/v3'

  def initialize
    @api_key = Rails.application.credentials.brevo_api_key || ENV['BREVO_API_KEY']
  end

  def send_reset_code(email, code, masked_email)
    options = {
      headers: {
        'api-key' => @api_key,
        'Content-Type' => 'application/json'
      },
      body: {
        sender: {
          name: "Employee Service System",
          email: xxxxx
        },
        to: [
          {
            email: email
          }
        ],
        subject: "Password Reset Verification Code",
        htmlContent: reset_email_template(code, masked_email)
      }.to_json
    }

    response = self.class.post('/smtp/email', options)
    response.success?
  end

  private

  def reset_email_template(code, masked_email)
    <<~HTML
      <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #00226d;">Password Reset Request</h2>
            <p>You have requested to reset your password for your Employee Service System account (#{masked_email}).</p>
            <div style="background: #f8fafc; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;">
              <h3 style="margin: 0; color: #00226d;">Your Verification Code</h3>
              <div style="font-size: 32px; font-weight: bold; color: #00226d; margin: 10px 0; letter-spacing: 8px;">#{code}</div>
              <p style="margin: 0; color: #64748b; font-size: 14px;">Enter this code to reset your password</p>
            </div>
            <p>If you did not request this password reset, please ignore this email.</p>
            <p style="color: #64748b; font-size: 12px;">This is an automated message, please do not reply.</p>
          </div>
        </body>
      </html>
    HTML
  end
end