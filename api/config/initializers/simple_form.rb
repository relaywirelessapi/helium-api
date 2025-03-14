# typed: strict
# frozen_string_literal: true


# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/heartcombo/simple_form#custom-components to know
# more about custom components.
Dir[Rails.root.join("lib/simple_form/components/**/*.rb")].each { |f| require f }
#
# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.
  config.wrappers :default, class: "mt-2" do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: "block text-sm/6 font-medium text-gray-900"
    b.use :input, class: "block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6", error_class: "outline-red-500 focus:outline-red-500"
    b.use :hint, wrap_with: { tag: :p, class: "mt-1 text-sm/6 text-gray-600" }
    b.use :error, wrap_with: { tag: :p, class: "mt-1 text-sm/6 text-red-600" }
  end

  config.wrappers :checkbox, class: "flex gap-3" do |b|
    b.use :html5

    b.wrapper class: "flex h-6 shrink-0 items-center" do |ba|
      ba.wrapper class: "group grid size-4 grid-cols-1" do |bb|
        bb.use :input, class: "col-start-1 row-start-1 appearance-none rounded-sm border border-gray-300 bg-white checked:border-indigo-600 checked:bg-indigo-600 indeterminate:border-indigo-600 indeterminate:bg-indigo-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 disabled:border-gray-300 disabled:bg-gray-100 disabled:checked:bg-gray-100 forced-colors:appearance-auto"
        bb.use :checkbox_svg
      end
    end

    b.wrapper class: "text-sm/6" do |ba|
      ba.use :label, class: "font-medium text-gray-900"
      ba.use :hint, wrap_with: { tag: :p, class: "text-gray-500" }
      ba.use :error, wrap_with: { tag: :p, class: "mt-1 text-red-600" }
    end
  end

  config.wrappers :radio, class: "flex items-center gap-x-3" do |b|
    b.use :html5
    b.use :input, class: "relative size-4 appearance-none rounded-full border border-gray-300 bg-white before:absolute before:inset-1 before:rounded-full before:bg-white not-checked:before:hidden checked:border-indigo-600 checked:bg-indigo-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 disabled:border-gray-300 disabled:bg-gray-100 disabled:before:bg-gray-400 forced-colors:appearance-auto forced-colors:before:hidden"
    b.use :label, class: "block text-sm/6 font-medium text-gray-900"
    b.use :error, wrap_with: { tag: :p, class: "mt-1 text-sm/6 text-red-600" }
  end

  config.wrappers :select, class: "mt-2 grid grid-cols-1" do |b|
    b.use :html5
    b.use :label, class: "block text-sm/6 font-medium text-gray-900"
    b.use :input, class: "col-start-1 row-start-1 w-full appearance-none rounded-md bg-white py-1.5 pr-8 pl-3 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
    b.use :error, wrap_with: { tag: :p, class: "mt-1 text-sm/6 text-red-600" }
  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :default

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # Default class for buttons
  config.button_class = "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 cursor-pointer"

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # Use :to_sentence to list all errors for each field.
  config.error_method = :first

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = "p-4 text-sm text-red-800 rounded-lg bg-red-50"

  # Series of attempts to detect a default label method for collection.
  config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  config.collection_wrapper_tag = :div

  # You can define the class to use on all collection wrappers. Defaulting to none.
  config.collection_wrapper_class = "mt-6 space-y-6"

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to :span.
  config.item_wrapper_tag = nil

  # You can define a class to use in all item wrappers. Defaulting to none.
  config.item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| label }

  # You can define the class to use on all labels. Default is nil.
  config.label_class = nil

  # You can define the default class to be used on forms. Can be overridden
  # with `html: { :class }`. Defaulting to none.
  config.default_form_class = "space-y-8"

  # You can define which elements should obtain additional classes
  config.generate_additional_classes_for = []

  # Whether attributes are required by default (or not). Default is true.
  config.required_by_default = true

  # Tell browsers whether to use the native HTML5 validations (novalidate form option).
  # These validations are enabled in SimpleForm's internal config but disabled by default
  # in this configuration, which is recommended due to some quirks from different browsers.
  # To stop SimpleForm from generating the novalidate option, enabling the HTML5 validations,
  # change this configuration to true.
  config.browser_validations = false

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    boolean: :checkbox,
    radio_buttons: :radio,
    select: :select
  }

  # Namespaces where SimpleForm should look for custom input classes that
  # override default inputs.
  # config.custom_inputs_namespaces << "CustomInputs"

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # When false, do not use translations for labels.
  # config.translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache SimpleForm inputs discovery
  # config.cache_discovery = !Rails.env.development?

  # Default class for inputs
  config.input_class = nil

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = nil

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  # config.include_default_input_wrapper_class = true

  # Defines which i18n scope will be used in Simple Form.
  # config.i18n_scope = 'simple_form'

  # Defines validation classes to the input_field. By default it's nil.
  config.input_field_error_class = nil
  config.input_field_valid_class = nil
end
