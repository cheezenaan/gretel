module Gretel
  module ViewHelpers
    # Sets the current breadcrumb to be rendered elsewhere. Put it somewhere in the view, preferably in the top, before you render any breadcrumbs HTML:
    #   <%
    #   breadcrumb :category, @category
    #   %>
    def breadcrumb(key = nil, *args)
      if key.nil? || key.is_a?(Hash)
        raise ArgumentError, "The `breadcrumb` method was called with #{key.inspect} as the key. This method is used to set the breadcrumb. Maybe you meant to call the `breadcrumbs` method (with an 's' in the end) which is used to render the breadcrumbs?"
      end
      @_gretel_renderer = Gretel::Renderer.new(self, key, *args)
    end

    # Renders the breadcrumbs HTML, for example in your layout. See the readme for default options.
    #   <%= breadcrumbs pretext: "You are here: " %>
    #
    # If you supply a block, it will yield an array with the breadcrumb links so you can build the breadcrumbs HTML manually:
    #   <% breadcrumbs do |links| %>
    #     <% if links.any? %>
    #       You are here:
    #       <% links.each do |link| %>
    #         <%= link_to link.text, link.url %> (<%= link.key %>)
    #       <% end %>
    #     <% end %>
    #   <% end %>
    def breadcrumbs(options = {}, &block)
      if block_given?
        yield gretel_renderer.links_with(options)
      else
        gretel_renderer.render(options)
      end
    end

    # Returns or yields parent breadcrumb (second-to-last in the trail) if it is present.
    def parent_breadcrumb(options = {}, &block)
      parent = gretel_renderer.links_with(options)[-2]
      if block_given? && parent
        yield parent
      else
        parent
      end
    end

    private

    # Reference to the Gretel breadcrumbs renderer.
    def gretel_renderer
      @_gretel_renderer ||= Gretel::Renderer.new(self, nil)
    end
  end
end
