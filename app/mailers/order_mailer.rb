class OrderMailer < ActionMailer::Base
  default :from => "infinity@raild.co.uk"
  
  def confirm(email, basket)
    @basket = basket
    attachments.inline['logo.gif'] = File.read("#{RAILS_ROOT}/public/images/logo.gif")
    mail(:to => email,
         :subject => "Your Infinity Foods order")
  end
end
