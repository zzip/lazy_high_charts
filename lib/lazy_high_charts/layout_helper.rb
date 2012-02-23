# coding: utf-8
module LazyHighCharts
  module LayoutHelper

    def high_chart(placeholder, object  , &block)
      object.html_options.merge!({:id=>placeholder})
      object.options[:chart][:renderTo] = placeholder
      high_graph(placeholder,object , &block).concat(content_tag("div","", object.html_options))
    end

    def high_stock(placeholder, object  , &block)
      object.html_options.merge!({:id=>placeholder})
      object.options[:chart][:renderTo] = placeholder
      high_graph_stock(placeholder,object , &block).concat(content_tag("div","", object.html_options))
    end

    def high_graph(placeholder, object, &block)
      build_html_output("Chart", placeholder, object, &block)
    end

    def high_graph_stock(placeholder, object, &block)
      build_html_output("StockChart", placeholder, object, &block)
    end

    def build_html_output(type, placeholder, object, &block)
      options_collection = []
      object.options.keys.each do |key|
        k = key.to_s.camelize.gsub!(/\b\w/) { $&.downcase }
        options_collection << "#{k}: #{object.options[key].to_json}"
      end
      options_collection << "series: #{object.data.to_json}"

      graph =<<-EOJS      
      $(document).ready(function() {        
        var options, chart;
        options = { #{options_collection.join(",")} };
        #{capture(&block) if block_given?}
        chart = new Highcharts.#{type}(options);
      });      
      EOJS

      return javascript_tag graph

    end
  end
end
