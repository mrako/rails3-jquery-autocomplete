require 'form_helper'

module Rails3JQueryAutocomplete
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Inspired on DHH's autocomplete plugin
  # 
  # Usage:
  # 
  # class ProductsController < Admin::BaseController
  #   autocomplete :brand, :name
  # end
  #
  # This will magically generate an action autocomplete_brand_name, so, 
  # don't forget to add it on your routes file
  # 
  #   resources :products do
  #      get :autocomplete_brand_name, :on => :collection
  #   end
  #
  # Now, on your view, all you have to do is have a text field like:
  # 
  #   f.text_field :brand_name, :autocomplete => autocomplete_brand_name_products_path
  #
  #
  module ClassMethods
    def autocomplete(object, method, options = {})
      limit = options[:limit] || 10
      order = options[:order] || "#{method} ASC"

      define_method("autocomplete_#{object}_#{method}") do
        if params[:term] && !params[:term].empty?
          items = object.to_s.camelize.constantize.where(["LOWER(#{method}) LIKE ?", "#{(options[:full] ? '%' : '')}#{params[:term].downcase}%"]).limit(limit).order(order)
        else
          items = {}
        end

        render :json => json_for_autocomplete(items, (options[:display_value] ? options[:display_value] : method), options[:labels], options[:sub_elements])
      end
    end
  end

  private
  def json_for_autocomplete(items, method, labels = nil, sub_elements = [])
    items.collect {|i|
      {"id" => i.id,
        "label" => (labels ? read_labels(i, labels) : i.send(method)),
        "value" => i.send(method)
      }.merge(read_sub_elements(i, sub_elements))
    }
  end
  
  def read_sub_elements(i, elements)
    Hash.new.tap do |h|
      elements.collect {|e|
        h[e] = i.send(e).to_s if i.send(e)
      } unless elements.blank?
    end
  end
  
  def read_labels(item, labels)
    labels.collect {|l| item.send(l)}.compact.join(', ')
  end
end

class ActionController::Base
  include Rails3JQueryAutocomplete
end
