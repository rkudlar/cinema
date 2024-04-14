class ArrayInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    input_html_options[:class].push('mb-2')
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    fields_html = Array(object.public_send(attribute_name)).map do |array_el|
      @builder.text_field(nil, merged_input_options.merge(value: array_el, name: "#{object_name}[#{attribute_name}][]"))
    end.join.html_safe

    if fields_html.blank?
      fields_html = @builder.text_field(nil, merged_input_options.merge(value: '', name: "#{object_name}[#{attribute_name}][]"))
    end

    add_button_html = @builder.template.button_tag("Add #{attribute_name.to_s.humanize}",
                                                   type: 'button',
                                                   data: { action: 'click->array-input#addField' },
                                                   class: 'btn btn-outline-dark')

    fields_container = @builder.template.content_tag(:div,
                                                     fields_html,
                                                     data: { array_input_target: 'content' },
                                                     class: 'mb-2')

    @builder.template.content_tag(:div, fields_container + add_button_html, data: { controller: 'array-input' }).html_safe
  end

  def input_type
    :text
  end
end
