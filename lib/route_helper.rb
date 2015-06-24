module RouteHelper
  def define_route_helpers(routes)
    routes.each do |route|
      case route.action_name
      when :edit
        opt_str = 'edit_'
      when :new
        opt_str = 'new_'
      else
        opt_str = ''
      end
      class_name = route.controller_class.to_s[0...-10].downcase
      helper_name = "#{opt_str}#{class_name}_url".to_sym
      next if self.class.method_defined?(helper_name)
      self.class.send(:define_method, helper_name) do |*args|
        result = "/#{class_name}"
        if args.count == 1 && args[0].respond_to?(:id)
          result += "/#{args[0].id}"
        end

        case route.action_name
        when :edit
          result += "/edit"
        when :new
          result += "/new"
        end
        result
      end
      # puts "Defining #{helper_name.to_s}"
    end
  end
end
