module SortableHelper
  def sortable(_relation, column, title, options = {})
    matching_column = column.to_s == params[:sort]
    direction = sort_direction == 'asc' ? 'desc' : 'asc'

    link_to request.params.merge(sort: column, direction:), class: "flex #{options[:class]}" do
      concat title
      if matching_column
        caret = sort_direction == 'asc' ? 'chevron-up' : 'chevron-down'
        concat heroicon(caret, options: { class: 'ml-1.5 h-4 w-4' })
      end
    end
  end
end
