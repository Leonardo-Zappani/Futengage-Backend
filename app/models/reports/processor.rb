module Reports
  class Processor < ApplicationInteractor
    def call
      context.result = Reports::Charts::DreGraph.call(context: context).transactions if context.params[:graph] == "dre_graph" || !context.params[:graph].present?

      context.result = Reports::Charts::OutDescriptionGraph.call(context: context).result if context.params[:graph] == "out_description_graph"
      context.result = Reports::Charts::InDescriptionGraph.call(context: context).result if context.params[:graph] == "in_description_graph"

      context.result = Reports::Charts::OutPerDayGraph.call(context: context).result if context.params[:graph] == "out_per_day_graph"
      context.result = Reports::Charts::InPerDayGraph.call(context: context).result if context.params[:graph] == "in_per_day_graph"

      context.result = Reports::Charts::OutPerCostCenterGraph.call(context: context).result if context.params[:graph] == "out_per_cost_center_graph"
      context.result = Reports::Charts::InPerCostCenterGraph.call(context: context).result if context.params[:graph] == "in_per_cost_center_graph"

      context.result = Reports::Charts::InPerCategoryGraph.call(context: context).result if context.params[:graph] == "in_per_category_graph"
      context.result = Reports::Charts::OutPerCategoryGraph.call(context: context).result if context.params[:graph] == "out_per_category_graph"

      context.result = Reports::Charts::OutPerTypeGraph.call(context: context).result if context.params[:graph] == "out_per_type_graph"
    end
  end
end
