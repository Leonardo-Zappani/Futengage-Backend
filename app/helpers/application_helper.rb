module ApplicationHelper

  def date_picker_data
    {
      controller: 'date-picker masks',
      action: 'keyup->date-picker#update',
      date_picker_locale_value: I18n.locale,
      date_picker_format_value: t('shared.date_format'),
      masks_pattern_value: t('shared.date_pattern')
    }
  end
end