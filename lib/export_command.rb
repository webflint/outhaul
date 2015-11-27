require 'nokogiri'
require 'virtus'
require 'reverse_markdown'
require 'tracker_api'
require 'pry'

module Outhaul

  class ExportCommand
    include Virtus.model

    attribute :api_token, String
    attribute :project_id, String

    def run file
      @file = file

      load
      process
      save

      true
    end

    private def load
      html = IO.read @file
      @document = Nokogiri::HTML html
    end

    private def process
      return if body.nil?
      context_switched = false

      body.children.each do |node|
        handler = "process_#{node.name}"
        if respond_to?(handler, true)
          send handler, node
        else
          append node
        end
      end

      change_context_to nil
    end

    private def save
      IO.write @file, body.inner_html unless body.nil?
    end

    private def process_h1 node
      @epic = find_or_create_resource_by node
      change_context_to @epic
    end

    private def process_h2 node
      @story = find_or_create_resource_by node
      change_context_to @story
    end

    private def append node
      return if node.name.eql? 'text'

      if @reset_description
        @context.description = ''
        @reset_description = false
      end

      markdown = markdown_for node
      @context.description << markdown
    end

    private def change_context_to value
      @reset_description = true
      @context.save unless @context.nil?
      @context = value
    end

    private def get_resource_for link
      href = link.attr 'href'
      /\/(?<kind>epic|story)\/show\/(?<id>\d+)$/ =~ href

      endpoint = endpoint_for kind

      endpoint.new(client).get(
        @project_id,
        id
      )
    end

    private def create_resource_for node
      kind = node.name.eql?('h1') ? 'Epic' : 'Story'

      params = params_for node
      endpoint = endpoint_for kind

      endpoint.new(client).create(
        @project_id,
        params
      )
    end

    private def params_for node
      kind = node.name.eql?('h1') ? 'Epic' : 'Story'

      name = resource_name_for node

      if kind.eql? 'Epic'
        {
          name: name,
          label: {name: label_in(node)}
        }
      else
        {
          name: name,
          label_ids: [@epic.label.id]
        }
      end
    end

    private def endpoint_for kind
      Object.const_get "TrackerApi::Endpoints::#{kind.capitalize}"
    end

    private def find_or_create_resource_by node
      link = resource_link_in node

      if link.nil?
        resource = create_resource_for node
        link! node, resource.url
      else
        resource = get_resource_for link
        resource.name = resource_name_for node
      end

      resource
    end

    private def link! node, url
      link = Nokogiri::XML::Node.new 'a', @document
      link['href'] = url
      link.inner_html = node.text
      node.children.first.replace link
    end

    private def label_in node
      regex = /\(([^\)]+)\)/
      match = regex.match node.text
      match.captures.first
    end

    private def body
      @document.at_css 'body'
    end

    private def client
      @client ||= TrackerApi::Client.new token: @api_token
    end

    private def resource_name_for node
      link = resource_link_in node
      html = link.nil? ? node.inner_html : link.inner_html
      markdown = ReverseMarkdown.convert html
      markdown.strip
    end

    private def markdown_for node
      html = node.to_s
      ReverseMarkdown.convert html
    end

    private def resource_link_in node
      node.at_css 'a[href^="https://www.pivotaltracker.com/"]'
    end
  end

end
