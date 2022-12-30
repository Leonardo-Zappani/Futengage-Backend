# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def currency_data_params
    {
      controller: 'currency-mask',
      currency_mask_pattern_value: '000.000.000.000,00'
    }
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

  def contacts(selected_contact:)
    list = Current.account.contacts.order(:first_name, :last_name)
    return [selected_contact] + list if selected_contact&.discarded?

    list
  end

  def categories(selected_category:)
    list = Current.account.categories.order(:name)
    return [selected_category] + list if selected_category&.discarded?

    list
  end

  def select_category_data
    {
      controller: 'select-category',
      select_category_allow_deselect_value: true,
      select_category_url_value: categories_path
    }
  end

  def select_contact_data
    {
      controller: 'select-contact',
      select_contact_allow_deselect_value: true,
      select_contact_url_value: contacts_path
    }
  end

  def accepted_currencies
    Transaction::ACCEPTED_CURRENCIES.map { |v| [t("enums.currency.#{v}"), v] }
  end

  def bank_accounts
    Current.account.bank_accounts.order(:name)
  end

  def cost_centers
    Current.account.cost_centers.order(:name)
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
    full_content = [content, (turbo_native if turbo_native_app?)].compact.join(', ')
    tag.meta name: 'viewport', content: full_content
  end

  def url_for_avatar(avattable)
    if avattable.avatar.attached?
      avattable.avatar.variant(resize_to_limit: [100, 100])
    else
      'avatar_placeholder'
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
end
