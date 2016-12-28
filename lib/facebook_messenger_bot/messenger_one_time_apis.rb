module MessengerOneTimeApis

  require 'facebook_messenger_bot/element_hashes'
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


  def create_greeting_text_hash(greeting_text = "Hi {{user_first_name}}, Welcome")
    greeting_text = Hash.new
    greeting_text[:setting_type] = "greeting"
    greeting = Hash.new
    greeting[:text] =  greeting_text
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
    end
    response
  end

end
