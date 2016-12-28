
module FacebookMessengerBot
  require "facebook_messenger_bot/version"
  require 'facebook_messenger_bot/messenger_one_time_apis'
  require 'facebook_messenger_bot/element_hashes'



  def send_text_message(recipient_id, message_text, metadata = nil)
    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}
    if metadata.nil?
      message_data['message'] = {'text' => message_text}
    else
      message_data['message'] = {'text' => message_text, 'metadata' => metadata}
    end
    call_send_API(message_data)
  end

  def send_image_message(recipient_id, url)
    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}
    message_data['message'] = {'attachment' => {'type' => 'image', 'payload' => {'url' => url}}}
    call_send_API(message_data)
  end

  def send_busy_typing_message(recipient_id)
    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}
    message_data['sender_action'] = 'typing_on'
    call_send_API(message_data)
  end

  def send_quick_reply_message(recipient_id, text, reply_options)
    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}

    quick_reply_msg = Hash.new
    quick_reply_msg['text'] = text
    quick_reply_msg['quick_replies'] = reply_options

    message_data['message'] = quick_reply_msg
    call_send_API(message_data)
  end

  def send_generic_message(recipient_id, elements, quick_replies=[])
    payload = Hash.new
    payload['template_type'] = 'generic'
    payload['elements'] = elements

    attachment = Hash.new
    attachment['type'] = 'template'
    attachment['payload'] = payload

    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}
    if quick_replies == []
      message_data['message'] = {'attachment' => attachment}
    elsif quick_replies.kind_of?String
      message_data['message'] = {'attachment' => attachment, 'metadata' => quick_replies}
    else
      message_data['message'] = {'attachment' => attachment, 'quick_replies' => quick_replies}
    end
    call_send_API(message_data)
  end

  def send_list_message(recipient_id, elements, buttons = nil)
    payload = Hash.new
    payload['template_type'] = 'list'
    payload['top_element_style'] = 'compact'
    payload['elements'] = elements
    if buttons.present?
      payload['buttons'] = buttons
    end
    attachment = Hash.new
    attachment['type'] = 'template'
    attachment['payload'] = payload
    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}
    message_data['message'] = {'attachment' => attachment}
    call_send_API(message_data)
  end

  def send_receipt_message(recipient_id, elements, name, order_number, payment_method, summary, address)
    payload = Hash.new
    payload['template_type'] = 'receipt'
    payload['recipient_name'] = name
    payload['order_number'] = order_number
    payload['currency'] = 'USD'
    payload['payment_method'] = payment_method
    payload['elements'] = elements
    payload['summary'] = summary
    payload['address'] = address
    attachment = Hash.new
    attachment['type'] = 'template'
    attachment['payload'] = payload
    message_data = Hash.new
    message_data['recipient'] = {'id' => recipient_id}
    message_data['message'] = {'attachment' => attachment}
    call_send_API(message_data)
  end

  def get_user_profile_data(user_id)
    uri = URI.parse('https://graph.facebook.com')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new('/v2.6/' + user_id + '?fields=first_name,last_name,email,profile_pic,locale,timezone,gender&access_token=' + PAGE_ACCESS_TOKEN)
    response = http.request(request)
    response.body
  end

  def call_send_API(message_data)
    uri = URI.parse('https://graph.facebook.com')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new('/v2.6/me/messages?access_token=' + PAGE_ACCESS_TOKEN)
    request.add_field('Content-Type', 'application/json')
    request.body = message_data.to_json
    response = http.request(request)
    if response.code != '200'
      logger.info("\e[31m#{"messenger call_send_API failed with below request and response details..."}\e[0m" + "\nRequest: #{request.body} \nResponse: #{response.body}")
    end
  end
  # Your code goes here...
end
