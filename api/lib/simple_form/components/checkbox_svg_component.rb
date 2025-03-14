# typed: false

module SimpleForm
  module Components
    module CheckboxSvgComponent
      # To avoid deprecation warning, you need to make the wrapper_options explicit
      # even when they won't be used.
      def checkbox_svg(wrapper_options = nil)
        template.content_tag(:svg, class: "pointer-events-none col-start-1 row-start-1 size-3.5 self-center justify-self-center stroke-white group-has-disabled:stroke-gray-950/25", viewBox: "0 0 14 14", fill: "none") do
          template.safe_join([
            template.content_tag(:path, nil, class: "opacity-0 group-has-checked:opacity-100", d: "M3 8L6 11L11 3.5", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round"),
            template.content_tag(:path, nil, class: "opacity-0 group-has-indeterminate:opacity-100", d: "M3 7H11", "stroke-width": "2", "stroke-linecap": "round", "stroke-linejoin": "round")
          ])
        end
      end
    end
  end
end

SimpleForm.include_component(SimpleForm::Components::CheckboxSvgComponent)
