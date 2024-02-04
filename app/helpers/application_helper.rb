module ApplicationHelper
  def enum_to_dropdown_select_collection(enum, base_i18n_key)
    enum.map do |key, _value|
      [
        t("#{base_i18n_key}.#{key}"),
        key
      ]
    end
  end
end
