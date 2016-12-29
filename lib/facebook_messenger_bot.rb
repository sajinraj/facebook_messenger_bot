module FacebookMessengerBot
  extend self
  require "facebook_messenger_bot/version"
  require "facebook_messenger_bot/railtie" if defined?(Rails)

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

  def create_persistent_menu_hash(menu_array)
    menu = Hash.new
    menu[:setting_type] = "call_to_actions"
    menu[:thread_state] = "existing_thread"
    menu[:call_to_actions] = menu_array
    menu
  end


  def create_white_list_hash(url, action="add")
    white_list = Hash.new
    white_list[:setting_type] = "domain_whitelisting"
    white_list[:whitelisted_domains] = [url]
    white_list[:domain_action_type] = action
    white_list
  end


  def create_greeting_text_hash(text = "Hi {{user_first_name}}, Welcome")
    greeting_text = Hash.new
    greeting_text[:setting_type] = "greeting"
    greeting = Hash.new
    greeting[:text] =  text
    greeting_text[:greeting] = greeting
    greeting_text
  end


  def create_get_started_hash(get_started_payload = "GET_STARTED_PAYLOAD")
    get_started = Hash.new
    get_started[:setting_type] = "call_to_actions"
    get_started[:thread_state] = "new_thread"
    get_started[:call_to_actions] = []
    payload = Hash.new
    payload[:payload] = get_started_payload
    get_started[:call_to_actions] << payload
    get_started
  end


  def web_menu(title, url, height = "full", messenger_extension = true)
    menu = Hash.new
    menu[:type] = "web_url"
    menu[:title] = title
    menu[:url] = url
    menu[:webview_height_ratio] = height # Available options - "compact","tall","full"
    menu[:messenger_extensions] = messenger_extension   # true if messenger extensions are used
    menu
  end


  def postback_menu(title,payload)
    menu = Hash.new
    menu[:type] = "postback"
    menu[:title] = title
    menu[:payload] = payload
    menu
  end

  def element_hash(title, sub_title, image_url, default_action, buttons)
    element = Hash.new
    element[:title] = title if title.present?
    element[:subtitle] = sub_title if sub_title.present?
    element[:image_url] = image_url if image_url.present?
    element[:default_action] = default_action if default_action.present?
    element[:buttons] = buttons if buttons.present?
    element
  end

  def web_url_button(title, url, height = 'full', messenger_extension = true)
    button = Hash.new
    button[:type] = "web_url"
    button[:title] = title
    button[:url] = url
    button[:webview_height_ratio] = height
    button[:messenger_extensions] = messenger_extension
    button
  end

  def postback_button(title,payload)
    button = Hash.new
    button[:type] = "postback"
    button[:title] = title
    button[:payload] = payload
    button
  end

  def web_url_default_action(url, height = 'full', messenger_extension = true)
    button = Hash.new
    button[:type] = "web_url"
    button[:url] = url
    button[:webview_height_ratio] = height
    button[:messenger_extensions] = messenger_extension
    button
  end

  def postback_default_action(payload)
    button = Hash.new
    button[:type] = "postback"
    button[:payload] = payload
    button
  end

  def quick_reply_hash(title, payload)
    quick_reply = Hash.new
    quick_reply[:content_type] = "text"
    quick_reply[:title] = title
    quick_reply[:payload] = payload
    quick_reply
  end


  private

  def call_thread_settings_API(message_data)
    uri = URI.parse('https://graph.facebook.com')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new('/v2.6/me/thread_settings?access_token=' + PAGE_ACCESS_TOKEN)
    request.add_field('Content-Type', 'application/json')
    request.body = message_data.to_json
    response = http.request(request)
    if response.code == :ok
      response
    else
      Rails.logger.info("\e[31m#{"messenger call_thread_settings_API failed with below request and response details..."}\e[0m" + "\nRequest: #{request.body} \nResponse: #{response.body}")

    end
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
      Rails.logger.info("\e[31m#{"messenger call_send_API failed with below request and response details..."}\e[0m" + "\nRequest: #{request.body} \nResponse: #{response.body}")
    end
  end


  # Your code goes here...
end
