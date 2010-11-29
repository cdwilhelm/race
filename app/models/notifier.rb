class Notifier < ActionMailer::Base
  
  # send message to info@hpdlighting.com
  def contactus(email,subject,message,category)
    @subject = 'Website question/comment'
    @recipients =  INFO_ADDRESS
    #@recipients = 'curt_wilhelm@yahoo.com'
    @from = email
    @sent_on = Time.now
    @body["message"] = message
    @body["subject"] = subject
    @body["category"] = category

  end


end
