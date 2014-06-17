require 'sinatra'
require 'action_mailer'
 
class Mailer < ActionMailer::Base
  def contact(to, from, subject)
    mail(
      :to      => to,
      :from    => from,
      :subject => subject) do |format|
        format.text
        format.html
    end
  end
end


 
configure do
  set :root,    File.dirname(__FILE__)
  set :views,   File.join(Sinatra::Application.root, 'views')
  set :haml,    { :format => :html5 }
    
  if production?
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
      :domain             => "my-mail-server-domain.com",
      :address            => "mail.my-mail-server-domain.com",
      :port               => 25,
      :authentication     => :login ,
      :user_name          => ENV['EXCHANGE_USERNAME'],
      :password           => ENV['EXCHANGE_PASSWORD'],
    }
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.default_charset = "utf-8"
    ActionMailer::Base.default_content_type = "text/html"
    
    #ActionMailer::Base.smtp_settings = {
    #  :address => "smtp.sendgrid.net",
    #  :port => '25',
    #  :authentication => :plain,
    #  :user_name => ENV['SENDGRID_USERNAME'],
    #  :password => ENV['SENDGRID_PASSWORD'],
    #  :domain => ENV['SENDGRID_DOMAIN'],
    #}
    
  else
    ActionMailer::Base.delivery_method = :file
    ActionMailer::Base.file_settings = { :location => File.join(Sinatra::Application.root, 'tmp/emails') }
  end
  ActionMailer::Base.view_paths = File.join(Sinatra::Application.root, 'views')
end
 
post '/mail' do
  email = Mailer.contact("test@example.com","test@example.com", "Test")
  email.deliver
end