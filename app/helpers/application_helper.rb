module ApplicationHelper
  def jquery_for_environment
    path = ENV['RAILS_ENV'] == "production" ? 'http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js' : 'jquery'
    javascript_include_tag path
  end

  def flash_messages
    messages = []
    %w(notice warning error alert).each do |msg|
      messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}", :class => "flash-msg") unless flash[msg.to_sym].blank?
    end
    messages.join('').html_safe
  end

  def menu_item(title, link, options = {})
    li_class = ''
    #set the link class to active if it matches the current link or any of the alternate supplied links
    options[:alt_links].each { |a| li_class = request.fullpath.match(a) ? 'active' : '' unless li_class == 'active' } if options[:alt_links].is_a?(Array)
    li_class = 'active' if link == request.fullpath
    return content_tag(:li, link_to(title, link), :class => li_class)
  end

  # now uses http://github.com/mdeering/gravatar_image_tag
  def gravatar_for(object)
    gravatar_image_tag(object.email)
  end

  def table_row(*args)
    html = "<tr>"
    args.each_with_index do |cell, i|
      html += "<td class='cell-#{i+1}'>#{cell}</td>"
    end
    html += "</tr>\n"

    html.html_safe
  end

  def seo_meta_tags
    obj = instance_variable_get("@#{params[:controller].singularize}")
    tags = []
    if obj && obj.respond_to?(:seo_keywords) && obj.respond_to?(:seo_description)
      tags << tag(:meta, {:name => "description", :content => obj.seo_description}) unless obj.seo_description.blank?
      tags << tag(:meta, {:name => "keywords", :content => obj.seo_keywords }) unless obj.seo_keywords.blank?
      return tags.join
    end
  end

  # eg. first_image(@product)
  def first_image(obj, options = {})
    opts = {
      :collection => :images,
      :method => :image,
      :style => :thumbnail,
      :default => image_path('noimage.jpg')
    }.merge(options.symbolize_keys!)

    image = obj.send(opts[:collection]).first
    image ? image.send(opts[:method]).url(opts[:style]) : opts[:default]
  end
end
