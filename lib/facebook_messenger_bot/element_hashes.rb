module ElementHashes
  require 'rubygems'
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

end
