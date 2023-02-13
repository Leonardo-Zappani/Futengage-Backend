# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def field_error_message(object, attribute, custom_css_class = 'field_error_message')
    open_tag  = "<p class=\"#{custom_css_class}\">"
    error     = object&.errors&.full_messages_for(attribute)&.first
    close_tag = '</p>'

    [open_tag, error, close_tag].join.html_safe
  end

  def required_field(message: t('shared.required'))
    "<div class=\"flex absolute right-0 top-0 text-danger-500 space-x-1.5 text-xs items-center\">#{message}</div>".html_safe
  end

  def currency_data_params(allow_negative_value: true)
    if allow_negative_value
      {
        controller: 'currency-mask',
        currency_mask_pattern_value: '000.000.000.000,00'
      }
    else
      {
        controller: 'masks',
        masks_pattern_value: '###.###.###.##0,00',
        masks_reverse_value: true,
        masks_select_on_focus_value: true
      }
    end
  end

  def coalesce(value, default: '-')
    return default if (value || '').strip.blank?

    value
  end

  def expandable_params(expanded:)
    {
      class: expanded && 'text-gray-700 hover:text-gray-700',
      "data-controller": 'expandable',
      "data-expandable-expanded-class": 'bg-gray-100 text-gray-700 hover:bg-gray-100 hover:text-gray-700',
      "data-expandable-rotate-class": 'rotate-90',
      "data-expandable-expanded-value": expanded
    }
  end

  def current_date
    params[:month].present? ? Time.parse(params[:month]).in_time_zone : Current.time.iso8601.in_time_zone
  end

  def accepted_currencies
    Transaction::ACCEPTED_CURRENCIES.map { |v| [t("enums.currency.#{v}"), v] }
  end

  def date_picker_data
    {
      controller: 'date-picker masks',
      action: 'keyup->date-picker#update',
      date_picker_locale_value: I18n.locale,
      date_picker_format_value: t('shared.date_format'),
      masks_pattern_value: t('shared.date_pattern')
    }
  end

  def viewport_meta_tag(content: 'width=device-width, initial-scale=1',
                        turbo_native: 'maximum-scale=1.0, user-scalable=0')
    full_content = [content]
    tag.meta name: 'viewport', content: full_content
  end

  def url_for_avatar(avattable)
    if avattable.avatar.attached?
      avattable.avatar.variant(resize_to_limit: [100, 100])
    else
      'avatar_placeholder.png'
    end
  end

  def greeting_day(hour:)
    case hour
    when 6..11
      t('shared.good_morning', name: Current.user.first_name)
    when 12..16
      t('shared.good_afternoon', name: Current.user.first_name)
    when 17..19
      t('shared.good_evening', name: Current.user.first_name)
    else
      t('shared.good_night', name: Current.user.first_name)
    end
  end

  def text_color_class(value)
    if value.positive?
      'text-success-500'
    elsif value.negative?
      'text-danger-500'
    else
      'text-gray-500'
    end
  end
end