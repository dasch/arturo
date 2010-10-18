require 'action_view/helpers/tag_helper'
require 'action_view/helpers/form_tag_helper'

module Arturo
  module FeaturesHelper
    include ActionView::Helpers::TagHelper

    def feature_enabled?(symbol_or_feature)
      feature = ::Arturo::Feature.to_feature(symbol_or_feature)
      return false if feature.blank?
      thing = ::Arturo.thing_that_has_features.bind(self).call
      feature.enabled_for?(thing)
    end

    def if_feature_enabled(symbol_or_feature, &block)
      if feature_enabled?(symbol_or_feature)
        block.call
      else
        nil
      end
    end

    def deployment_percentage_range_and_output_tags(name, value, options = {})
      id = sanitize_to_id(name)
      options = {
        'type' => 'range',
        'name' => name,
        'id' => id,
        'value' => value,
        'min' => '0',
        'max' => '100',
        'step' => '1',
        'class' => 'deployment_percentage'
      }.update(options.stringify_keys)
      tag(:input, options) + deployment_percentage_output_tag(id, value)
    end

    def deployment_percentage_output_tag(id, value)
      content_tag(:output, value, { 'for' => id, 'class' => 'deployment_percentage no_js' })
    end

    def error_messages_for(feature, attribute)
      if feature.errors[attribute].any?
        content_tag(:ul, :class => 'errors') do
          feature.errors[attribute].map { |msg| content_tag(:li, msg, :class => 'error') }.join(''.html_safe)
        end
      else
        ''
      end
    end
  end
end
