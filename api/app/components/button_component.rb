class ButtonComponent < ViewComponent::Base
  def initialize(text:, style:, full_width: false, **options)
    @text = text
    @style = style
    @full_width = full_width
    @options = options

    super
  end
end
