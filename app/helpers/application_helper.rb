module ApplicationHelper
  
  def flash_messages
    [:notice, :error, :success].collect do |key|
      content_tag('div', flash[key], :class => "flash #{key}") unless flash[key].blank?
    end
  end
  
end
