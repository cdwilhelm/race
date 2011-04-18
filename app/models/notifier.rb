class Notifier < ActionMailer::Base
  
  # send message to info@hpdlighting.com
  def contactus(email,subject,message,category)
    @subject = 'Website question/comment'
    @recipients =  email
    #@recipients = 'curt_wilhelm@yahoo.com'
    @from = "info@findmybikerace.com"
    @sent_on = Time.now
    @body["message"] = message
    @body["subject"] = subject
    @body["category"] = category

  end


end
