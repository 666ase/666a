require "redcarpet"

class PolicyRender < Redcarpet::Render::HTML
  def header(text, header_level)
    case header_level
    when 1
      %(<h1 class="text-3xl font-bold">#{text}</h1>)
    else
      %(<h#{header_level} class="text-xl">#{text}</h#{header_level}>)
    end
  end
end

class PoliciesController < ApplicationController
  def accessibility
    policy("accessibility")
    render template: "policies/show", layout: "internal"
  end

  def privacy
    policy("privacy")
    render template: "policies/show", layout: "internal"
  end

  def terms
    policy("terms")
    render template: "policies/show", layout: "internal"
  end

  private

  def policy(name)
    filename = Rails.root.join("policies", "#{name}.en.md")
    markdown = File.read(filename)
    renderer = PolicyRender.new()
    redcarpet = Redcarpet::Markdown.new(renderer, extensions = {})
    @html = redcarpet.render(markdown)
  end
end
